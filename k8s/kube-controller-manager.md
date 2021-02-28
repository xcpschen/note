# Controller Manager
作为集群管理控制中心，负责集群内`Node,Pod副本，服务端点（Endpoint），命名空间（Namespace）,服务账号(ServiceAccount),资源定额（ResourceQuota）`等管理;
但Node意外宕机时，执行自动化修复流出，确保集群始终处于预期的工作状态。
内部控制组件：
- Replication Controller
- Node Controller
- ResourceQuota Controller
- Namespace Controller
- ServiceAccount Controller
- Token Controller
- Service Controller
- Endpoint Controller

## Replication Controller 
Replication Controller是副本控制器，核心作用：确保在任何时候集群中一个RC（资源对象）所关联的Pod副本数目，保持预设值；与RC（资源对象 Replication Controller） 有所区别，存在控制管理关系。只有Pod的重启策略是`Always`时Replication Controller才会管理Pod.
Replication Controller的职责：
- 确保Pod副本为预期值
- 通过RC的spec.relicas指实现系统扩缩容
- 改变RC中的Pod模版来实现系统滚动升级

## Node Controller
kubelet进程启动时通过API Server注册自身的节点信息，并定时向API Server 汇报状态信息。API Server将信息更新到etcd中。etcd存储信息包括：
- 节点健康状况：
  - 就绪True
  - 未就绪False
  - 未知Unknown
- 节点资源
- 节点名称
- 节点地址信息
- 操作系统版本
- Docker版本
- kubelet版本

Node Controller 通过API Server实时获取Node的相关信息，实现管理和监控集群中各个Node节点的相关控制功能。
如果Controller Manager设置了`--cluster-cidr`参数，则为每个Node配置`Spec.PodCIDR`,并逐个读取Node信息，并和本地nodeStatusMap做比较流出如下：
1. 没有收到节点信息或者第一次收到节点信息，或者处理过程中节点状态变成非健康状态，转**4**
2. 在指定时间内收到新的节点信息，且节点状态发生变化，转**4**
3. 在指定时间内收到新的节点信息，但是节点状态没发生变化，转**5**
4. 用Master节点的系统时间作为探测时间和节点状态变化时间，转**6**
5. 用Master节点的系统时间作为探测时间,用上次节点信息中的节点状态变化时间作为该节点的状态变化时间，转**6**
6. 如果在某段时间内没收到节点状态信息，则是设置节点状态为`Unknown`,并删除节点或同步节点信息

关键点：
- 设置--cluster-cidr后，每个Node配置`Spec.PodCIDR`的CIDR地址属性，可以防止不同节点CIDR地址冲突。
- 

## ResourceQuota Controller
k8s支持三个层次的资源额管理：
1. 容器级别
   1. CPU
   2. Memory
2. Rod级别 ：Pod内所有容器的可用资源限制。
3. Namespace级别，为Namespace(多租户)级别的资源限制：
   1. Pod数量
   2. Replication Controller 数量
   3. Service数量
   4. ResourceQuota数量
   5. Secret数量
   6. 可持有的PV(Persistent Volume)数量

k8s配额管理通过Admissiin Control(准入控制)来控制的，配额约束：
- LimitRanger
  - 作用与Pod和Container上
- ResourceQuota
  - 作用与Namespace上，限制Namespace里各类资源的使用总额

## Namespace Controller
- API Server 创建新的Namespece并存入etcd,Namespace Controller定时通过API Server读取；
- Namespece被优雅删除（API设置删除期限-DeletionTimestamp）,则在etcd中其状态被设置为`Termination`
  - Namespace Controller则删除该Namespace下的ServiceAccount,RC,Pod,Secret,PersistentVolume,ListRange,ResourceQuota,Event等资源对象。后对该Namespace执行finalize操作，删除其spec.finalizers域中的信息。如果域是空的，Namespace Controller通过APIServer删除该Namesapce资源。
  - Admission Controller的NamespaceLifecycle插件来阻止为该Namespace创建新的资源
## Service Controller,Endpoint Controller

### Service Controller
属于k8s集群与外部的云平台至今的一个街口控制器。负责：
- 监听Service的变化:
  - 如果是一个LoadBalancer类型的Service(externalLoadBalancers=true),则Service Controller确保外部云平台上该Service对应的LoadBalancer实例被相应地创建，删除以及更新路由转发表（根据Endpoints的条目）。
### Endpoint Controller
Endpoints表示一个Service对所有Pod副本的访问地址；Endpoint Controller负责生成和维护所有Endpoints对象的控制器：
- 监听Service和对应Pod副本的变化：
  - 监听到Service被删除，则删除和该Service同名的Endpoints对象。
  - 监听到新的Service被创建或者修改，则根据Service信息获取相关Pod列表，然后创建或更新Service对应的Endpoints对象。
  - 监听Pod的事件，则更新它对应的Service的Endpoints对象（增，删，改）

