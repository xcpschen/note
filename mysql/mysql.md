# mysql

SQL ：结构化查询语言

MySQL是一个关系型数据库管理系统，由瑞典MySQL AB 公司开发，属于 Oracle 旗下产品

## 三大范式
- 第一范式:每个列都不可以再拆分。
- 第二范式:在第一范式的基础上，非主键列完全依赖于主键，而不能是依赖于主键的一部分。
- 第三范式:在第二范式的基础上，非主键列只依赖于主键，不依赖于其他非主键。


## 架构
- 连接池
- 管理服务和工具组件
- SQL接口组件
- 查询分析器组件
- 缓冲组件
- 插件存储引擎
- 物理文件

## 权限
- user
- db
- table_priv
- columns_priv
- host


## 引擎
### MyISAM
- 不支持事物
- 锁支持
  - 表锁
- 缓冲池只缓冲索引文件
- 不支持外键
- 查询优越
- 不利于修改
- 临时存储含有Text或Blob 类型或者较大的中间查询集
- 存储
  - 结构	
    - .frm 表格定义 
    - .myd 数据文件
      - 可用myisampack工具压缩数据
        - Huffman编码静态算法
    - .MYI 索引文件
- 空间
- 文件格式
- 记录顺序
- 索引
  - 全文索引
  - 实现方式
    - B+树，堆表
    - key_buffer 缓存索引到内存
  - 非聚簇索引
### InnoDB
- mysql第一个支持事务引擎
- 按主键聚集顺序存储
  - 未显性指定主键时
    - 隐形创建一个6字节的ROWID
- 表独立存储到独立ibd文件
- mvvc并发控制

#### 4大特性
- 插入缓冲
- 二次写入
  - 插入内存缓冲
  - 缓冲文件
- 自适应哈希
- 预读

#### checkpoint
- 作用
  - 缩短数据库恢复时间
  - 缓冲池不够用是，刷新脏页回磁盘
  - 重做日志不可用时，刷新脏页
- 分类
  - sharp 
    - 数据库关闭时发生
    - 刷新所有脏页
  - fuzzy
    - Innodb内部使用
    - 刷新部分
    - 可能触发
      - Mather Thread
      - FLUSH_LRU_LIST
      - Async/sync Flush
      - Ditry page too much

#### LSN
- 数据页版本
- 8字节
- 存在
  - 数据页
  - redo log
  - checkpoint

#### 体系架构
```
+--------------------------------------------------+
|  +----------+----------+----------+----------+   |
|  | 后台线程   | 后台线程   |后台线程   |后台线程   |  |
|  +----------+----------+----------+----------+   |
|                                                  |
|               +-------------------------+        |
|               |      内存池              |        |
|               +-------------------------+        |
+--------------------------------------------------+
                          /|\
                           |
                           |
      +---------------------+
      |                     |
      |   +----------------------+
      |   |                      |
      |   |  +-----------------------+
      |   |  |                       |
      +---|  |               文件     |
          +--|                       |
             +-----------------------+
```
- 后台线程
  - Master Thread
    - 异步刷新缓冲池数据
    - 合并插入缓冲
    - undo页回收
- IO Thread
  - 处理AIO请求回调
  - 4个read thread
  - 4 个 write thread
  - insert buffer
  - log Iog thread
- Purge Thread
  - 回收undo页
- 缓冲池
	  
 ```
     +-----------------+     +-----------------------------------------------+
     | redo log_buffer |     |                   buffer pool                 |
     +-----------------+     | +-----------+ +--------------+ +-----------+  |
                             | | data page | | insert buffer| | lock info |  |
     +-----------------+     | +-----------+ +--------------+ +-----------+  |
     | 额外内存池        |     | +-----------+ +----------------+ +----------+ |
     +-----------------+     | | index page| | 自适应hash index｜| 数据字典   | |
                             | +-----------+ +----------------+ +----------+ |
                             +-----------------------------------------------+
 ```
  - 内存管理
  - 数据页类型
    - 索引页
    - 数据页
    - undo页
    - 插入缓冲
    - 自适应哈希索引
    - 锁信息
    - 数据字典

