# Nginx Lua 模块指令

Nginx共11个处理阶段，而相应的处理阶段是可以做插入式处理，即可插拔式架构；另外指令可以在`http、server、server if、location、location if`几个范围进行配置：

|指令	|所处处理阶段	|使用范围	|解释|
|-------|-------------|---------|----|
|init_by_lua|loading-config|	http	|nginx Master进程加载配置时执行；|
|init_by_lua_file|	loading-config|	http	|通常用于初始化全局配置/预加载Lua模块|
|init_worker_by_lua||||
|init_worker_by_lua_file|	starting-worker	|http	|每个Nginx Worker进程启动时调用的计时器，如果Master进程不允许则只会在init_by_lua之后调用；通常用于定时拉取配置/数据，或者后端服务的健康检查|
|set_by_lua,set_by_lua_file	|rewrite|server,server if,location,location if|	设置nginx变量，可以实现复杂的赋值逻辑；此处是阻塞的，Lua代码要做到非常快；|
|rewrite_by_lua|rewrite|http,server,location,location if |rewrite阶段处理，可以实现复杂的转发/重定向逻辑；|
rewrite_by_lua_file	|tail| if| 可以实现复杂的转发/重定向逻辑|
|access_by_lua,access_by_lua_file| access ,tail|	http,server,location,location if	|请求访问阶段处理，用于访问控制|
|content_by_lua,content_by_lua_file|	content	|location,location if	|内容处理器，接收请求处理并输出响应|
|header_filter_by_lua,header_filter_by_lua_file|output-header-filter|http，server，location，location if|设置header和cookie|
|body_filter_by_lua,body_filter_by_lua_file	|output-body-filter	|http，server，location，location if	|对响应数据进行过滤，比如截断、替换。|
|log_by_lua,log_by_lua_file	|log	|http，server，location，location if|log阶段处理，比如记录访问量/统计平均响应时间|