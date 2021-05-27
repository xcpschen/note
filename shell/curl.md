# Curl
> curl [options / URLs]
curl 是一个传输数据工具，支持多种传输协议。

## 支持协议
根据URL的`schemes`来决定使用那种协议
- DICT：使用在线词典查看单词
- FILE：读取本地文件，不支持URL为file://URL；但是在window下可以使用原生UNC
- FTP(s)：
- GOPHER：取回文件
- HTTP(s)
- IMAP(s)：邮件协议，下载邮件
- LDAP(s)
- MQTT：消息队列订阅
- POP3：通过POP3协议下载邮件
- RTMP(s)：即时消息，流媒体消息
- RTSP：1.0RTSP
- SCP：ssh协议2 scp传输
- SFTP：
- SMB（s）
- SMTP(s)
- TELNET 
- TFTP

## 输出控制
默认输出到标准控制台stdout，可以通过`-o, --output` or ` -O, --remote-name`选项保存到本地文件

## 选项
短横杆选项，双短横杆

### --abstract-unix-socket <path>
使用抽象Unix域socket,而非网络socket;

### --alt-svc <file name>
