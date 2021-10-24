# Nginx 命令汇总



### 查看 nginx 进程

```shell
ps -ef|grep nginx
```

该命令可以用于查看是否安装了nginx。



### 查看 Nginx 的版本

```shell
[root@iz2ze5h7x6ndjhrfjxumwcz wysoft]# /usr/local/nginx/sbin/nginx -v
nginx version: nginx/1.18.0
```

如果想要查看具体信息，比如安装时配置的参数信息，可以使用大写V进行查看：

```shell
/sbin/nginx -V
```



### 查看 nginx 帮助信息

```shell
/sbin/nginx -?
```

或者

```shell
/sbin/nginx -h
```



### 检测 nginx.conf 文件是否正常

进入到nginx目录，执行下述命令：

```shell
/sbin/nginx -t
```

该命令用于检测.conf文件是否有语法错误。

也可以检测指定的配置文件：

```shell
[root@iz2zea1fyfqa1d360k1vjaz nginx]# nginx -tc /sundot/nginx/nginx.conf
```



### 按照指定的配置文件启动Nginx

```
/nginx/sbin/nginx -c /sundot/nginx/nginx.conf
```



### 快速停止 nginx

该方式是暴力关闭nginx，不管当前是否有用户正在进行连接请求，都直接停止nginx。

```shell
/sbin/nginx -s stop
```

如果想要友好的停止 nginx，使用quit。

```shell
/sbin/nginx -s quit
```



### 快速重启 nginx

一般常用于配置文件发生了更改之后的，执行该命令进行快速重启。

```shell
/sbin/nginx -s reload
```







### 启动/停止/重启/查看 nginx 服务命令

```shell
cd sbin/
# 启动
systemctl start nginx
# 重启
systemctl reload nginx
# 停止
systemctl stop nginx
# 查看 Nginx 服务运行状态
systemctl status nginx
```

