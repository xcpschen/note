### 并发模型实现原理
操作系统根据资源访问权限的不同，体系架构可分为用户空间和内核空间；内核空间主要操作底层硬件资源，分配进程空间等操作，例如CPU,I/O,内存等分配。运行在操作系统上的程序（进程），所在的空间为用户空间，不可以直接访问底层硬件，只能同系统调用陷入内核态进行资源的访问。
进程是计算机上分配，管理内存的最小单位，其运行着一个或多个线程地址空间和这些线程所需要的系统资源；线程是cpu的最小执行单位。
当线程运行处于阻塞状态时，挂起占用的cpu资源，让出给其他线程处理。这种看上去像是同时多个线程同时工作现象，我们称为并发
故并发执行的单位在于执行线程数量。
- KSE
    操作系统本身内核态的线程
#### 线程模型
1. 用户级线程模型(N:1)
    ![7d0c7eec8c9f9bc53795579d599a79d2.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p29)
    用户态空间几个线程运行在一个操作系统线程上。
    - 优点
        单核下，方便快速上下文切换
    - 缺点
        多核模式下，切换麻烦
2. 内核级线程模型(1:1)
    ![e084e33aca5426eb8bf1bc140d9f61b2.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p30)
    一个线程执行匹配一个内核线程
    - 优点
        充分利用所有的CPU核
    - 缺点
        因为陷入系统内核，所以上下文切换慢
3. 两级线程模型(M:N)
    ![ee3168ff957e2993432249d5d40f0b14.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p32)
    任意数量协程调度在任意数量系统线程上。
    - 优点
        充分利用CPU核数，快速上下文切换
    - 缺点
        用户态调度复杂性
#### Go线程实现的GMP调度并发模型
GMP调度模型，是属于两级线程模型(M:N)
##### GMP模型
![a83e003b1a167ec58511f76c71a3626e.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p33)
- M
  代表着操作系统的线程，操作系统管理其执行，类似标准POSIX线程一样工作，在golang `runtime` 代码中被称为机器M.
- P
  上下文调度，运行着go代码的单线程。挂在着G的执行队列。负责调度G的运行，实现`M:N`模型调度的地方，被称为处理器（模拟）P
  P的数量默认根据环境属性`GOMAXPROCS`决定，可以使用`GOMAXPROCS()`动态设定
- G
  goroutine，go协程，拥有自己的栈，指令等信息，可以被channel阻塞，go语言执行的最小单位，在`runtime`被称为G
##### GMP工作架构图
![74865c50f5d29fff1e436d937e9ba3e7.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p36)
上图是2个线程`M` ，每个M拥有一个上下文`P` ，每个P运行则一个`G`（和M,P同颜色的），且拥有一个灰色的G队列，等待被调度执行。一旦G被调度到，则弹出执行队列,设置G的栈，指令指针，然后开始执行。
每个P拥有自己本地的G的执行队列（灰色）。还有一个全局的G的执行队列，用于存放被阻塞或者从系统调用回来后等待被执行的G.
##### 陷入系统调用时
![e5287f89cbd13635add80dc3d48c5e14.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p34)

##### P如何偷取G
![d280592b1f2ba5c4988e0335056f1410.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p35)
当P挂在M下时，且没有可执行的G，执行队列为空时，会从全局变量G的执行队列偷取G,或者其他的P下偷取，每次从其他P上偷取一半的G.
##### 系统线程并发模型
![90752088f0604eb6ec35b6ec41f06579.png](evernotecid://2B0A12FB-E62F-416E-8574-4CB5888E1A40/appyinxiangcom/20623507/ENResource/p28)

### Go的CSP并发协程通信模式
> GSP `communicating sequential processes`

#### GO 实现两种并发进程通信模式
1.多线程共享内存
    传统并发模式
2.GSP并发模式
#### Go的GSP并发模型
通过`goroutine`和`channel`来实现 
`ch :=make(chan type,size)`
- `ch <- data` 信息发送到管道里
- `data<-ch` 从管道里收取消息
### 参考文章
- [Go并发原理](https://i6448038.github.io/2017/12/04/golang-concurrency-principle/)
- [The Go scheduler](https://morsmachine.dk/go-scheduler)
- [Original design doc](https://docs.google.com/document/d/1TTj4T2JO42uD5ID9e89oa0sLKhJYD0Y_kqxDv3I3XMw)