#### 索引
- B+树索引
- 哈希索引
- 哈希链表解决冲突
- 哈希函数
  - 除法散列
- 自适应
- 全文索引


#### 锁
- latch
  - 针对线程
  - 无死锁检测机制
- lock
  - 针对事务
  - 锁整个事务过程
  - 死锁检测机制
    - 超时检测
    - wait-for graph
- 支持力度
  - 允许表锁与行锁同时存在
    - 表锁覆盖行锁的冲突
- 表锁
  - 意向锁
- 行锁
  - 基于索引实现的
  - ReadLocks
  - GapLocks
  - Next-KeyLocks

### NDB
- 集群存储引擎
- share nothing
- 数据全部放在内存
- 主键查找
- join操作在mysql完成，开销大


### Memory
- Heap存储引擎
- 默认使用哈希索引
- 存储在内存中
- 适合作为临时表
- 使用限制
	- 只支持表锁
	- 并发性能差
	- 不支持text和BLOB列类型


### Archive

- 只支持Insert,Select
- 使用zlib算法，压缩row数据，比例一般1:10
- 适合做归档
- 不支持事务

### Fedreated
- 不存放数据
- 指向远程mysql数据库服务器上的表
- 类似透明网关

### mara
- MyISAM后续
- 支持
  - 缓存数据
  - 索引文件
  - 行锁
  - mvcc
  - 事务和非事务完全开关
###  其他引擎
merge，csv,shinx,infobright

## 索引

### 使用类型

- 主键索引
  - 叶子节点存储行数据
  - 不可为null
  - 唯一
  - 未指定时，隐式生成一个键作为主键
  - 聚簇索引

- 唯一索引
  - 唯一
  - 可以为null
  - 可组合

- 普通索引
  - 可组合
- 全文索引
  - 全文索引
    - Full-Text Search
    - 统计分析
    - 引擎
      - MyISAM
      - Innodb
    - 倒排索引
      - inverted index
      - 在辅助表中存储词与词自身在一个或多个文档所在的位置映射
        - inverted file index`{单词，文档ID}`
        - full inverted index`{单词，（文档ID,文档位置)`
    - Innodb实现方式
      - 采用full inverted index方式
      - 表结构
        - word
          - 设置索引
        - ilist `{单词，（文档ID,文档位置)`
      - 6张辅助表
        - Auxiliary table
          - 持久化表
        - 根据word的Latin编码分区
      - FTS index Cache
        - 全文检索引擎缓存
        - 红黑树，对（word,ilist）排序
        - 默认32M,innodb_ft_cache_size可以调整
        - 刷新
          - 更新分词时进行缓存，之后才会合并到辅助表，提高性能
          - 满时，直接同步到辅助表
      - FST Document ID
        - 类型必须是Bigint Unsigned not null
        - 与word进行映射，支持全文索引
        - Innodb会自动在该列加入FST_DOC_ID_INDEX 的唯一索引
      - 限制
        - 每张表只能又一个全文索引
        - 只支持相同字符集与排序规则
        - 不支持单词定符的语言`中文,日语,韩语`等

### 数据结构

- 哈希表
  - 优点
    - 查询O(1)
  - 缺点
    - 不支持范围查询
    - 不支持排序，查询后需要重新排序
    - 无法支持模糊查询已经最左前缀匹配
    - 需要回表查询
    - 存在哈希碰撞

- B+树

### B+树索引使用

- 联合索引
  - 最左原则
  - 按组合字段顺序存储
    - 查找时字段顺序需一致才能生效

- 覆盖索引
  - 非主键索引叶子节点存储着需要查询的字段，不必进行回表操作
