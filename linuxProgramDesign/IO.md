### 常见的模型
- 同步阻塞IO（Blocking IO）：即传统的IO模型。
- 同步非阻塞IO（Non-blocking IO）：默认创建的socket都是阻塞的，非阻塞IO要求socket被设置为NONBLOCK。    注意这里所说的NIO并非Java的NIO（New IO）库。
- IO多路复用（IO Multiplexing）：即经典的Reactor设计模式，有时也称为异步阻塞IO，Java中的Selector和Linux中的epoll都是这种模型。
- 异步IO（Asynchronous IO）：即经典的Proactor设计模式，也称为异步非阻塞IO。（5）基于信号驱动的IO（Signal Driven IO）模型，由于该模型并不常用（略）
#### I/0 操作 主要分成两部分
- 数据准备，将数据加载到内核缓存（数据加载到操作系统）
- 将内核缓存中的数据加载到用户缓存（从操作系统复制到应用中）

`同步和异步的概念描述的是用户线程与内核的交互方式`
`阻塞和非阻塞的概念描述的是用户线程调用内核IO操作的方式`
### 参考文章
- [常见的IO模型有四种](https://www.cnblogs.com/straybirds/p/9479158.html)