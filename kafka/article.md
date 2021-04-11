# Kafka

## 设计架构
### 角色
- 生产者 producter :消息和数据生产者
- 代理 Broker：核心功能，缓存代理，承接消费者信息，分发到消费者
  - 提供producter，Consumer注册接口
  - 消息存储与分发
- 消费者 Consumer：消息和数据消费端
Kafka高效设计：
- 直接利用Linux`文件系统的Cache`来高兴缓存数据
- 采用Linux `Zero-Copy`提高并发信息，采用`Sendfile`系统调用，数据直接在内核交换，上下文切换减少两次

## 消息管理与存储方式
- kafka以Topic进行消费管理,每个Topic上包含多个Part(分区)并维护这个分区的Log
  - Topic 是发布消息的类别或者种子Feed名
- 每个Part对应一个逻辑Log,有多个Segment文件组成，每个Segment存储多条消息
  - 每个分区都是一个顺序，不可变的消息队列，可持续添加
  - 分区中的消息被分配一个唯一的序列号，称为偏移量offset,
  - 每个分区创建一个文件夹，分区命名：`topicName-分区序号`
  - 分区目的
    - 可以处理更多的消息，不受单体服务器的限制，备份
    - 分区可以作为并行处理单元
- 消息ID由逻辑位置决定，消息ID可以直接定位到消除存储位置
- 每个Part在内存中对应这Index,记录每个Segment中第一条消息偏移
  - Segment 存储message，每条message都有对应的消息ID，offset。
  - offset 也是消费者持有的元数据。
    - 第一条消息偏移量记录在该分区在内存中对应的Index，也是作为Segment文件命名

### Topic
```
Topic
 +---+---+---+---+---+---+
 | 0 | 1 | 2 | 3 | 4 | 5 |
 +---+---+---+---+---+---+   _
          Part0             |\
 +---+---+---+---+---+        \
 | 0 | 1 | 2 | 3 | 4 |   <-- Writes
 +---+---+---+---+---+      /
          Part1           |/_
 +---+---+---+---+---+---+ 
 | 0 | 1 | 2 | 3 | 4 | 5 |
 +---+---+---+---+---+---+
          Part2

old ---------------------------->new
```

### Semgment
一个分区由多个Semgemt组成，每个Semgemt除了日志文件外还有一个.index的索引文件，两个命名都是以Segment第一条消息的offet命名的。

索引文件记录了日志条数，以及物理偏移量，如下图

Segment Idex文件采用稀疏矩阵索引存储方式，减少索引文件大小，通过mmap直接进行内存操作，

### Segment 消息结构
Segment的日志由多个Message组成，Message其结构如下：
```
+----------------------+
|  8 byte offset       |-----> 消息ID，可用用来确定分区消息位置，最大为该分区消息最大数
+----------------------+
|  4 byte message size |-----> 消息大小
+----------------------+
|  4 byte CRC32        |-----> CRC32 校验msg
+----------------------+
|  1 byte magic        |-----> 本次发布Kafka服务程序协议版本号
+----------------------+
|  1 byte attributes   |-----> 独立版本｜压缩类型｜编码类型
+----------------------+
|  4 byte key length   |-----> key 长度，-1时 K byte key 字段不填
+----------------------+
|  K byte key          |-----> 可选
+----------------------+
| 4 byte payload length|-----> 负载长度
+----------------------+
| value bytes payload  |-----> 实际消息数据
+----------------------+
```
### 消费流程
- 发布者发送某个Topic的消息到kafka
- 消息被Broker均匀分布在多个Part上，在对应的最后一个Segment上添加该消息
  - 但Segment消息条数达到配置额或者发布时间超过阀值时，Segment上的消息会被flush到磁盘，只有flush到磁盘的消息才能被订阅者订阅
  - Segment达到一定大小后不会在写数据，这是Broker会创建信息的Segment

### 分布式
kafka本身Consumer,Borker之间没有负载均衡机制，可利用其他负载均衡软件实现负载，例如etcd，zookeeper等

## 消息查找
读取offset的message,
1. 在Topic下查找Segment File，利用文件名是第一个文件消息ID，进行排序，进行二分法查找，找到对应文件
2. 查找Message，在index文件定位到消息的元物理位置，在和log文件里的物理偏移地址，顺序查找到offset对应的消息位置
# quote
- [Kafka架构和原理](https://www.cnblogs.com/jixp/p/9778937.html)