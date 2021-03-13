# Pod
## 定义&用法
### yaml文件参数说明
## 特殊Pod- 静态pod

## Pod容器共享Volume

## 配置管理&容器内获取 Pod信息

## 配置管理

## 容器内获取 Pod信息（DownwardAPI）
### 环境变量方式
### 文件方式

## 生命周期&重启策略

### Pod生命周期的状态
- Pending 至少有一个容器创建成功，
- Running 至少有一个容器处于运行状态，
- Succeeded 所有的容器正常退出，不再重启
- Failed 至少有一个容器退出异常
- Unknown 某种原因导致无法获取该Pod的状态

### 重启策略-RestartPolicy
在 Pod 所处的 Node 上 由 **kubelet**进行判断和重启操作。当某个容器异常退出或者健康检查失败时， kubelet
将根据 RestartPolicy 的设置来进行相应的操作 。策略如下:
- Always 容器失效时，由kubelet自动重启容器
- OnFailure 容器终止运行且状态码不为0时，由kubelet自动重启容器
- Nerver 无论容器状态如何，由kubelet都不会重启容器

kubelet重启失效容器时间间隔`sync-frequency*2n`来计算，最长延时5分钟，成功重启后10分钟后重制该时间

Pod 的 重启策略与控制方式息息相关.管理 Pod 的控制器包括：
- ReplicationController（RC）
- Job
- DaemonSet
- 直接kubelet管理(静态 Pod)

每种控制器对 Pod 的重启策略要求如下：
- RC 和 DaemonSet:必须设置为 Always，需要保证该容器持续运行。
- Job: OnFailure 或 Never，确保容器执行 完成后不再重启。
- kubelet: 在 Pod 失效时自动重启它，不论将 RestartPolicy 设置为什么值，也不 会对 Pod 进行健康检查。

### 常见场景
```
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Pod包含的容器数  |  Pod当前状态 |  发生事情     |             Pod的结果            |
+                 |             |             +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                 |             |             |RP=Always|RP=OnFailure|RP=Never  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|   1 Container   |  Running    |  O成功退出   | Running  | Succeeded | Succeeded|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|   1 Container   |  Running    |  成功失败    | Running  |  Running  |  Failed  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|   2 Container   |  Running    | 1个成功退出   | Running  | Running  |  Running  |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|   2 Container   |  Running    |   被OOM杀掉  | Running  | Running  |  Failed   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```
## 健康检查
### LivenessProbe
kubelet 定期执行 LivenessProbe 探针来诊断容器的健康状况 。 LivenessProbe 有以下 三种实
现方式。
- ExecAction 容器内部执行一个命令，返回码为0则表示健康
- TCPSocketAction 与容器的IP地址和端口号执行TCP链接建立建立检查，成功则表示健康
- HTTPGetAction 请求容器暴露出来的IP地址，端口好，HTTP Get方法，响应码为`200～400`之间则认为是健康的
`initialDelaySeconds` 可以设置容器启动后首次健康检查等待时间，`秒`
`timeoutSenconds` 健康检查超时时间，`秒`
### ReadinessProbe
用于判断容器是否启动完成，达到`ready`状态,可以接受请求，如果失败则修改Pod状态，Endpoint Controller将从Server的EndPoint删除包含该容器所在的Pod的Endpoint。

## 调度
通常需要通过 Deployment、 DaemonSet、 RC、 Job 等对象来完成一组 Pod 的调度与自动控制功能。
### Deployment,RC:全自动调度-维持集群副本数据
Deployment/RC 通过设置预期副本数，由Scheduler决定调度，可以通过NodeSelector，NodeAffinity，PodAffinity等细腻控制调度到Node
### NodeSelector:定向调度
Scheduler调度Pod,此过程是自动化的，通常无法知道被调度到那个Node上，但是可以在Node上打上标签，然后创建Pod时指定NodeSelector属性为Node标签，完成定向调度。
#### K8s预定义Node标签
### NodeAffinity: Node 亲和性调度策略
NodeSelector策略的下一代调度策略，在NodeSelector基础上增加`In, NotIn, Exists, DoesNotExist, Gt, Lt`等操作来灵活匹配Node,同时增加了一些设置亲和性调度策略：
- RequiredDuringSchedulingRequiredDuringExection
  - 类似NodeSelector，但在Node不满足条件下，移除Node上之前调度Pod
- RequiredDuringSchedulingIgnoredRequiredDuringExection
  - 与RequiredDuringSchedulingRequiredDuringExection类似，但是不一定移除Pod
- PreferedDuringSchedulingIgnoredRequiredDuringExection
  - 满足最优先调度，不满足时，不一定移除Pod

#### 注意规则事项
- 同时定义NodeSelector，NodeAffinity时必须同时满足才能定向调度
- NodeAffinity中匹配一个成功即可
- NodeAffinity中的NodeSelectorTerms 多个mathExpressions,必须全部满足

### PodAffinity: Pod 亲和与亘斥调度策略

