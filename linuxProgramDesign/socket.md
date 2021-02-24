伯克利版本的UNIX系统引入套接字接口（socket interface）是管道概念的拓展。
windows Sockets技术规范-WinSock 实现windows版本的套接字接口，服务由系统文件Winsock.dll提供
套接字机制可以实现多个客户端连接到一个服务器
#### 套接字工作原理
- 通信机制，凭借这种机制实现多客户端连接服务器，即使跨网络
- 如何利用套接字维持一个连接
  - 服务器
    1.服务器调用系统调用socket创建一个套接字，类似文件描述符资源，不能与其他进程共享
    2.服务器进程创建命名套接字。系统调用bind操作命名
      - 本地连接，存放/tmp/或者/usr/tmp
      - 网络连接,它的名字是与客户端连接的特定网络由关的服务标识符（端口号或者访问点）将允许进入该特定端口的连接转到服务器进程
      
    3.服务器进入等待客户端连接到这个命名套接字，系统调用listen创建一个队列存放来自客户端的连接
    4.服务器使用系统调用accept时，创建一个与原有命名的套接字不同的新套接字，来接收来自客户端的连接。这个新的套接字只能用于与这个特定客户端通信。而命名套接字（服务器创建的）继续处理来自其他的客户端连接
  - 客户端
    1.调用socket创建一个**未命名**的套接字 
    2.用服务器的命名套接字作为地址来调用connect与服务器建立连接
  
#### 套接字属性，地址和通信
- 套接字属性
  地址作为它的名字，格式随域（协议族 protocol family）不同而不同
    - 域
      指定通信中使用的介质。
      1.常见的时AF_INET,Internet网络，局部网也可以使用，底层协议-`IP(网际协议)`，通过使用IP地址来指定网络计算机，端口号指定计算机上的服务进程
      2.AF_UNIX-UNIX文件系统域，底层协议时文件输入输出，其地址是文件名，可靠双向通信路径
      3.AF_ISO
      4.AF_XNS
      ...
    - 类型
      通信机制
      1.流套接字-TCP/IP
      提供一个`有序，可靠，双向字节流的连接`,即使发送过程发送错误也不会显示出来，行为可预见
      SOCK_STREAM 指定，在AF_INET域中通过TCP/IP连接实现
        - 数据的发送/接收
            - 大消息被分片，传输，再重组，类似文件流
            - 接收大量数据，然后以小块数据块写盘
        
      2.数据报套接字-UDP/IP
      SOCK_DGRAM指定，不建立和维持一个连接。可以对发送的数据报长度限制。作为单独网络消息被传输，可能丢失，复制或乱序到达
    - 协议
