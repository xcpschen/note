# docker-api
采用标准HTTP状态码表示调用是否成功；相应体采用JSON数据包。

## 版本问题
API根据发行版不同而有所变更；因此API调用时确保客户端版本是否支持，可以通过`docker version`查看支持的api版本，如果要使用特殊版本时，请在URi加入版本信息，例如`/v1.30/info`，使用的是`v1.30`版本的info api

## 验证
验证客户端操作，验证信息结构如下：
```
{
  "username": "string",
  "password": "string",
  "email": "string",
  "serveraddress": "string"
}
```

`serveraddress` 字段是没有带协议信息域名或者Ip字段；该json结构 进过 base64url encoded后，写到请求头部`X-Registry-Auth`;

如果通过`/auth`获取token,作为`identitytoken`值。
