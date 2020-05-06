# Redis从入门到实践



## Redis初识

### Redis是什么

开源、基于键值的存储服务系统、多种数据结构，高性能、功能丰富。

### Redis的特性回顾

- 速度快，官方宣称10W OPS（每秒实现10万次读写），Redis将数据存放在内存当中的（Redis速度快的最主要的原因）。Redis是单线程的线程模型。
- 持久化（断电不丢数据）：Redis所有数据保持在内存中，对数据的更新将异步地保存到磁盘上。
- 多种数据结构：Strings/Blobs/Bitmaps（位图）、Hash Tables(objects)、Linked Lists、Sets、Sorted Sets、HyperLogLog（超小内存唯一值计数）、GEO（地理信息定位）
- 支持多种编程语言
- 功能丰富：发布订阅、Lua脚本（实现自定义命令）、事务、pipeline（并发效率）
- 简单：不依赖外部库、单线程模型。
- 主从复制：主服务器可以将数据复制到从服务器上。
- 高可用、分布式：Redis-Sentinel（v2.8）支持高可用。Redis-Cluster(V3.0)支持分布式。

### Redis典型使用场景

- 缓存系统：Storate（MySQL）------->Cache（Redis）------> App Server（Nginx）
- 计数器
- 消息队列系统
- 排行榜
- 社交网络
- 实时系统：垃圾邮件、布隆过滤器

### Redis单机安装





## API的理解和使用

## Redis客户端的使用

## Redis其他功能

## Redis持久化的取舍和选择

## Redis复制的原理和优化

## Redis Sentinel

## Redis Cluster