- 索引提示
```
Index Hint
 tableName [[as] alias] [index_hint_list]
 index_hint_list:
 index_hint [, index_hint]...
 index_hint:
 use {index|key}
 [for {join|order by|group by}] ([index_list])
 | ignore {index|key}
 [for {join|order by|group by}] ([index_list])
 | Force {index|key}
 [for {join|order by|group by}] ([index_list])
 index_list:
 index_name [,index_name] ...
 ```
  - 强制优化器直接选择指定索引
- Multi-Range Read优化
  - 适合用于
    - range
    - ref
    - eq_ref
  - 好处
    - 使数据访问变得较为顺序，辅助索引时，先根据查询结果按主键排序，再按照这顺序进行书签查找
    - 减少缓冲池中页的替换
    - 批量处理对键值的查询操作
  - 对Innodb和MyISAM的范围查找和JOIN查询的工作方式
    - 查询得到辅助索引键值按索引顺序存入缓存
    - 将缓存数据按RowID进行排序
    - 根据RowID顺序进行访问具体数据
- index Condition pushdown (ICP)优化
  - 根据索引进行查询优化方式
  - 支持优化
    - range
    - ref
    - eq_ref
    - ref_or_null
  - 支持引擎
    - MyISAM
    - InnoDB
	- Extra可以看到使用提示信息
### 前缀索引
- index(field(m))

### 聚簇索引
- 表按主键构造B+树，叶子节点存放行记录
- 数据存和索引一起存放
  - innodb

- 字段不应该频繁更新

### 非聚簇索引

- 数据和索引分开存储，叶子节点指向对应行/主键
- 辅助索引
- 可能需要回表查询
  - 查询字段不包含在索引中时，需要回表

### 使用原则

- NOT NULL
- 取值离散大的字段
- 字段越小越好

### 创建方式

- Create Table 
- Alter Table
- CREATE INDEX

### 优缺点

- 优点
	- 加速检索
	- 提高性能
- 缺点

	- 本身是数据，占用空间
	- 维护索引需要代价

## 数据类型

### 整型

- tinyint(M)
  - 8位
  - 1字节
- smallint(M)
  - 16位
  - 2字节
- mediumint
  - 24位
  - 3字节
- int
  - 32位
  - 4字节
- bigint
  - 64位
  - 8字节
- 无符号类型Uxxx

### 浮点型
取值有范围，支持标准浮点进行近似计算，且效率高于decmal
- float
  - 32位，4字节
- double
  - 64位，8字节

- decimal
  - 计算类似字符串处理
  - 小数部分超过则会截断
  - 整数部分超过则会报错

### 日期型

- data
  - YYYY-MM-DD 1000-01-01~9999-12-3
- year
  - YYYY 1901~2155
- time
  - HH:MM:SS -838:59:59~838:59:59
- timestamp
  - YYYY-MM-DD HH:MM:SS 1000-01-01 00:00:00~ 9999-12-31 23:59:59
  - YYYY-MM-DD HH:MM:SS 19700101 00:00:01 UTC~2038-01-19 03:14:07UTC
- datetime
  - YYYY-MM-DD HH:MM:SS 1000-01-01 00:00:00~ 9999-12-31 23:59:59

### 文本型

- char(M)
  - 不可变
  - M 0～255位整
- varchar(M)
  - 可变
  - M共0～65535位整数
- TINYTEXT
  - 0-256字节
- TEXT
  - 0-65535字节
- mediumtext
  - 0~167772150字节
- LONGTEXT
  - 0~4294967295字节
- VARBINARY(M)
  - 0~M字节可变长字节字符串
- BINARY(M)
  - 0-M定长字节字符串
- JSON
- SET
  一个设置，字符串对象可以有零个或多个 SET 成员
  

### 二进制类型
二进制字符串，主要存储图片，音频信息
- Bit(M)
  - 位字段类型
- BINARY(M)
  - 固定长度
- VarBINARY(M)
  - 非固定长度
- tinyblob
  - 0-256字节
- BLOB
  - 0-65535字节
