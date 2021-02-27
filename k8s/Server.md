# Server
为相同功能容器应用提供统一的入口地址，且负载到后端各个容器应用上
> 负载均衡，外网访问，DNS服务搭建，Ingrees 7层路由
## 定义&用法
### yaml格式定义
```
apiVersion: v1                      // kube-apiserver api 版本  必须
kind: Service                       // k8s资源对象 server                                 必须
metadate:                           // 元数据定义                                         必须
    name: string                    // server名称                                        必须
    namesapce: string               // 命名空间，不指定为default                           必须
    labels:                         // 标签列表
        - name: string
    annotations:                    // 注解列表
        - name: string
spec:                               // 详细描述                                          必须
    selector:[]                     // Labale Select 配置，指定Label标签Pod作为管理范围     必须
    type: string                    // server 类型，默认clusterIP,clusterIP|NodePort|LoadBalancer  必须
    clusterIp: string               // 虚拟服务IP地址；type=clusterIP时，不指定则自动分配；但type=LoadBalancer 必须指定
    sessionAffinity: string         // 是否支持Session,默认为空，可选址ClientIP；为ClientIP时表示，把同一个客户端请求都转发到同一个后端Pod
    ports:                          // 暴露端口列表
    - name: string                  // 端口名字
        protocol: string            // 协议 TCP|UDP,默认TCP
        port: int                   // 服务监听端口号
        targetPort: int             // 转发目标后端Pod端口号
        nodePort: int               // 物理机端口号，当spec.type=NodePort时使用
    status:                         // 当spec.type=NodePort时使用，设置外部负载均衡地址，公有云环境
        loadBalancer:               // 外部负载均衡
            ingreess:               // 外部负载均衡
                ip: string          // 外部负载均衡IP地址
                hostname: string    // 外部负载均衡主机名
```
### 创建方式
指令：
```
kubectl expose rc xxxx
```
配置文件定义：
```
kubectl create -f xxx.yaml
```
查看是否创建成功:
```
kubectl get svc
```
## 负载分发策略

### RoundRobin 轮询模式
k8s 默认策略
### SessionAffinity 
基于客户端IP地址会话保持模式;第一次将某个客户端发起请求转发到后端的某个Pod上，之后相同客户端请求都将被转发到相同的Pod
### Headless Service 概念
利用Headless Service 概念实现自己控制负载均衡策略；Headless Service即不给Service设置`ClusterIp=None`,而仅通过Label Selector将后端的Pod列表返回给调用的客户端，
客户端自己处理负载均衡。

## Endpoints-实现外部服务作为后端服务链接
外部服务，或者其他集群或Namespace的服务作为后端服务时。无法通过创建一个无Label Selector的Service来访问:
```
apiVersion: v1
kind: Service
metadata:
    name: my-service
spec:
    ports:
    - protocol: string
      port: Number
      targetPort: Number
# Endpoints
apiVersion: v1
kind: Service
metadata:
    name: my-service
subsets:
- addresses:
  - IP: string
  ports:
  - port:Number
```
## 访问
集群外的客户端无法通过Pod的IP地址或者Service的虚拟IP地址和端口号访问。因此必须将Pod或Service的端口号映射到宿主机上，才可以被外部访问
### IP
### DNS
#### 搭建
#### 自定义&上游DNS服务器

## 代理Ingress: HTTP7层路由机制

