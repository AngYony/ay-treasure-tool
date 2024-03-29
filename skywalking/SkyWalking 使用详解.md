# SkyWalking 使用详解

Skywalking是一个可观测性分析平台和应用性能管理系统。它也是基于OpenTracing规范、开源的AMP系统。

Skywalking提供分布式跟踪、服务网格遥测分析、度量聚合和可视化一体解决方案。

- 支持.NET Core、C++、Golang代理。

- 支持Istio+特使服务网格。





## 链路追踪

对于一个大型的几十个，几百个微服务构成的微服务架构系统，经常会遇到下面一系列问题：

- 如何串联整个调用链路，快速定位问题
- 如何澄清各个微服务之间的依赖关系
- 如何进行各个微服务接口的性能分析
- 如何追踪各个业务流程的调用处理顺序

### 常见的链路追踪框架

- Zipkin
- Skywalking
- CAT



## Skywalking 存储选择

- H2：速度最快，类似于Redis。
- PostgreSQL
- ElasticSearch，生产推荐，缺点是耗资源，需要服务器比较强劲。
- TiDB





## Skywalking 环境搭建