- mediumblob
  - 允许长度0~167772150字节
- LONGBLOB
  - 允许长度0~4294967295字节

### 枚举型
- ENUM
  - 1～2个字节，最大65535

- 存储为整数
  
## 事务

### ACID

- 原子性
  - redo log 来保证
- 一致性
  - undo log来保证
  - MVVC

- 持久性
  - redo log来保证
  - 两阶段提交保证

- 隔离性
  - 锁机制来保证
  - 隔离级别
  
### 隔离级别

- 读未提交
  - 级别最低
- 读提交
  - 存在
    - 幻读
    - 不可重复读
  - 默认
- 可重复读
  可重复读保证了当前事务不会读取到其他事务已提交的 UPDATE 操作。但同时，也会导致当前事务无法感知到来自其他事务中的 INSERT 或 DELETE 操作，这就是幻读。
  - 存在欢读
- 序列化
  - 级别最高

### MVVC

- 保存修改旧版本信息来支持一致性和回滚,解幻读（读方面）
- Read Commited 下，读取的是被锁定数据的最新一份
- Repeatable Read 下 读取到的是事务刚开始时候的数据
- 读模式
  - 快照读
    - 读当前事务可见版本
  - 当前读
    - 更新
    - 插入
    - 删除
    - 特殊读
- 实现
  事务度取数据时，数据被锁组，则读取之前的快照
  - ROWID
    - 主键
    - 隐藏的自增ID
  - 事务ID
  - 回滚指针
  - 快照

## 锁

### 实现事务隔离性要求

### 表锁

- 意向锁
  如果另一个任务试图在该表级别上应用共享或排它锁，则受到由第一个任务控制的表级别意向锁的阻塞。第二个任务在锁定该表前不必检查各个页或行锁，而只需检查表上的意向锁。
  意思：当表上有意向锁时，另一个事物就不会去检查其是否被锁定，而是直接阻塞了
- 意向共享锁：IS
  - select xxx lock in share mode
  - 事务正在或有意向对表中后行加上s锁
  - 兼容S锁，与X锁互相排斥
- 意向排他锁：IX
  - select xxx for update
  - 预示着事务正在或者有意向表中的某行加X锁
  - 与X/S锁互相排斥
  
- 表级别的锁：只锁某些行
- InnoDB自己维护
- 解决全表扫描性能问题
- 弱，意向锁之间可以互相并行，并非排斥
- 不会与「行级」的共享/排他锁互斥
  
```
        T1                                     T2                             T3
         BEGIN;                   |                                 |
    select * From T               |                                 |
    where id = 5 for update       |                                 |
 --------------------------------------------------------------------------------------
                                  |            Lock Tables T Read;  |
                                  |                                 |
 --------------------------------------------------------------------------------------
                                  |                                 | begin select * 
                                  |                                 | from T where id = 4 for update'
 ---------------------------------------------------------------------------------------
                                  |                                 |      commint
                                  |                                 |
                                  |                                 |
 ---------------------------------------------------------------------------------------
      COMMIT                      |                                 |
                                  |                                 |
                                  |                                 |
 ---------------------------------------------------------------------------------------
 ```

 1. T1执行第一阶段后有了意向锁排他锁，id=6 for update 获得行排他行锁
 2. T2 坚持到T1阶段给T增加意向锁，其表级别的共享锁被阻塞
 3. T3也是意向锁排他行锁，所以它直接获取到了4的数据
	  

### 行锁

- 算法
- 记录锁 Record Locks
  - 查询
  	- select * from T where id=1 For update
  - 更新
	- UPDATE SET xxx=xxx WHERE id = 1;
  - 锁住当前行上记录
  - 即使没有索引，InnoDB会创建一个隐形的主键去锁住
  - 变成临键锁可能
  	- 非精确匹配（=）下
  	- 列非唯一索引列或者主键列