### DaemonSet:特定场景调度，在每个 Node 上调度一个 Pod
与RC的调度算法类似，也可以定义NodeSelector，NodeAffinity调度
### Taints 和 Tolerations (污点相容忍)
#### 适合应用场景
- Node上运行一个GlusterFs存储或者Ceph存储的daemon进程
- Node上运行一个日志采集进程
- Node上运行一个健康程序，采集Node性能数据

### Job:批处理调度
k8s job资源对象来定义一个批处理任务，可并行或串行启动多个计算进程处理工作项。
#### 按处理任务方式可以分4种：
- Job Template Expansing
  - 一个Job对象对应一个工作项目
  - 适合工作项目数目少，处理数据较大场景
  - 用户程序需要相应修改
  - `k8s支持`
- Queue with Pod Per Work Item
  - Work Item存放在队列里，一个Job去消费处理
  - Job启用N个Pod处理，每个Pod处理一个Work Item
  - 用户程序可能需要相应修改
  - `K8s支持`
- Queue with Variable Pod Cound
  - 与Queue with Pod Per Work Item类似，不同的是Pod数量可变
  - `K8s支持`
- Single Job with Static Work Assignment
  - 静态程序分配任务项目，Job启用N个Pod处理
  - 用户程序需要相应修改

#### K8s的三种 Job类型
- Non-parallel Jobs
  - 一个Job一个Pod,Pod异常则重启，结束则结束
- Parallel Jobs with a fixed completion count
  - 多个Job并行启动多个Pod，spec.parallelism参数控制Job的数量
  - spec.completion控制正常Pod结束的数量预制，满足后结束Job
- Parallel Jobs with a work queue
  - 任务队列方式并行Job,无法设置spec.completion，Job有特性：
    - 每个Pod能独立判断和决定是否有任务项目需要处理
    - 如果某个Pod正常结束，Job不会再启动Pod
    - Pod成功结束，则应该不存在其他Pod还在工作，其状态应该是`即将结束，退出`状态
    - 所有Pod都结束，且至少有一个Pod成功结束，Job算是成功
### Cronjob:定时任务
### 自定义调度器

## 初始化容器（Init Container）

## 升级和回滚
### Deployment 的升级
Pod 是通过 Deployment 创 建的，则用户可以在运行时修改 Deployment 的 Pod 定义 (spec.template)或镜像名称 ，井应用到 Deployment 对象上，系统即可完成 Deployment 的自 动更新操作。如果在更新过程中发生了错误， 则还可以通过回滚( Rollback)操作恢复 Pod 的版本。

#### 更新策略说明
Deployment的定义中，可以通过 spec.strategy指定 Pod更新的策略，目前支持两种策略: RollingUpdate (被动更新)和 Recreate (重建) ，默认值为 RollingUpdate.

### Deployment的回滚

### 暂停和恢复 Deployment 的部署操作 ， 以完成复杂的修改

### 使用 kubectl rolling-update 命令完成 RC 的滚动升级
指令：
```
kubectl rolling-update xxx -f 配置文件
```
执行完之后，在同个域名空间下，创建一个新的RC,自动控制旧的RC中Pod的副本数逐渐减少为0，同时新的增加到预期的数字
#### 新的RC配置文件注意
- RC名字不能与旧的相同
- selector中至少又一个Label与旧的不同

使用镜像指令：
```
kubectl rolling-update xxx --image=image.tag|image.name
```

### DaemonSet的更新策略
Kubemetes 从 vl.6 版本开始,升级策略：OnDelete和 RollingUpdate。
- RollingUpdate: 
  - 从 Kubemetes vl.6 版本开始引入 。当使用 RollingUpdate 作为升级策略对 DaemonSet进行更新时， 旧版本的 Pod将被自动杀掉， 然后 自动创建新版本的 DaemonSetPod。
  - 可控，
  - 不支持查看和管理DaemonSet的更新历史记录
  - DaemonSet的回滚 (rollback)并不能如同 Deployment一样直接通过 kubectlrollback命令来实现， 而是必须通过再 次提交 旧版本配置的方式实现。
- OnDelete: DaemonSet 的默认升级策略， 与 vl.5及以前版本的 Kubemetes保持一致
### StatefulSet 的更新策略
目标是保证 StatefulSet 中各 Pod 有序地 、逐个地更新，并且能够保留更新历史，也能回滚到某个历史版本。

## 扩缩容
Deployment/RC 的 Scale机制来完成，手动和自动两种模式 
### 手动
指令：
```
kubectl scale rc xxxx --replicas=Num
```
### Horizontal Pod Autoscaler (HPA) 自动扩缩容
- 基于`CPU使用率`进行自动Pod扩缩容。
- CPU使用率来源于headster组件，需要预先安装。
- HPA控制器基于`kube-controller-manager`服务启动参数 `--horizontal-pod-autoscaler-sync-period`定义时长(默认 30秒),周期性检测目标Pod的CPU使用率，满足RC或者Deployment中的Pod副本数量进行调整，以符合用户定义的平均Pod CPU使用率

#### 使用
- 可以使用kubectl autoscale 进行快速创建或者使用yaml配置创建
- 创建之前必须存在RC或者Deployment，且定义了resources.requests.cpu的资源请求值

