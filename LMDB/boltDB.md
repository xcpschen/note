# boltDB
page大小，根据平台操作系统而定

## 数据库文件物理存储格式
初始化时格式
```
    +----------+-------+
    |  page 0  |      \|/------- mate0
    +----------+     mete page
    |  page 1  |      /|\------- mate1
    +----------+-------+
    |  page 2  | ------> freelist
    +----------+
    |  page 3  | ------> leafPage
    +----------+
```

## 内存-数据文件映射实现
mmap是内存映射原理