- 函数
`#include <sys/types.h>`
`#include <sys/socket.h>`
  - 创建套接字
  `int socket(int domain, int type, int protocol)`
  创建一个套接字，返回一个描述符
    - domain
        指定协议族,常用AF_UNIX，AF_INET
        | 域 | 说明 |
        |----|---|-|
        |AF_UNIX |UNIX域协议 ，文件系统套接字|
        |AF_INET |ARPA因特网协议（UNIX网络套接字），TCP/IP网络通信，Windows也提供了对该套接字域访问的功能|
        |AF_ISO |ISO标准协议|
        |AF_NS |施乐（Xerox）网络系统协议|
        |AF_IPX |Novell IPX协议|
        |AF_APPLETALK |Appletalk DDS|
    - type 指定通信类型
    SOCK_STREAM 字节流套接字
    SOCK_DGRAM  数据报套接字
    - protocol 指定协议
    一般协议由套接字类型和套接字域决定，默认为0
  - 套接字地址
  每个域都有自己地址格式，
    - AF_UNIX域套接字地址结构
    #include <sys/un.h>
    ```
    struct sockaddr_un{
        //套接字域的成员
        sa_family_t  sun_family;
        //在AF_UNIX域中，文件名,Linux限制108个字符，UNIX_MAX_PATH可以查看
        char        sun_path[];
    }
    ```
    - AF_INET 套接字地址结构
    ```
    #include <netinet/in.h>
    
    struct sockaddr_in{
        short int           sin_family;
        unsigned short int   sin_port;
        struct in_addr       sin_addr;
    }
    struct in_addr {
        unsigned long int s_addr;
    }
    ```
  - 命名套接字
    AF_INET套接字会关联一个IP端口号.
    ```
    #include <sys/socket.h>
    
    int bind(int socket, const struct sockaddr *address, size_t address_len);
    ```
    - 参数
        - socket
        - *sockaddr    地址结构指向指针
        - address_len 地址结构长度
    - return 
      1.成功为0
      2.失败为-1 并设置errno
       |errno值|说明|
       |-|-|
       |EBADF|描述符无效|
       |ENOTSOCK|文件描述符不是套接字|
       |EINVAL|文件描述符对应的是一个已命名的套接字，被绑定了|
       |EADDRNOTAVAIL|地址不可以|
       |EADDRINUSR|地址已经绑定了一个套接字|
       |AF_UNIX错误码|
       |EACCESS|权限不足，不能创建路径名文件|
       |ENDOTDIR,ENAMETOOLONG|文件名不符合要求|
  - 创建套接字队列
      ```
      #include <sys/socket.h>
      int listen(int socket,int backlog);
      ```
    - 参数
      - backlog 设置队列长度最大限制
    - return
      1.成功则0
      2.失败为-1，错误码包括EBADF，EINVAL，ENOTSOCK和bing一样
  - 接受连接
    ```
    int accept(int socket, struct sockaddr  *address,size_t *address_len)
    ```
    当客户端（套接字队列第一个未处理连接）程序试图连接时，创建一个新的套接字域客户端进行通信，返回文件描述符，新的套接字类型和服务器监听套接字类型一样。
    1.阻塞形 默认，O_BLOCK
    2.未阻塞形，设置O_NONBLOCK
    使用fcntl来改变这一行为
    ```
    int flags = fcntl(socket,F_GETFL,0)
    fcntl(socket,F_SETFL,O_NONBLOCK|flags)
    ```
  - 请求连接
    1.客户端程序通过一个未命名的套接字和服务器监听的套接字之间建立方法来连接到服务器进程。
    2.如果不能立刻建立，则将被阻塞一段不确定时间，一旦超时则放弃，调用失败。
    3.如果connect调用被一个信号中断，且信号得到处理，connect调用还是失败，errno为EINTR,但是尝试连接并没终止，以异步方式继续，程序必须此后检查是否连接上。
    4.与accept一样，阻塞行为可以通过O_NONBLOCK标志位来修改。此时不能立刻建立，则失败并设置EINPROGRESS,连接将以异步进行
    4.异步连接，可以用select调用检查套接字是否已经处于写就绪状态
    ```
    int conect(int socket, const struct sockaddr *address, size_t address_len)
    ```
    - return 
        1.成功为0
        2.失败为-1，错误码入下
        |errno|说明|
        |-----|----|-|
        |EBADF|文件描述符无效|
        |EALREADY|该套接字上已经有一个正在进行的连接|
        |ETIMEDOUT|连接超时|
        |ECONNEFUSED|连接请求被服务器拒绝|
  - 关闭套接字
    close
    服务器端，在read返回0时关闭，如果套接字时一个面向连接类型，并设置了SOCK_LINGER时，close调用套接字时，有未传输数据时阻塞
  - 主机字节序和网络字节序
    为了使不同类型的计算机可以在通过网络传输的多字节整数值达成一致，需定一个一个网络字节序。
    在传输数据之前，客户端/服务器内部整数表达方式转换成网络字节序。
    定义在`netinet./in.h`
    ```
    //长整型 主机字序列转换为网络字节序
    unsigned long int htonl(unsigned long int hostlong);
    //短整数，主机字序列转换为网络字节序
    unsigned short int htons(unsigned short int hostshort);
    //长整型 网络字节序转换为主机字序列
    unsigned long int ntohl(unsigned long int netlong);
    //短整数，网络字节序转换为主机字序列
    unsigned short int ntohs(unsigned short int netshort);
    ```
    上面函数将16位和32位的整数在主机字节序和标准网络字节序之间转换
  - 套接字选项
    `int setsockopt(int socket, int level, int option_name, const void *option_value, size_t option_len)`
    控制套接字连接行为
    - 参数
        - socket
        - level
          1.想要在套接字级别设置选项，必须设置为SOL_SOCKET
          2.如果底层协议级别为TCP,UDP等，则设置数必须设置为该协议的编号。可以通过头文件`netinet/in.h或者函数getprotobyname获得`
        - option_name
            指定要设置的选项，设定选项的新值，它被传给底层设置选项，且不能被修改
            ||选 项| 说明|
            |-|----|-----|
            |SO_DEBUG|打开调试|
            |SO_KEEPALIVE|通过定期传输保持存活报文来维持连接|
            |SO_LINGER|在close调用返回之前完成传输工作|
        - *option_value
            1.SO_DEBUG，SO_KEEPALIVE指定的选项用整数的值来设置选项的开（1）或关（0）
            2.SO_LINGER 使用`<sys/socket.h>`中定义的linger结构来定义该选项的状态和套接字关闭前的拖延时间
        - option_len
            option_value的字节长度
    - return 
        成功0，失败-1
