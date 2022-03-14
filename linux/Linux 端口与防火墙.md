# Linux 端口与防火墙

### 端口相关操作

```shell
# 检测端口号是否打开
telnet 192.168.2.126 7396 

# 查看监听的端口(正在使用的端口)
netstat -lnpt

# 检查指定的端口被哪个进程占用
netstat -lnpt |grep 5672
#查看进程的详细信息
ps 6832
#中止进程
kill -9 6832

# 查看防火墙所有开放的端口
firewall-cmd --zone=public --list-ports

# 开放新的端口
firewall-cmd --zone=public --add-port=5672/tcp --permanent   # 开放5672端口（--permanent永久生效，没有此参数重启后失效）

# 查看开启的端口
firewall-cmd --zone= public --query-port=80/tcp

# 移除指定的端口
firewall-cmd --zone=public --remove-port=5672/tcp --permanent  #关闭5672端口

# 配置立即生效
firewall-cmd --reload   

# 查看区域信息
firewall-cmd --get-active-zones

# 查看指定接口所属区域
firewall-cmd --get-zone-of-interface=eth0

# 拒绝所有包
firewall-cmd --panic-on

# 取消拒绝状态
firewall-cmd --panic-off

# 查看是否拒绝
firewall-cmd --query-panic
```



### 防火墙相关操作

参考：[CentOS7使用firewalld打开关闭防火墙与端口 - 莫小安 - 博客园 (cnblogs.com)](https://www.cnblogs.com/moxiaoan/p/5683743.html)

systemctl 是CentOS7的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。

```shell
# 查看防火墙状态
systemctl status firewalld 

# 启动防火墙
systemctl start firewalld

# 关闭防火墙
systemctl stop firewalld

# 重启防火墙
systemctl restart firewalld.service #可以将firewalld.service直接简写为firewalld

# 开机禁用防火墙
systemctl disable firewalld

# 开机启用防火墙
systemctl enable firewalld

# 查看防火墙是否开机启动
systemctl is-enabled firewalld.service
# 查看已启动的服务列表
systemctl list-unit-files|grep enabled
# 查看启动失败的服务列表
systemctl --failed

# 查看版本
firewall-cmd --version

# 查看帮助
firewall-cmd --help

# 显示状态
firewall-cmd --state

# 查看已启动的服务列表
systemctl list-unit-files|grep enabled

# 查看启动失败的服务列表
systemctl --failed


```








