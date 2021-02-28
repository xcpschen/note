# kube-apiserver
k8s核心功能，对外提供管理资源（Pod,RC,Service）的api接口,对内操作etcd，简单服务服务验证，网络代理；集群内各个功能模块之间的数据交互和通信中心，是整个系统的数据总线和数据中心。其功能特性：
- 集群管理API入口
- 资源额控制入口
- 提供了完备的集群安全机制

## 启动参数

## API

### Node
kube-apiserver 收到REST请求转发某个Node上的kubelet守护进程到REST端口上，由kubelet进程负责响应。接口的REST路径为`/api/v1/proxy/nodes/{name}`,name为IP或者Node name:
- /api/v1/proxy/nodes/{name}/pods/ : 列出指定节点内所有Pod的信息，数据来自Node而非etcd数据库
- /api/v1/proxy/nodes/{name}/stats/ : 列出指定节点内物理资源的统计信息
- /api/v1/proxy/nodes/{name}/spec/ : 列出指定节点概要信息

kubelet进程启动时包含`--enable-debugging-handlers=true`,会增加接口：
- /api/v1/proxy/nodes/{name}/run :在节点上运行某个容器
- /api/v1/proxy/nodes/{name}/exec :在节点上某个容器中运行某条命令
- /api/v1/proxy/nodes/{name}/attach : 在节点上attach某个容器
- /api/v1/proxy/nodes/{name}/portForward : 实现节点上的Pod端口转发
- /api/v1/proxy/nodes/{name}/logs :列出节点的各类日志信息，例如tallyloglastlog|wtamp|ppp/|rhsm/|audit/|tuned/anaconda/
- /api/v1/proxy/nodes/{name}/metrics : 列出和该节点相关的Metrics信息
- /api/v1/proxy/nodes/{name}/runningpods : 列出节点内运行中的Pod信息
- /api/v1/proxy/nodes/{name}/debug/pprof : 列出节点内当前web服务的状态，包括CPU占用情况和内存使用情况等
### Pod
Pod的proxy接口，在k8s集群之外访问某个Pod的容器服务时，可以使用Proxy API，多用于管理目的
- /api/v1/proxy/namespaces/{namespace}/pods/{name}/{path:*} :访问Pod的某个服务接口
- /api/v1/proxy/namespaces/{namespace}/pods/{name} :访问Pod
- /api/v1/namespaces/{namespace}/pods/{name}/proxy/{path:*} :访问Pod的某个服务接口
- /api/v1/namespaces/{namespace}/pods/{name}/proxy :访问Pod
### Server
与Pod的接口定义基本一样：
- /api/v1/proxy/namespaces/{namespace}/services/{name} :访问server
- /api/v1/proxy/namespaces/{namespace}/services/{name}/{path:*} :访问server的接口
## 模块之间的通信
集群内各个模块功能通过API Server将信息存入etcd,但需要这些信息数据时，通过API Server提供REST接口实现，从而实现各个模块之间的信息交互。
使用缓存来缓解对API Server的访问压力。
### kubelet进程与API Server的交互
每个Node节点上的kubelet每个一个时间周期，就调用一次API Server的REST接口报告自身状态，API Server则接受信息后更新etcd;
kubelet通过API Server的Watch接口监听Pod信息：
- 新的Pod副本被调度绑定到本节点，则执行Pod对应容器的创建和启动逻辑。
- 删除Pod对象时，则删除本节点上相应Pod容器。
- 修改Pod信息时，则修改本节点Podd的容器。
### kub-controller-manager进程与API Server的交互
通过API Server提供Watch接口，实现监控Node的信息，并处理。
### kube-scheduler与API Server的交互
通过API Server提供Watch接口监听新建Pod副本的信息后，检索所有符合该Pod要求的Node列表，开始执行Pod调度逻辑，调度成功后将Pod绑定到目标Node上