- 间隙锁Gap Locks
  - 基于非唯一索引
  - 锁定一个范围，开放区间，但不包含记录本身
  - 锁组记录间隙，让其他事务在‘隙缝’中插入数据
  - 事务级别是 Repeatable Read,降低级别会失效
  - 意向锁中插入数据也用到此算法
  - 插入意向锁
    插入意向锁是在插入一条记录行前，由 INSERT 操作产生的一种间隙锁。该锁用以表示插入意向，当多个事务在同一区间（gap）插入位置不同的多条数据时，事务之间不需要互相等待。
	- 特殊间隙锁
	- 多个事物在同个区间插入多条数据，数据本身不冲突则不会排斥，冲突等待问题
	- 提高并发性

- 临键锁 Next-Key Locks
  - Gap Locks +Record Locks 锁定范围和记录本身，左开右闭区间
  - 具有「唯一性索引」中，会「降级为记录锁 Read Lock」,增加并发性
   ```
           T1                                     T2
            BEGIN;                   |            
       select * From T               |           
       where id = 5 for update       |
    ---------------------------------------------------------------
                                     |            BEGIN; 
                                     |          Insert into t (4, xx);
    ---------------------------------------------------------------              
                                     |          COMMIT
                                     |             
    ----------------------------------------------------------------
         COMMIT                      |                            
                                     |
                                     |
    -----------------------------------------------------------------
    ```
    以上情况，就会把Next-key Lock降级为记录锁(Read Lock)
  - 解决幻读（写）问题
- 共享(s)/排他(x)锁
  - 共享锁：读锁 S
    - 有表级别
      - Lock Table xxx Read
    - 行级别的
- 排他锁：写锁 X
  - 表级别
  - 行级别
- 读时，可读不能写
- 写时，不可读不可写

### 主键自增锁

- 特殊表级别锁，原子性操作，确保主键值的连续
- 插入类型
  - insert like
    - insert
    - replace 
    - insert ...select
    - replace ..select
    - load data
  - simple inserts
    - 能确定插入数量的语句
    - 不包含
      - insert ... on duplicate key update 这类语句
  - bulk inserts
    - 插入前不能确定数量语句
  - mixed-mode inserts
    - 含有一部分值是自增长，有部分确定

### 一致性非锁定读
- 模式
  - Repeatable read
  - read committed
- MVCC
- undo log

### 一致性锁定读

- Repeatable read模式下
- 操作
  - select。。。 for update
  - select ... lock in share mode

### 乐观锁

- 逻辑上

## 分区
- 是将一个表或者索引分解为更小
- OLAP类型业务分区能极好的提升性能
- 逻辑上是一个表或索引
- 物理上却是分开的，单独存在，独自管理
- 水平分区
- 多行记录分配到不同物理文件中

### 多引擎支持

- Innodb
- MysISAM
- NDB


### 局部分区索引

- 分区中存放数据和索引

### 定义语句

- PARTITION BY xxx
PARTITIONS nums

### 表是否有主键/唯一索引

- 存在时，分区列必须是唯一索引的一部分
- 没有时，任何列都可以

### 分区后文件

- 划分多个ibd文件
- 名：t#P#分区名.ibd

### 分区类型

- RANGE 分区
  ```
  PARTITION BY RANGE(xxx)
  PARTITIONS p0 values Less Than(xxx) 
  ```
- 基于列值一个连续区间划分
- 分区时指定，类似else情况的分区 PARTITIONS name values less then maxvalue
  - 但不存在分区进行插入操作时，会抛出异常
- 主要用于类型
  - 日期列
  	- 使用TO_DAYS函数分区，可以让优化器支持对日前函数的查询
  - id
- 支持子分区
  - HASH
    ```
    partition by range(expr(b))
    subpartiton by hash(expr(b))
    subpartitions nums (
     partion name value less than (xxx),
     partion name1 value less than (xxx),
    .....
     partion name2 value less maxvalue
    )
    data dirctory='指定存放数据路径'
    index dirctory='指定存放索引路径'
    ```
  - KEY
