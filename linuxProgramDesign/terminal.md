## terminal
> 控制用户终端（屏幕，键盘），输入输出，重定向

- 终端读写
  - getchar 处理输入字符
  - 标准模式 standard mode 或 规范模式 canonical mode
    - 所有输入都基于行处理，回车完成之前，终端接口负责管理所有的键盘输入，程序读不到任何输入字符
  - 非标准模式 non-canonical mode
    - 应用程序对用户输入字符处理用户更大的控制权
  - Linux,UNIX以换行符结束，MS-DOS以回车符和换行符两个字符结合表示一行结束
  - 处理重定向输出
    - 系统调用**isatty**查看底层文件描述符关联到一个终端
      - unistd.h
      - int isatty(int fd) success 1 failuer 0
      - 文件流的话，stdout结合fileno结合使用,获取文件描述符
    - stdout 标准输出
    - stderr 标准错误输出
- 与终端对话
  - /dev/tty 始终指向当前终端或者当前登录会话，操作该**文件**，直接与终端交互
- 终端驱动程序和通用终端接口
  - 终端接口**GTI**来控制接口
    ```
        +-------+
        |用户程序|  <----------+
        +-------+            |
            |                |控制接口
            |数据读写接口      |
            |                |
        +--------+           |
        |内核中终 | <----------+
        |端驱动程 | 
        |序      |
        +-------+
    ```
    - 行为控制与读写分离
    - 需要底层硬件控制
    - 可以控制主要功能
      - **行编辑**  是否允许退格键进行编辑
      - **缓存**    立即读取字符，还是缓存读取
      - **回显**    读取密码时，允许控制字符的显示
      - **回车/换行**（CR/LF） 定义如何在输入/输出时映射回车/换行符，比如打印\n字符时如何处理
      - **线速**    调制器调器或者串行线链接终端时有用
- termios
  - POSIX规范中定义的标准接口，通过其函数和结构值，对终端进行控制
  - 定义在头文件 termios.h
  - 程序需要使用termios.h函数，需要与系统标准库（curses）或者其他的库进行链接使用
    - curses 编译命令后 **-lcurses**
      - 老版本的curses为new curses,库名ncurses 链接参数为 **-lncurses**
    - 影响终端的值
      - 典型结构定义,参数定义如下
        ```
        struct termios{
            tcflag_t c_ciflag; //输入模式
            tcflag_t c_coflag; //输出模式
            tcflag_t c_cflag; //控制模式
            tcflag_t c_loflag; //本地模式
            cc_t c_cc[NCCS]; //特殊字符控制模式
        } 
        ```
    - 初始化终端对应的termios结构
        - int tcsetattr(int fd,int actions, const struct termois *termios_p) 
        - 把当前终端变量指向 termios_p
        - actions 控制修改方式
            |参数|说明|
            |-----|------|
            |TCSANOW|立即对值修改|
            |TCSADRAIN|等当前输出完成后修改|
            |TCSAFLUSH|等当前输出完成后修改，但是抛弃从未read调用返回的当前可用的任何输入|
        - **程序有责任恢复终端初始状态**
        - tssetattr重新设置修改值
    - 输入模式
        - 控制输入数据在被传递给程序之前的处理方式，c_iflag,**按位或**
            |参数|说明|
            |-------|------|
            |BRKING|输入行检测到终止状态时（链接丢失），产生中断|
            |IGNBRK|忽略输入行的终止状态|
            |ICRNL|接收的回车行替换成新行符|
            |IGNCR|忽略回车符|
            |INLCR|新行符替换成回车符|
            |IGNPAR|忽略奇偶校验错误的字符|
            |INPCK|接收字符执行奇偶校验|
            |PARMRK|对奇偶校验错误做出标记|
            |ISTRIP|将所有收到字符裁减为7比特|
            |IXOFF|对输入启用软件流空|
            |IXON|对输出启用软件流空|
        - BRKING和IGNBRK未置位，则输入行中的终止状态就读取为NULL(0x00)
    - 输入模式
        - 控制输出字符处理方式，在传递到屏幕或者串行口前，c_oflag,按位或
            |参数|说明|
            |-------|------|
            |OPOST|打开输出处理，未设置，其他标志都忽略|
            |ONLCR|输出中的换行符替换为回车/换行符|
            |OCRNL|输出中的回车符替换为新行符|
            |ONOCR|0列不输出回车符|
            |ONLRET|不输出回车字符|
            |OFILL|发送填充字符以提供延时|
            |OFDEL|用DEL而不是NULL字符作为填充字符|
            |NLDLY|新行符延时选择|
            |CRDLY|回车符时选择|
            |TABDLY|制表符延时选择|
            |BSDLY|退格符延时选择|
            |VTDLY|垂直制表符延时选择|
            |FFDLY|换页符延时选择|
    - 控制模式
        - 控制终端的硬件特性，c_cflag，按位或
            |参数|说明|
            |-------|------|
            |CLOCAT|忽略所有调制解调器的状态行|
            |CREAD|启用字符接收器|
    - 本地模式
      - 控制终端的各种特性，c_lflag
    - 特殊控制字符
      - 字符组合，例如Ctrl+C,c_cc数组成员将特殊字符映射到对应函数
      - 标准模式和非标准模式下，有差异
        - 字符
        - TIME和MIN值
          - 只用非标准模式
          - 共同控制**输入**的读取 
            |TIME|MIN|说明|
            |---|--|------|
            |0|0|read调用立即返回，有字符等待处理，则返回，没有reade返回0|
            |>0|0|有字符可以处理或者经过TIME个十分之一秒，read就返回读取字符数，超时未读到字符，则返回0，|
            |0|>0|read等待直到MIN个字符就返回读取字符数，到达文件尾则0|
            |>0|>0|read会等待接收一个字符，在接收1以及后续字符后，一个字符间隔定时器被启动|
          - shell 访问终端模式
            - stty -a
            - 终端从非标准模式中恢复
              - stty sane 需要stty版本支持
              - 回车键和新行符映射关系丢失，恢复
                - stty sane&&Ctrl+J
              - 保存当前的然后在恢复
                ```
                $ stty -g > save_stty
                $ ...
                $ stty $(cat save_stty) (或许回车不能用时，用Ctrl+J)
                ```
          - 在命令提示符下设置终端模式
            - shell脚本读取单个字符
              - 关闭终端标准模式
              - 设置MIN为1，TIME为0
              - stty -icanon min 1 time 0
            - 字符回显关闭
              - stty -echo
    - 终端模式
      - termios.h
      - 输入速度
          - speed_t cfgetispeed(const struct termios *)
          - int cfsetispeed( struct termios *,speed_t speed)
      - 输出速度
          - speed_t cfgetospeed(const struct termios *)
          - int cfsetospeed( struct termios *,speed_t speed)
      - speed_t 值， 单位 波特
        - B0    终端挂起
        - B1200
        - B1200
        - B2400
        - B9600
        - B19200
        - B38400
        - ....
    - 其他函数
      - termios.h
      - 等待，直到所有排队的输出都发送完
        - int tcdrain(int fd)
      - 暂停或重新开始输出
        - int tcflow(int fd,int flowtype)
      - 清空输入，输出或者两种清空
        - int tcflush(int fd,int in_out_selector)
- 终端的输出和terminfo
  - 
- 检测键盘击键动作