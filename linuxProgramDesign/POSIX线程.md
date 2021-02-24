#### 创建
- 定义
线程是一个进程内部的一个控制序列
- 特定
  - 用户自己的栈，具备变量
  - 与创建者共享全局变量，文件描述符，信号处理函数和当前目录状态
- Linux的线程实现版本和POSIX标准的区别
  - 差别在于受到底层Linux内核的限制
  - 信号处理
- NGPT 
  - New Generation POSIX Thread (下一代POSIX)
- NPTL
 - Native POSIX Thread Library 本地POSIX线程库
 - 参考资料
   -[《The Native POSIX Thread Library for Linux》](http://people.redhat.com/drepper/nptl-design.pdf)
   - Linux 上的本地POSIX线程库
   - Ulrich Drepper 和Ingo Molnar 编写
- Linux 线程库
  - #include <pthread.h>
  - pthread_开头
  - 必须定义**宏_REENTRANT**
    - 使得原来某些函数变成可安全重入调用
    - 在任何#include语句之前定义
    - 通过宏_REENTRANT告诉编译器可重入功能
      - 对部分函数重新定义它们的可安全重入的版本，名字不变，在名字后加入 **_r**
      - stdio.h中原来以宏的形式实现的一些函数将会变成可安全重入函数
      - 在error.h中定义的变量**errno**变成一个函数调用，可以安全多线程获取其值
  - 编译时必须使用 **-lpthread** 来链接线程库
  - 创建
```
#include <pthread.h>

int pthread_create(
    //创建时，其变量被写入一个标识符，用来引用🆕线程
    pthread_t *thread,
    //设置线程属性，没有为NULL
    pthread_attr_t *attr,
    //线程执行的函数
    void *(*start_rountine)(void *),
    //线程执行的函数 的参数
    void *arg
)
```
   - 终止执行
```
void pthread_exit(void *retval)
```
    - 终止调用他的线程，并返回一个指向某个对象的指针，不能是局部变量的，线程调用后，局部变量不存在
   - 等待子线程，类似warit函数
```
//成功0，失败是错误码
int pthread_join(
    //指定等待的线程
    pthread_t th,
    //指向线程放回值
    void **thread_return
)
```
- 编译指令
  - 老版本Linux
```
  $ cc -D_REENTRANT -I/usr/include/nptl 文件.c -o 文件 -L/usr/lib/nptl -lpthread
```
  - NPTL实现
```
  $ cc -D_REENTRANT 文件.c -o 文件 -lpthread
```
#### 一个进程中同步线程之间的数据访问
控制线程执行和访问代码临界区
- 信号量
荷兰计算机科学家Dijkstra提出，特殊的变量，可以被增加或减少，原子操作
  - 接口函数用于信号量
    - POSIX实时拓展
    - 系统V信号量
  - 分类
    - 二进制信号量
      - 值只有0和1
    - 计数信号量
  - 注意事项
    - 信号函数以sem_开头
    - 线程中使用的只有4个基本信号量函数
  - 4个基本信号量函数
```
#include <semaphore.h>
//成功都是0
//创建，初始化sem的信号量对象，设置它的共享选项，并初始化
int sem_init(
    //信号量
    sem_t *sem,
    //控制信号量的类型，0表示当前进程局部信号量，否则可以被多进程共享，非零值调用失败
    int pshared,
    //初始化值
    unsigned int value
 )
 //原子操作，信号值减一，如果值为0时，则会等待，直到其他线程使其不为0为止
 int sem_wait(sem_t *sem)
 //非阻塞版本 减一操作
 int sem_trywait(sem_t *sem)
 //原子操作，信号值加一
 int sem_post(sem_t *sem)
 //信号量清理，如果企图清理其他线程等待的信息量，会受到一个错误
 int sem_destroy(sem_t *sem)
```
- 互斥量
锁住临界区，一次只能一个线程访问
上锁解锁数量必须一致
  - 程序库
```
#include <pthread.h>
//成功返回0，失败状态，但不设置errno
int pthread_mutex_init(
    pthread_mutex_t *mutex,
    //互斥量属性值，控制行为，默认为fast；但程序对一个已经加锁的互斥量调用pthread_mutex_lock时，会被阻塞，而拥有者被阻塞的话，程序进入死锁
    const pthread_mutexattr_t *mutexattr
)
int pthread_mutex_lock(pthread_mutex_t *mutex)

int pthread_mutex_unlock(pthread_mutex_t *mutex)

int pthread_mutex_destroy(pthread_mutex_t *mutex)
```
#### 线程属性
|属性名|含义|
|-|-|
|detachedstate|控制线程是否重新合并。选值有PTHREAD_CHEATE_JOINABLE：允许合并。PTHREAD_CHEATE_DETACHED：不能调用pthread_join来获得另一个线程退出状态|
|schedpolicy|控制线程调度方式。SCHED_OTHER：默认。SCHED_RP：超级用户权限运行线程，具备实时调度，循环调度机制（round-robin）SCHED_FIFO：超级用户权限运行线程，具备实时调度，先进先出策略|
|schedparam|与schedpolicy属性结合使用，对以SCHED_OTHER策略运行的线程调度进行控制|
|inheritsched|继承创建者使用参数属性，PTHREAD_EXPLICIT_SCHED：默认，明确由属性设置。PTHREAD_INIERIT_SCHED：继承创建者使用参数属性|
|scope|控制线程调度计算方式。 PTHREAD_SCOPE_SYSTEM|
|stacksize|控制线程创建的栈大小，字节单位。可选，只有定义宏_POSIX_THREAD_ATTR_STACKSIZE才支持|
- 控制调度
改变调度属性，用sched_get_priority_max和sched_get_priority_minl来查询可用的优先级别
- 取消线程
 - int pthread_cancel(pthread_t thread)
   直接取消
 - int pthread_setcancelstate(int state,int \*oldstate)
   设置自己的取消状态
   - state
     - PTHREAD_CANCEL_ENABLE(允许取消)
     - PTHREAD_CANCEL_DISENABLE（忽略取消请求）
   - oldstate 原先的取消状态
 - int pthread_setcanceltype(int type,int \*oldstate)
   - type取值
     - PTHREAD_CANCEL_ASYNCHRONOUS 立即取消；
     - PTHREAD_CANCEL_DEFERRED 接收到允许后，等待线程执行
       - 该执行模式下，需等待如下函数执行完后才行动
         - pthread_join
         - pthread_cond_wait
         - pthread_cond_timedwait
         - pthread_testcancel
         - sem_wait
         - sigwait
   - \*oldstate
     - 原先的取消状态的指针