#### 网络信息和互联网守护进程（inetd/xinetd）
##### 网络信息
- DNS
  Domain Name Service 域名服务
  - 函数
    - 查询主机或者地址相关
        ```
        #include <netdb.h>
        struct hostent *gethostbyaddr(const void *addr, size_t len, int type);
        struct hostent *gethostbyname(const char *name);
        struct hostent{
            char *h_name;
            char **h_aliases;
            int h_addrtype;
            int h_length;
            char **h_addr_list;
        }
        ```
    - 查询与服务及其关联端口号有关的信息
        ```
        #include <netdb.h>
        
        struct servent *getservbyname(const char *name, const char*proto)
        struct servent *getservbyport(const port,const char *proto)
        
        struct servent{
            char *s_name;
            char **s_aliases;
            int s_port;
            char *s_proto;
        }
        ```
        proto 参数指定用于连接该服务的协议，tcp/udp
    - 获取主机数据库信息
        1.调用gethostbyname
        2.把返回的地址列表转换正确地址类型
        3.用inet_ntoa将它们从网络字节序转成主机字节序
    - inet_ntoa
        将因特网主机地址转成点分四元组字符串
        ```
        #include <arpa/inet.h>
        char *inet_ntoa(struct in_addr in)
        ```
    - gethostbyname
        ```
        #include <unistd.h>
        int gethostbyname(char *name,int namelength)
        ```
##### 因特网守护进程（inetd/xinetd）

#### 客户和服务器
##### 多客户端连接
- select系统调用
    允许程序同时在多个底层文件符上等待输入的到达/输出的完成，服务器可以通过同时打开多个套接字上等待请求到来的方法处理多个客户端
    - 函数
        对数据结构fd_set进行操作，它由打开的文件描述符构成的集合，一组定义好的宏可以控制这些集合
        ```
        #include <sys/types.h>
        #include <sys/time.h>
        //初始化fd_set集合
        void FD_ZERO(fd_set *fdset);
        //清除fd_set集合
        void FD_CLR(int fd, fd_set *fdset);
        //设置fd_set集合
        void FD_SET(int fd, fd_set *fdset);
        //fd指向的文件描述符由fdset指向的集合中的一个
        void FD_ISSET(int fd, fd_set *fdset);
        //fd_set 结构中容纳文件描述符的最大数目
        FD_SETSIZE
        ```
        - select超时处理
            ```
            #include <sys/time.h>
            超时值定义
            struct timeval {
                time_t tv_sec; //秒
                long tv_usec; //微秒
                
            }
            ```
        - select调用
            ```
            int select(int nfds,fd_set *readfds,fd_set *writefds,fd_set *errorfds,struct timeval *timeout)
            ```
            用于测试文件描述符集合中，是否有一个文件描述符已处于可读或者可写抑或错误状态，它将阻塞以等待某个文件描述符进入上述的状态。3个描述符集合可为空，则表示不执行相应的测试
            - 参数
                1.int ndfs
                    需要用于测试的文件描述符数目，0-ndfs-1
                2.readfds 
                    可读描述符集合
                3.writefds
                    可写文件描述符集合
                4.errorfds
                    错误文件件描述符集合
                5.timeout
                    如果3种情况都不发送，timeout指定超时时间多久才返回。如果超时返回，则所有描述符集合都被清空
            - return 
                1.调用返回状态发生变化的描述符总数
                2.失败返回-1，设置errno
#### 数据报
