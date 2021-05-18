# Client

## 概述

![](../etcd/client.webp)

- Etcd client v3是基于grpc实现的，借用其框架实现`地址管理、连接管理、负载均衡`等；而底层对每个Etcd的server只需维持一个http2.0连接。
- Etcd client v3包装了一个grpc的ClientConn，然后实现了Resolver和Balancer来管理它和与它交互。
- Etcd client v3实现了grpc中的Resolver接口，用于Etcd server地址管理。当client初始化或者server集群地址发生变更（可以配置定时刷新地址）时，Resolver解析出新的连接地址，通知grpc ClientConn来响应变更。
- Etcd client v3实现了grpc中的Balancer的接口，用于连接生命的周期管理和负载均衡等功能。当ClientConn或者其代表的SubConn状态发生变更时，会调用Balancer的接口以通知它。Balancer会生成一个视图Picker给ClientConn，供其选取可用的SubConn连接。
底层的SubConn又包装了Http2.0的连接ClientTransport。ClientTransport会维持与服务器的心跳，当连接断开会向上通知，让ClientConn通知Balancer去重建连接
总之，Balancer和Resolver像是ClientConn的手，但是由用户去定义它们的具体实现；而SubConn则是ClientConn的内脏，是其实现功能的基础。

#
- [](https://www.jianshu.com/p/281b80ae619b)