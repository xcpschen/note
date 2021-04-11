
## GC发展进程
- V1.1 STW
- V1.3 Mark STW ,Sweep 并行
- V1.5 三色标记法
- V1.8 hybrid write barrier 写屏障

### 三色标记法原理
- 起初所有对象标记为白色
- 从根出发扫描所有可达对象，标记为灰色，放入待处理队列
- 从待处理队列取出灰色对象，将其引用对象标记为灰色，入队，自身变成黑色
- 重复上述3步，直到灰色对象队列为空，回收白色对象

## 触发GolangGC
- 堆上分配大于32KB，自动回收，mallocgc函数中
- runtime.GC()显性调用，阻塞
- forcegc sysmon()中检查到forcegcperiod/2未进行GC
- 触发条件判断：
  ```
  func gcShouldStart(forceTrigger bool) bool {
    return gcphase == _GCoff && (forceTrigger || memstats.heap_live >= memstats.gc_trigger) && memstats.enablegc && panicking == 0 && gcpercent >= 0
  }
  ```
### Golang GC流程
![](../assets/golang/gc.png)

   
1. Stack scan阶段:扫描栈中的全局指针和goroutine栈上的指针
   1. 开始阶段 STW，做些准备工作，例如启动写屏障，然后关闭STW
   ```
   func gcStart(mode gcMode, forceTrigger bool) {
        ...
        //在后台启动 mark worker 
        if mode == gcBackgroundMode {
            gcBgMarkStartWorkers()
        }
        ...
        // Stop The World
        systemstack(stopTheWorldWithSema)
        ...
        if mode == gcBackgroundMode {
            // GC 开始前的准备工作

            //处理设置 GCPhase，setGCPhase 还会 enable write barrier
            setGCPhase(_GCmark)
            
            gcBgMarkPrepare() // Must happen before assist enable.
            gcMarkRootPrepare()

            // Mark all active tinyalloc blocks. Since we're
            // allocating from these, they need to be black like
            // other allocations. The alternative is to blacken
            // the tiny block on every allocation from it, which
            // would slow down the tiny allocator.
            gcMarkTinyAllocs()
            
            // Start The World
            systemstack(startTheWorldWithSema)
        } else {
            ...
        }
    }
   ```
2. 标记阶段
   1. 按三色标记法步骤，标记出清除对象
      1. 查找引用对象
         1. 标记时拿到一个指针P1,通过P1在mheap.arenas[L1][L2]找到对象所属的heapArena,*/64位下计算L1，L2
            1. L1 = 0,L2 = p+constBase/64M
         2. 在heapArena中，通过P1%64M/8K查询到heapArena.spans的索引index，找到所属的span
         3. 查找对象首地址：span.elemsize和span.startAddr
         4. 设置对象的gcmarkBits
         5. 根据heapArena.bitmap来确定是引用还是普通数据。
            1. bitmap是分配对象时根据type信息设置的，type信息来自编译器
            2. 每8字节（一个字）
   2. STW,re-scan全局指针和栈，清理1过程中新分配对象时，写屏障记录的数据，重新检查，停止标记，收缩栈
      1. 再次STW，停止标记过程
    ```
    func gcBgMarkStartWorkers() {
        // Background marking is performed by per-P G's. Ensure that
        // each P has a background GC G.
        for _, p := range &allp {
            if p == nil || p.status == _Pdead {
                break
            }
            if p.gcBgMarkWorker == 0 {
                go gcBgMarkWorker(p)
                notetsleepg(&work.bgMarkReady, -1)
                noteclear(&work.bgMarkReady)
            }
        }
    }
    func gcBgMarkWorker(_p_ *p) {
        for {
            // 将当前 goroutine 休眠，直到满足某些条件
            gopark(...)
            ...
            // mark 过程
            systemstack(func() {
            // Mark our goroutine preemptible so its stack
            // can be scanned. This lets two mark workers
            // scan each other (otherwise, they would
            // deadlock). We must not modify anything on
            // the G stack. However, stack shrinking is
            // disabled for mark workers, so it is safe to
            // read from the G stack.
            casgstatus(gp, _Grunning, _Gwaiting)
            switch _p_.gcMarkWorkerMode {
            default:
                throw("gcBgMarkWorker: unexpected gcMarkWorkerMode")
            case gcMarkWorkerDedicatedMode:
                gcDrain(&_p_.gcw, gcDrainNoBlock|gcDrainFlushBgCredit)
            case gcMarkWorkerFractionalMode:
                gcDrain(&_p_.gcw, gcDrainUntilPreempt|gcDrainFlushBgCredit)
            case gcMarkWorkerIdleMode:
                gcDrain(&_p_.gcw, gcDrainIdle|gcDrainUntilPreempt|gcDrainFlushBgCredit)
            }
            casgstatus(gp, _Gwaiting, _Grunning)
            })
            ...
        }
    }
    // gcDrain scans roots and objects in work buffers, blackening grey
    // objects until all roots and work buffers have been drained.
    // 三色标记法的实现
    func gcDrain(gcw *gcWork, flags gcDrainFlags) {
        ...	
        // 扫描root 下对象，并标记
        if work.markrootNext < work.markrootJobs {
            for !(preemptible && gp.preempt) {
                job := atomic.Xadd(&work.markrootNext, +1) - 1
                if job >= work.markrootJobs {
                    break
                }
                markroot(gcw, job)
                if idle && pollWork() {
                    goto done
                }
            }
        }
        
        // 处理 heap 标记
        // Drain heap marking jobs.
        for !(preemptible && gp.preempt) {
            ...
            //从灰色列队中取出对象
            var b uintptr
            if blocking {
                b = gcw.get()
            } else {
                b = gcw.tryGetFast()
                if b == 0 {
                    b = gcw.tryGet()
                }
            }
            if b == 0 {
                // work barrier reached or tryGet failed.
                break
            }
            //扫描灰色对象的引用对象，标记为灰色，入灰色队列
            scanobject(b, gcw)
        }
    }

    // MarkTermination 
    func gcMarkTermination() {
        // World is stopped.
        // Run gc on the g0 stack. We do this so that the g stack
        // we're currently running on will no longer change. Cuts
        // the root set down a bit (g0 stacks are not scanned, and
        // we don't need to scan gc's internal state).  We also
        // need to switch to g0 so we can shrink the stack.
        systemstack(func() {
            gcMark(startTime)
            // Must return immediately.
            // The outer function's stack may have moved
            // during gcMark (it shrinks stacks, including the
            // outer function's stack), so we must not refer
            // to any of its variables. Return back to the
            // non-system stack to pick up the new addresses
            // before continuing.
        })
        ...
    }
    ```
