# Linux网络管理



## 网络状态查看

可以使用 net-tools 或 iproute2 进行网络相关的管理。

### net-tools

CentOS7之前版本的网络管理工具。

相关的查看命令有：

- ifconfig
- 

#### ifconfig

```
ifconfig
```

- eth0 第一块网卡（网络接口）
- 你的第⼀个网络接口可能叫做下面的名字：
  - eno1 板载网卡
  - ens33 PCI-E网卡
  - enp0s3 无法获取物理信息的 PCI-E 网卡
  - CentOS 7 使用了了一致性网络设备命名，以上都不匹配则使用 eth0

⽹网络接⼝口命名修改  :

⽹网卡命名规则受 biosdevname 和 net.ifnames 两个参数影响
• 编辑 /etc/default/grub ⽂文件，增加 biosdevname=0 net.ifnames=0
• 更更新 grub
• # grub2-mkconfig -o /boot/grub2/grub.cfg
• 重启
• # reboot
biosdevname net.ifnames ⽹网卡名
默认 0 1 ens33
组合1 1 0 em1
组合2 0 0 eth0查看⽹网络情况
• 查看⽹网卡物理理连接情况
• mii-tool eth0





#### route

查看⽹网关命令
• 查看⽹网关
• route -n
• 使⽤用 -n 参数不不解析主机名



#### netstat

### iproute2

CentOS7及之后版本主推的网络工具。

#### ip

#### ss





##  网络配置

ifconfig <接⼝口> <IP地址> [netmask ⼦子⽹网掩码 ]
• ifup <接⼝口>
• ifdown <接⼝口>  



⽹网关配置命令
• 添加⽹网关
• route add default gw <⽹网关ip>
• route add -host <指定ip> gw <⽹网关ip>
• route add -net <指定⽹网段> netmask <⼦子⽹网掩码> gw <⽹网关ip



## 路由命令

⽹网络命令集合： ip 命令
• ip addr ls
• ifconfig
• ip link set dev eth0 up
• ifup eth0
• ip addr add 10.0.0.1/24 dev eth1
• ifconfig eth1 10.0.0.1 netmask 255.255.255.0
• ip route add 10.0.0/24 via 192.168.0.1
• route add -net 10.0.0.0 netmask 255.255.255.0 gw 192.168.0.1







## 网络故障排除

⽹网络故障排除命令
• ping
• traceroute
• mtr
• nslookup
• telnet
• tcpdump
• netstat
• ss





## 网络服务管理

⽹网络服务管理理
• ⽹网络服务管理理程序分为两种，分别为SysV和systemd
• service network start|stop|restart
• chkconfig -list network
• systemctl list-unit-files NetworkManager.service
• systemctl start|stop|restart NetworkManger
• systemctl enable|disable NetworkManger



## 常用网络配置文件  

⽹网络配置⽂文件
• ifcfg-eth0
• /etc/hosts



⽹网络其他命令
• hostname
• hostnamectl
• hostnamectl set-hostname centos7.test
• 注意修改/etc/hosts⽂文件  