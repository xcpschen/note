# Authentication
gRPC 认证可以基于或者不基于`Google token-based`认证的ssl/TLS，或者使用自定义插件在自己的认证系统里面认证。
gRPC也提供一种简单的api认证:当创建`channel`或者`调用时`把提供的必要的认证信息作为`证书`。
## Supported Auth Mechanisms
- ssl/TLS :gRPC内置
- ALTS：应用与谷歌云平台
- Token-based authentication with Google：在请求或者响应时负载证书的元数据；额外支持在访问Google API获取`access token`（例如：OAuth2 token） 来认证流程；通常认证机制必须在 SSL/TLS 上的`channel-Googel`，同时gRPC语言必须实现channel加密。

## Authentication API 
### Credential types
创建证书方式有两种：
- channel Credential: 通过channel附带证书认证，例如SSL 证书
- Call creadentials: 函数调用时，携带证书

### Using client-side SSL/TLS
客户端使用SSL/TLS认证和加密数据：
```
//C++
// Create a default SSL ChannelCredentials object.
auto channel_creds = grpc::SslCredentials(grpc::SslCredentialsOptions());
// Create a channel using the credentials created in the previous step.
auto channel = grpc::CreateChannel(server_name, channel_creds);
// Create a stub on the channel.
std::unique_ptr<Greeter::Stub> stub(Greeter::NewStub(channel));
// Make actual RPC calls on the stub.
grpc::Status s = stub->sayHello(&context, *request, response);
```
更多语言的请看[Authentication](https://grpc.io/docs/guides/auth/#with-server-authentication-ssltls)
`SslCredentialsOptions` 可以设置证书信息等，具体更语言实现有个。


### Using Google token-based authentication
```
// c++
auto creds = grpc::GoogleDefaultCredentials();
// Create a channel, stub and make RPC calls (same as in the previous example)
auto channel = grpc::CreateChannel(server_name, creds);
std::unique_ptr<Greeter::Stub> stub(Greeter::NewStub(channel));
grpc::Status s = stub->sayHello(&context, *request, response);
```
## Extending gRPC to support other authentication mechanisms 
通过证书插件API可以拓展自己的证书认证：
- MetadataCredentialsPlugin：需要实现`GetMetadata`
- MetadataCredentialsFromPlugin：在`MetadataCredentialsPlugin`创建一个`CallCredentials`对象
c++例子：
```
class MyCustomAuthenticator : public grpc::MetadataCredentialsPlugin {
 public:
  MyCustomAuthenticator(const grpc::string& ticket) : ticket_(ticket) {}

  grpc::Status GetMetadata(
      grpc::string_ref service_url, grpc::string_ref method_name,
      const grpc::AuthContext& channel_auth_context,
      std::multimap<grpc::string, grpc::string>* metadata) override {
    metadata->insert(std::make_pair("x-custom-auth-ticket", ticket_));
    return grpc::Status::OK;
  }

 private:
  grpc::string ticket_;
};

auto call_creds = grpc::MetadataCredentialsFromPlugin(
    std::unique_ptr<grpc::MetadataCredentialsPlugin>(
        new MyCustomAuthenticator("super-secret-ticket")));
```
# Article
- [Authentication](https://grpc.io/docs/guides/auth/#with-server-authentication-ssltls)