3. 清扫阶段 sweep :清理为标记对象，调整GC节奏为下一次GC做准备
    ```
    func gcSweep(mode gcMode) {
        ...
        //runtime.GC阻塞式
        if !_ConcurrentSweep || mode == gcForceBlockMode {
            // Special case synchronous sweep.
            ...
            // 清扫所有spans
            for sweepone() != ^uintptr(0) {
                sweep.npausesweep++
            }
            // Do an additional mProf_GC, because all 'free' events are now real as well.
            mProf_GC()
            mProf_GC()
            return
        }
        
        // 并行式
        // Background sweep.
        lock(&sweep.lock)
        if sweep.parked {
            sweep.parked = false
            ready(sweep.g, 0, true)
        }
        unlock(&sweep.lock)
    }
    func bgsweep(c chan int) {
        sweep.g = getg()

        lock(&sweep.lock)
        sweep.parked = true
        c <- 1
        goparkunlock(&sweep.lock, "GC sweep wait", traceEvGoBlock, 1)

        for {
            for gosweepone() != ^uintptr(0) {
                sweep.nbgsweep++
                Gosched()
            }
            lock(&sweep.lock)
            if !gosweepdone() {
                // This can happen if a GC runs between
                // gosweepone returning ^0 above
                // and the lock being acquired.
                unlock(&sweep.lock)
                continue
            }
            sweep.parked = true
            goparkunlock(&sweep.lock, "GC sweep wait", traceEvGoBlock, 1)
        }
    }
    func gosweepone() uintptr {
        var ret uintptr
        systemstack(func() {
            ret = sweepone()
        })
        return ret
    }
    // sweeps one span
    // returns number of pages returned to heap, or ^uintptr(0) if there is nothing to sweep
    func sweepone() uintptr {
        ...
        for {
            s := mheap_.sweepSpans[1-sg/2%2].pop()
            ...
            if !s.sweep(false) {
                // Span is still in-use, so this returned no
                // pages to the heap and the span needs to
                // move to the swept in-use list.
                npages = 0
            }
        }
    }

    // Sweep frees or collects finalizers for blocks not marked in the mark phase.
    // It clears the mark bits in preparation for the next GC round.
    // Returns true if the span was returned to heap.
    // If preserve=true, don't return it to heap nor relink in MCentral lists;
    // caller takes care of it.
    func (s *mspan) sweep(preserve bool) bool {
        ...
    }
    ```
### 相关对象
- gcWork 灰色对象管理队列，存在每个P上

## 写屏障
编译器在写操作是特意加入一段特殊代码，对应的还有读屏障，增加写屏障原因：`回收过程中，用户程序会一直修改内存情况，容易导致误漏标记问题，从而导致误回收和漏回收问题`

- v1.7之前使用 Dijkstra-style insertion write barrier [Dijkstra ‘78] 算法，STW主要消耗在re-scan上
- v1.8 之后采用混合write barrier方式 来避免re-scan的消耗，查看[设计](https://github.com/golang/proposal/blob/master/design/17503-eliminate-rescan.md)
  - Yuasa-style deletion write barrier [Yuasa ‘90]
  - Dijkstra-style insertion write barrier [Dijkstra ‘78]

# 总结
golang 

- [Golang 垃圾回收剖析](http://legendtkl.com/2017/04/28/golang-gc/?spm=a2c6h.12873639.0.0.3c2766bbBgiPS7)
- [万字长文深入浅出 Golang Runtime](https://zhuanlan.zhihu.com/p/95056679)