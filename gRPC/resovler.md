# resovler
resovler 是实现gRPC支持不同命名系统（name-system）的解析器的插件，其命名：
- gRPC自定义channel名称完全符合[RFC 3986](https://tools.ietf.org/html/rfc3986)的URL命名规则
- 如果使用resovler解析URL规则，则如果没有规则前缀或者未知的，则默认使用dns域名

绝大部分gRPC支持的URL规则：
- dns:[//authority/]host[:port] – DNS (默认)
  - host会被解析为DNS域名参数
  - port作为端口，一般，443作为默认，不排除有些使用80端口作为非安全通道
  - authority 服务器认证信息，特别注意的是，C-core未实现，但是在`c-ares based resolver`可以在`IP:port`模式下支持使用
- unix:path, unix://absolute_path – Unix domain sockets (仅仅在Unix systems)
  - unix:path 本地sockets路径，可以是相对或者绝对
  - unix://absolute_path 下，absolute_path必须是绝对路径
- unix-abstract:abstract_path – 在抽象命名空间下的Unix domain socket (仅仅在Unix systems)
  - abstract_path 意味这名字必须是抽象命名空间下
  - 名字和文件系统没有连接
  - 不管是程序还是用户，无须权限就可以使用该socket
  - 抽象 sockets 使用一个`null`字节 ('\0') 作为第一个字符；实现时需预先设置这个`null`字节，不能把`null`字节包含在abstract_path上
    - [TODO](https://github.com/grpc/grpc/issues/24638),Unix系统支持把`null`字节包含在abstract_path上，但是gRPC c-core不支持

仅仅在gRPC-C中实现支持的URL规则：
- ipv4:address[:port][,address[:port],...] – IPv4 地址
  - 允许多个IP:port，用逗号隔开
  - IPv4地址格式
  - port 默认为443
- ipv6:address[:port][,address[:port],...] – IPv6 地址
  - 允许多个IP:port，用逗号隔开
  - IPv6地址格式
  - port 默认为443

resovler 必须包含认证信息，且解析完后必须返回如下信息：
- 服务地址列表,每个地址都会有一系列健值对去关联它，作为交换信息的LB策略
- 服务配置service config

## 使用

# Aticle
- [gRPC Name Resolution](https://grpc.github.io/grpc/core/md_doc_naming.html)