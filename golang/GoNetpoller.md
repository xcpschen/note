

#### netpoller
converts asynchronous I/O into blocking I/O is called the netpoller
在自己的线程中，接收来自goroutines 网络I/O事件。
netpoller 使用OS提供监听network sockets 的接口。
- Linux 使用epoll
- BSDs 和Darwin 使用kqueue
- Windows 使用IoCompletionPort
#### 原理
go 使用OS提供的异步IO接口，通过GMP调度，使得正在I/O的goroutines挂起等待。
无论何时，go 打开或接受连接，文件描述符（socket）都会被设置为非阻塞模式。这意味着如果你尝试去操作I/O，文件描述符都是未就绪，都会返回一个错误码。无论何时，一个goroutines尝试在连接里读或写，网络代码都会去操作，直到接受到一个error,然后调用netpoller，当准备再次I/O操作时，它尝试去通知goroutines，goroutines被调度离开线程，然后运行在其他的goroutines。
当netpoller接受到来自OS可以在文件描述符里操作网络I/O的通知时，它会查看它内部的数据指令，如果有阻塞的goroutines，则通知它们，goroutines之后可以继续尝试I/O操作，然后继续阻塞，成功调用。