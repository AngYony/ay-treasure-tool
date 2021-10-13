# Docker 快速安装 Mysql



### 拉取mysql镜像文件

```
docker pull mysql:5.7
```

可以通过如下命令查看镜像文件：

```
docker images
```

### 启动mysql镜像

安装指定版本的MySQL：

```
docker run \
--detach  \
--name=mysql_imooc \
--env="MYSQL_ROOT_PASSWORD=root123456@" \
--publish 3306:3306 \
--volume=$PWD/conf:/etc/mysql/conf.d \
--volume=$PWD/logs:/logs \
--volume=$PWD/data:/var/lib/mysql \
mysql:5.7 \
--character-set-server=utf8 \
--collation-server=utf8_general_ci
```

可以直接使用下述命令，运行并安装最新版的mysql：

```
docker run \
--detach \
--name=mysql_imooc \
--env="MYSQL_ROOT_PASSWORD=root123456@" \
--publish 3306:3306 \
--volume=/root/docker/mysql_imooc/conf.d:/etc/mysql/conf.d \
--volume=/root/docker/mysql_imooc/data:/var/lib/mysql \
mysql/mysql-server:latest \
--character-set-server=utf8 \
--collation-server=utf8_general_ci
```

上述命令已经包含了拉取镜像、设置密码、挂载目录、设置编码格式等基本设置。

例如，下述命令表示：将主机下的/root/docker/mysql02/conf.d挂载到容器的/etc/mysql/conf.d 

```
--volume=/root/docker/mysql02/conf.d:/etc/mysql/conf.d \
```

### 查看mysql容器Id

```
docker ps -a
```

如果STATUS显示的是Exited状态，可以使用如下命令进行查看原因：

```
docker logs 镜像Id号
```

### 修改 Docker中的 MySql 外部连接策略（允许外部连接）：

~~方式一：修改全局配置文件/etc/mysql/my.conf，~~

~~执行下述命令：docker run -it mysql /bin/bash~~

找到bind-address = 127.0.0.1这一行

改为bind-address = 0.0.0.0即可，如果是容器挂载文件，需要重启容器才会生效。

方式二（推荐）：进入容器修改

```
docker exec -it mysql02 mysql -uroot -p
```

或

```
docker exec -it mysql镜像Id号 /bin/bash
mysql -uroot -p
```

输入密码后，进入到MySQL交互界面。

### 建立用户并授权

将root用户的密码设置为“abcd-1234”：

```
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'abcd-1234' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY 'abcd-1234' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'abcd-1234' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```

~~执行下述Mysql查询语句：~~

```
use mysql;
update user set host='%' where user='root'
flush privileges;
```

如果要退出mysql交互界面，可以输入“exit”，此时会退出到mysql的docker镜像环境，再次输入“exit”，将回到主机root交互界面。

### 测试连接

如果是云服务器，需要看是否开启了端口。