- null值总是被放在最左边分区

- LIST 分区
  ```
  PARTITION BY LIST(xxx){
     partition name values in (xx,xxx...),
     .....
   } 
  ```
  - 和RANGE分区一样，只是面向离散的值
  - 缺点
    - Innodb下不再分区的插入都会失败
  - 支持子分区
    - HASH
    - KEY
  - null值要显示指明在那个分区

- HASH 分区
  ```
  PARTITION BYHASH（expr）
  PARTITONs nums
  ```
  - 根据用户自定义的表达式返回值来划分，不能为负数
  - 均匀分布到预定的各个分区，值连续性越好，越均匀
  - 常用类型
    - 日期
    - 主键
  - null 记录为0
- LINEAR HASH 分区
  ```
  PARTITION BY linear hash(expr)
  partitions [nums] 
  ```
  - 和HASH 类似
  - 算法
    - 取分区数的下一个2的幂值V
    - 所在分区=expr(xxx)&(V-1)
  - 增，删，合并，拆分更加快捷
  - 均衡性不如hash

- KEY 分区
  ```
   partition by key(xxx)
   partions nums
  ```
  - mysql提供函数进行划分
  - 分区编号通过2的幂算法得到
  - null 记录为0

### 支持的数据类型

- 整型类型
- 日期类型
- 字符串类型

### 不支持类型

- FLOAT
- DECIMAL
- BLOB
- TEXT
- 
### 子分区
- 每个子分区数量必须相同
- 每个分区表的任何分区上使用subpartition来明确定义任何子分区，就必须定义所有子分区，否则报错
- 每个subpartition子句必须包含子分区的一个名字，且唯一

### 跟非分区表交换数据
```
  ALTER table xxx exchange partiton 分区名 with table 表名
```
- 满足条件
  - 必须相同表结构且不含分区
  - 交换数据必须在交换分区定义内
  - 不能含有外键，或者引用其他的
  - 执行必须用有ALTER,INSERT,CREATE,DROP
  - 不能触发触发器
  - 自增长键被充值


## 视图
- 虚拟表
- 无实际物理存储

### 作用

- 取数据
- 更新数据

### 可更新视图

- with check option 对不满足视图定义条件抛出异常

### 读视图

### 物化视图

- 根据基表实际存在的实表
- 刷新模式
  - ON DEMAND,需要时跟新
  - ON COMMIT，刷新方式
    - FAST 增量
    - COMPLETE 全量
    - FORCE: 判断是否可以FAST，否则COMPLETE
    - NEVER 不刷新

- mysql 本身不支持
- 利用特殊机制实现
  - ON DEMAND 创建新表，数据导入即可，全表更新
  - FAST方式的可以通过触发器

## 日志

### binlog

- 格式
  - statement
    - 保留sql执行的上下文信息
    - 不需要完整记录每行变化
    - 节约IO，日志量少
  - 使用函数之类的语句无法被记录
  - row
    - 完整保持sql只想的文本信息
    - 量大
    - 新版开始，表结构变化不会逐行记录
  - mixed
    - statement和row的混合
    - 普通操作用statement记录
    - 无法用statement时用row

- 逻辑日志

### redo log

- 组成
  - redo log buffer
    - 内存
    - 易丢失
  - redo log file
    - 持久化文件

- 物理日志
- 对页的修改
- 在事务进行中不断写入
- 顺序写
- 日志格式
  - redo_log_type
  - space
  - page_no
  - redo log body

- LSN
  - log sequence numser
  - 日志序列号
  - 8字节
  - 单调递增
  - 含义
    - 日志写入总量
    - checkpoint的位置
    - 页版本

