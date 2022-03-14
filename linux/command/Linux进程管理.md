# Linux进程管理

## 进程的概念与进程查看

进程的概念
• 进程—运⾏行行中的程序，从程序开始运⾏行行到终⽌止的整个⽣生命周期是可管理理的
• C 程序的启动是从 main 函数开始的
• int main(int agrc, char *argv[])
• 终⽌止的⽅方式并不不唯⼀一，分为正常终⽌止和异常终⽌止
• 正常终⽌止也分为从 main 返回、调⽤用 exit 等⽅方式
• 异常终⽌止分为调⽤用 abort、接收信号等



进程的查看命令
• 查看命令
• ps
• pstree
• top
• 结论：
• 进程也是树形结构
• 进程和权限有着密不不可分的关系



## 进程的控制命令

进程的优先级调整
• 调整优先级
• nice 范围从-20 到 19 ，值越⼩小优先级越⾼高，抢占资源就越多
• renice 重新设置优先级
• 进程的作业控制
• jobs
• & 符号  



## 进程的通信⽅方式— 信号

进程间通信
• 信号是进程间通信⽅方式之⼀一，典型⽤用法是：终端⽤用户输⼊入中断命令，通过信号机制
停⽌止⼀一个程序的运⾏行行。
• 使⽤用信号的常⽤用快捷键和命令
• kill -l
• SIGINT 通知前台进程组终⽌止进程 ctrl + c
• SIGKILL ⽴立即结束程序，不不能被阻塞和处理理 kill -9 pid  

## 守护进程和系统⽇日志

守护进程
• 使⽤用 nohup 与 & 符号配合运⾏行行⼀一个命令
• nohup 命令使进程忽略略 hangup（挂起）信号
• 守护进程(daemon)和⼀一般进程有什什么差别呢？
• 使⽤用 screen 命令
• screen 进⼊入 screen 环境
• ctrl+a d 退出 (detached) screen 环境
• screen -ls 查看 screen 的会话
• screen -r sessionid 恢复会话  

系统⽇日志
• 常⻅见的系统⽇日志
• /var/log
• message
• dmesg
• cron
• secure  





## 服务管理理⼯工具 systemctl

服务管理理⼯工具systemctl
• 服务（提供常⻅见功能的守护进程）集中管理理⼯工具
• service
• systemctl  



服务管理理⼯工具systemctl
• systemctl 常⻅见操作
• systemctl start | stop | restart | reload | enable | disable 服务名称
• 软件包安装的服务单元 /usr/lib/systemd/system/  

服务管理理⼯工具 systemctl
• systemctl 的服务配置
• [Unit]
• Requires = 新的依赖服务
• After = 新的依赖服务
• [Service]
• [Install]
• 安装到哪个默认启动级别 /lib/systemd/system
• systemctl get-default | set-default



## SELinux 简介

SELinux 简介
• MAC（强制访问控制）与 DAC（⾃自主访问控制）
• 查看 SELinux 的命令
• getenforce
• /usr/sbin/sestatus
• ps -Z and ls -Z and id -Z
• 关闭 SELinux
• setenforce 0
• /etc/selinux/sysconfig