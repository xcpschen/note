
## 经典5种垃圾回收策略
- 标记-清扫 Mark-sweep
  - 经典三色抽象标记
  - 缺点：
    - 容易产生碎片或空洞
    - STW会破坏标记结果，使用强弱三色标记策略规避
- 标记-压缩 Mark-compact：通过将分散、活着的对象移动到更紧密的空间从而解决内存碎片的问题
  - 标记阶段类似标记-清扫
  - 压缩阶段，需要扫描活着的对象压缩到空闲的区域
  - 缺点：
    - 内存对象在内存的位置是随机可变的，会破坏缓存的局部性
    - 需要额外空间来标记当前对象移动到其他地方
- 半空间复制 Semispace copy：只能使用一半的虚拟内存空间，并保留另一半的空间用于快速的压缩内存
  - 空间换时间策略，消除了内存碎片问题
  - 半空间复制不分为多个阶段也没有标记阶段，其在从根对象扫描的时候就可以直接进行压缩。每一个扫描到的对象都会从fromspace的空间复制到tospace的空间。因此，一旦扫描完成，就得到了一个压缩后的副本。
  - 缺点
    - 浪费空间
- 引用技术 reference counting
  - 每一个对象都包含了一个引用计数;每当一个对象引用了此对象时，引用计数就会增加。反之取消引用后，引用计数就会减少。一旦引用计数为0时，表明该对象为垃圾对象，需要被回收。
  - 缺点
    - 没有破坏性操作，也需要更新引用操作，例如只读，循环迭代等
    - 栈上的内存操作或寄存器操作也需要跟新引用计数是难以接受的
    - 原子操作更新，可能会并发操作同个对象
    - 引用计数也无法处理自引用的对象
- 分代GC
  - 前提是：死去的一般都是新创建不久的对象    
  - 按照对象存活时间进行划分
  - 完全没有必要反复的扫描旧对象
  - 优点
    - 加快垃圾回收的速度，提高处理能力和吞吐量，减少程序暂停的时间
  - 缺点
    - 没办法及时回收老一代对象
    - 需要额外开销引用和区分新老对象，特别是多代时
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
   1. 开始阶段 STW，做些准备工作，然后关闭STW
      1. 做些准备工作：
         1. 最重要的任务是清扫上一阶段gc遗留的需要清扫的对象，因为清扫使用了懒清扫策略，当执行下一次GC时，可能没有垃圾对象没有清扫完毕。
         2. 重置各种状态，统计指标
         3. 为每个P启动专门一个用于标记的协程，但并不是所有的标记协程都能得到执行的机会；减少GC而给用户程序带来影响
         4. 开启写屏障
      2. 问题：
         1. `0.25*P`来决定标记协程数量
            1. 其核心代码位于startCycle()中，`dedicatedMarkWorkersNeeded`代表了执行完整的后台标记协程的数量.
            2. 但协程数过小时：P<=3 ,0.25*P不能整数.
         2. 计算标记协程运行的CPU时间为25%
            1. fractionalUtilizationGoal是附加的参数，其小于1；针对为P=1，2，3，6时使用的。代表每个P在标记阶段需要花费百分比的CPU时间去执行后台标记协程，超过这个时间后表示可以被抢占。
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
   1. 并发标记阶段，核心逻辑位于gcDrian
         1. 后台标记任务模式
            1. DedicateMode处理器专门负责标记对象，不会被调度器抢占
            2. FractionalMode协助后台标记，其在整个标记阶段只会花费一定部分时间执行，因此，在标记阶段当完成时间的目标后，会自动退出
            3. IdleMode为当处理器没有查找到可以执行的 协程时，执行垃圾收集的标记任务直到被抢占
         2. 4种指定后台标记协程行为
            1. gcDrainUntilPreempt为当 Goroutine 的 preempt 字段被设置成 true 时返回， 代表当前后台标记可以被抢占
            2. gcDrainFlushBgCredit计算后台完成的标记任务量以减少并行标记期间用户程序执行辅助垃圾收集的工作量
            3. gcDrainIdle对应IdleMode模式, 当处理器上包含其他待执行 协程 时退出
            4. gcDrainFractional对应IdleMode模式,当完成目标时间后退出
         3. 多种模式目的在于维护后台标记协程占用25%CPU时间
   2. 如何调度标记协程运行
            1. 关闭STW后再次启动所有协程时。P进入新一轮的调度循环
            2. 判断是否处于GC状态：
               1. 是则判断是否需要执行后台标记任务。
                  1. 如果dedicatedMarkWorkersNeeded大于0，直接执行后台标记任务
                  2. 否则，判断fractionalUtilizationGoal<0&&当前P执行标记任务的时间 小于 fractionalUtilizationGoal*当前标记周期总时间，仍然会执行后台标记任务，只运行对应CPU时间的25%
               2. 否，则正常协程调度
   3. 三色阶段
      1. 扫描根对象
         1. 全局变量（.bss和.data段内存中）
            1. 需要编译时与运行时的共同努力。
            2. 编译时，如何确定全局变量中哪些位置包含指针，在哪里被引用
               1. ptrmask位图信息，每一位对应.data段中一个指针大小(8byte)；1表示当前位置是指针，当其被引用时，标记其对象为灰色，加入标记队列；
               2. 如何通过该指针找到所对应的对象位置
                  1. Go 所有分配的内存都记录在`mheap.arenas[1 << arenaL1Bits][1 << arenaL2Bits]`对象上，元素为*heapArena;
                  2. heapArena结构存储了许多元数据，其中包括了每一个page ID(8 KB) 对应的mspan `heapArena.spans [pagesPerArena]*mspan`
                  3. 该指针的位置找到对应的mspan，计算mspan下标得对应的span元素；确认存在后，把gcmarkBits对应元素的bit设置为1，并加入标记队列中
            3. 在运行时，才能确定全局变量分配到虚拟内存那个区域
         2. span中的finalizer的任务数量
            1. finalizer是特殊对象，是在对象释放后会调用的析构器，用于资源释放；不会被栈上或全局变量引用，需要单独处理。
            2. 在标记期间，会遍历mspan中的specials链表，扫描finalizer所位于的元素（对象）
         3. 所有协程的栈
            1. 运行时能够计算出当前协程栈的所有栈帧信息，而编译时能够得知栈上哪些地方有指针，以及对象中的哪一个部分包含了指针。
   4. 按三色标记法步骤，标记出清除对象
      1. 查找引用对象
         1. 标记时拿到一个指针P1,通过P1在mheap.arenas[L1][L2]找到对象所属的heapArena,*/64位下计算L1，L2
            1. L1 = 0,L2 = p+constBase/64M
         2. 在heapArena中，通过P1%64M/8K查询到heapArena.spans的索引index，找到所属的span
         3. 查找对象首地址：span.elemsize和span.startAddr
         4. 设置对象的gcmarkBits
         5. 根据heapArena.bitmap来确定是引用还是普通数据。
            1. bitmap是分配对象时根据type信息设置的，type信息来自编译器
            2. 每8字节（一个字）
   5. STW,re-scan全局指针和栈，清理1过程中新分配对象时，写屏障记录的数据，重新检查，停止标记，收缩栈
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