- 存储结构

  ```
  +----------+---------+---------+--------+--------+--------+
  |   log    |  log    |  log    | log    | log    |  log   |
  |  block   | block   | block   | block  | block  |  block |
  +----------+---------+---------+--------+--------+--------+
                     |
                    \|/
  +-------------------+
  |  log block header | 
  +-------------------+
  |                   |
  |   Log Block       |
  |   512Bytes        |
  |                   |
  +-------------------+
  |  log block tailer |
  +-------------------+
  ```
	- log block header
		- 日志头
		- 12字节
		- 组成
	- log block
		- 存储单位
		- 512字节
		- 日志本身
		- 存储结构
	- log block tailer
		- 日志尾
		- 8字节

### undo log

- 记录事务行为
- 逻辑日志
- 随机读写
- 会产生redo log
- 事务回滚日志
- 快照读取实现
- 存放在特殊段 undo 段
	- 在共享表空间内
	- 段管理
- 类型

	- insert undo log
	- update undo log

### relay log


## Online DDL

### 官方支持
```
  ALTER TABEL  tablename
  | ADD {index|key} [index_name]
  [index_type] (colname,...) [index_option] ...
  algorithm [=] {default|inplace|copy}
  Lock [= ] {default|none|shared|exclusive}
```
- 创建/删除索引算法
  - Default
    - 根据参赛old_alter_table来判断是否使用INplace or copy
  - INPLACE
    - 不需要临时表
  - copy
    - 临时表模式
- 创建/删除索引加锁方式
  - NONE
  - Share
    - s锁
    - 不支持该模式的引擎，报错
  - exclusive
    - x锁
- 原理
  - 执行过程中，将ddl 操作写入缓存中
  - 完成后，把上面操作应用到表中
- 支持DDL
  - 辅助索引的创建/删除
  - 改变自增长值
  - 添加/删除外健约束
  - 列的重命名

### 其他中间件

#### gh-osc
gh-ost 是 GitHub 开源的在线更改 MySQL 表结构的工具。它是可测试的，并提供了停止服务(pausability)、动态控制/重新配置、审计和许多运维操作

##### 原理
- 检查数据库实例信息
- 模拟slave,获取当前位点信息，创建binlog streamer 监听binlog
- 创建日志记录表**xx_ghc**和影子表**xx_gho**,并执行alter语句将影子表变更为目标表结构，日志记录该过程，核心步骤记录到 **_b_ghc**
- 拷贝原表数据到**xx_gho**
- 增量应用数据binlog迁移数据
- copy完数据之后进行原始表和影子表cut-over切换
- 根据执行参数做收尾工作，必不可少的是关闭binlogsyncer连接

#### pt-osc
c/c++编写，percona 推出的工具percona-toolkit执行在线DDL工具，用来管理MySQL和系统任务，主要包括：
- 验证主节点和复制数据的一致性
- 有效的对记录行进行归档
- 找出重复的索引
- 总结 MySQL 服务器
- 从日志和 tcpdump 中分析查询
- 问题发生时收集重要的系统信息

##### 原理
1. 如果存在外键，根据alter-foreign-keys-method参数的值，检测外键相关的表，做相应设置的处理。
2. 创建一个新的表，表结构为修改后的数据表，用于从源数据表向新表中导入数据。
3. 创建触发器，用于记录从拷贝数据开始之后，对源数据表继续进行数据修改的操作记录下来，用于数据拷贝结束后，执行这些操作，保证数据不会丢失。
4. 拷贝数据，从源数据表中拷贝数据到新表中。
5. 修改外键相关的子表，根据修改后的数据，修改外键关联的子表。
6. rename源数据表为old表，把新表rename为源表名，并将old表删除。
7. 删除触发器。

## 主从复制

将主数据库中的DDL和DML操作通过二进制日志（BINLOG）传输到从数据库上，然后将这些日志重新执行（重做）；从而使得从数据库的数据与主数据库保持一致。

### 作用

- 主备切换
- 读写分离
- 日常备份

### 工作原理
- 主库把数据更改记录到binlog
	- binlog线程
- 从库将主库的binlog日志复制到自己的中继日志relay log
	- IO线程
- 从库读取中继日志的事件，将其重放到从库数据中
	- sql执行线程
