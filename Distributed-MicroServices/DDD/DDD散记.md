基础设施层的接口定义在领域层，而具体的实现放在基础设施层中。即：Infrastructure层不去定义接口，而是让它去实现领域层的接口。即一切从领域出发，而Infrastructure只负责具体的数据持久化工作。

基础设施层为其他各层提供常用的技术和基础服务。这些服务包括第三方工具、驱动程序、消息中间件、网关、文件、缓存和数据库等。它最常见的功能是提供数据库持久化。

API接口层的HTTP和RPC接口：返回值为Result，捕捉所有异常
Application层的所有接口返回值为DTO，不负责处理异常。



DTO应该放在Application层中，负责将内部领域模型转化为可对外的DTO。



闻逸:
1. VO一般用在视图层（展示层）中
2. 如果DTO就能够满足展示层需要，就直接使用dto；如果一个DTO对应多个VO，就需要定义多个VO。

闻逸:
如果一个模型是在其他层进行构建的，并且在展示层直接进行使用，就定义为ResultDTO。如果只在展示层构建而无需在其他层进行操作，就可以定义为ViewModel。
即：
ViewModel：仅用于展示层
ResultDTO：其他层构建的，传输到了展示层

闻逸:
DTO的命名规范可参考abp中的规则：https://docs.abp.io/zh-Hans/abp/latest/Data-Transfer-Objects