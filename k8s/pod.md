# Pod
## 定义&用法

## 特殊Pod- 静态pod

## Pod容器共享Volume

## 配置管理&容器内获取 Pod信息

## 配置管理

## 容器内获取 Pod信息（DownwardAPI）
### 环境变量方式
### 文件方式

## 生命周期&重启策略

### Pod生命周期的状态
- Pending
- Running
- Succeeded
- Failed
- Unknown

### 重启策略-RestartPolicy
在 Pod 所处的 Node 上 由 **kubelet**进行判断和重启操作。当某个容器异常退出或者健康检查失败时， kubelet
将根据 RestartPolicy 的设置来进行相应的操作 。策略如下:
- Always
- OnFailure
- Nerver

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

## 健康检查
### LivenessProbe
kubelet 定期执行 LivenessProbe 探针来诊断容器的健康状况 。 LivenessProbe 有以下 三种实
现方式。
- ExecAction
- TCPSocketAction
- HTTPGetAction
### ReadinessProbe

## 调度
通常需要通过 Deployment、 DaemonSet、 RC、 Job 等对象来完成一组 Pod 的调度与自动控制功能。
### DeploymenURC:全自动调度
### NodeSelector:定向调度
### NodeAffinity: Node 亲和性调度
### PodAffinity: Pod 亲和与亘斥调度策略
### Taints 和 Tolerations (污点相容忍)
### DaemonSet:在每个 Node 上调度一个 Pod
### Job:批处理调度
### Cronjob:定时任务
### 自定义调度器

## 初始化容器（Init Container）

## 升级和回滚
### Deployment 的升级
Pod 是通过 Deployment 创 建的，则用户可以在运行时修改 Deployment 的 Pod 定义 (spec.template)或镜像名称 ，井应用到 Deployment 对象上，系统即可完成 Deployment 的自 动更新操作。如果在更新过程中发生了错误， 则还可以通过回滚( Rollback)操作恢复 Pod 的版本。

#### 更新策略说明
Deployment的定义中，可以通过 spec.strategy指定 Pod更新的策略，目前支持两种策略: RollingUpdate (被动更新)和 Recreate (重建) ，默认值为 RollingUpdate.

### Deployment的回滚

### 暂停和恢复 Deployment 的部署操悍 ， 以完成复杂的修改

### 使用 kubectl rolling-update 命令完成 RC 的滚动丹级

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