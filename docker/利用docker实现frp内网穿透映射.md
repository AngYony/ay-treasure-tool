
## 五、利用frp内网穿透映射ssh和其他udp端口[通过Docker实现]

### 1. frp有服务端frps和客户端frpc，服务端需要一台有公网IP的服务器（假设你已经有了）

```
# 添加服务端配置文件，frps.ini
sudo vi /etc/frp/frps.ini

# 写入以下内容并保存

# frps.ini
[common]
#服务端和客户端握手端口
bind_port = 7000

# dashboard # frp服务端web查看面板
dashboard_port = 7500
dashboard_user = azure
dashboard_pwd = 000000
enable_prometheus = true

# 域名 此配置暂不需要
## vhost_https_port = 9090
#vhost_http_port = 9090


# 运行frps的docker容器,设置开机启动

docker run --restart=always --network host -d -v /etc/frp/frps.ini:/etc/frp/frps.ini --name frps snowdreamtech/frps

```

### 2. 运行frp客户端drpc容器

```
# 添加客户端端配置文件，frpc.ini
sudo vi /etc/frp/frpc.ini

# 写入以下内容并保存

# frpc.ini
[common]
#服务端公网ip或域名
server_addr = goku.azure.com
#服务端和客户端握手端口
server_port = 7000

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = 6000 #服务端映射的端口

[range:tcp_port]
type = tcp
local_ip = 127.0.0.1
local_port = 8080,9000,9090 #需要映射的本地端口
remote_port = 8080,9000,9090 #服务端对应的端口，无需和本地端口号一致，但是数量一定要对应

#[web]
# 域名 此配置暂不需要
## type=https
#type = http 
#local_port = 9090
#custom_domains = goku.azure.com


# 运行frpc的docker容器,设置开机启动

docker run --restart=always --network host -d -v /etc/frp/frpc.ini:/etc/frp/frpc.ini --name frpc snowdreamtech/frpc

# 确保服务端容器先跑起来，此时查看frpc客户端容器日志，查看是否代理成功
docker logs frpc
```

