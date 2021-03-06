# 概述
LMDB，全称`Lightning Memory-Mapped Database Manager`,是基于Btree的数据库管理库，其基于BerkeleyDB API进行了松散的建模,简单操作。

使用内存映射数据文件方式，带来访问的便利性，且查询过程中不会发送内存分配和内存复制带来的问题。及其简单以至于不需要对数据页进行缓存，使得程序简单，具有极高的性能和内存利用效率。且在只读时，不会数据库的完整性不会被应用程序杂乱的指针破坏

它支持ACID的事务，具有读写事务，只读事务，批量读写事务。支持多线程并发读/写访问。

数据页使用写时复制策略，因此不需要覆盖任何活动数据页，可以预防损害文件和遇到系统奔溃带来的特殊恢复方式。

整个写过程是序列化，只有一个事物可以执行，保证永远不会死锁。

支持MVCC的数据模式，带来的是读永远不会加锁，读写之间不会阻塞。

LMDB 要求在操作期间不做维护动作，只有在向前写日志和仅仅追加操作是，数据库会周期检查或者压缩日志/文件，以避免文件无限增大。

LDMB会追踪空闲数据页，在新的写操作时，重新利用他们，所以文件在正常使用不会没有边界的增长。

数据存储一键值对形式存储。