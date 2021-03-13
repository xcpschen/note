# Concept
![](../assets/gRPC.svg)
## defintion
模式使用 `protocol buffers` 定义接口语言，描述服务接口和有效负荷消息结构，实现远程调用的方法以及参数，返回类型。
## Service Class
### Unary RPC
客户端发送单个请求到客户端，并得到单个响应，如同普通方法调用
```
rpc func(Request) returns (Response);
```
### Server streaming RPC
服务流式RPC,客户端发起一个请求，得到一个流式响应，可以在其上面读取信息直到没有任何信息为止
```
rpc func(Request) returns (stream Response);
```
### Client streaming RPC
客户端流式RPC,客户端用提供的一个数据流写入并发送一系列消息给服务端。一旦客户端完成消息写入，就等待服务端读取这些消息并返回应答。
```
rpc func(stream Request) returns (Response);
```
### Bidirectional streaming RPC
即两边都可以分别通过一个读写数据流来发送一系列消息。这两个数据流操作是相互独立的，所以客户端和服务端能按其希望的任意顺序读写
```
rpc func(stream Request) returns (stream Response);
```
## Using API
gRPC 提供 `protocol buffer` 编译插件，能够从一个服务定义的 `.proto` 文件生成客户端和服务端代码。通常 gRPC 用户可以在服务端实现这些API，并从客户端调用它们。
# article
- [gRPC](https://grpc.io/docs/)
- [gRPC 官方文档中文版](http://doc.oschina.net/grpc?t=58009)