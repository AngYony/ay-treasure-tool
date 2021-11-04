# lrzsz.x86_64 : The lrz and lsz modem communications programsLinux 常用操作大全



### 解压缩包

将wy.tar.gz压缩包解压到~/app/目录下：

```shell
tar -zxvf wy.tar.gz -C ~/app/
```

### 从文件的的最新位置查看文件

如果某个文件太大，直接使用vim打开会耗时较长，此时可以使用tail命令，该命令将从文件的最新位置进行打开查看。

```shell
tail app.log
```

如果想要动态的查看文件的最新变化，可以加上-f选项。

```shell
tail app.log -f
```

此时，一旦app.log文件发生了变化，都会反映在打开的窗口中。

### 将一个文件复制到另一台服务器上

使用scp命令实现文件的发送。

示例一：将当前目录下的sentinel.conf文件，复制到192.168.171.200的/usr/local/redis/目录中：

```shell
scp sentinel.conf root@192.168.171.200:/usr/local/redis/
```

示例二：将远端192.168.73.131的~/dump.db文件，复制到本地当前目录下：

```shell
scp root@192.168.73.131:~/dbdump.db .
```



### 使用rz命令上传本地文件到服务器上

除了使用类似FileZilla这种工具之外，还可以使用rz命令。

使用之前需要进行安装：

```shell
[root@localhost ~]# rz
-bash: rz: 未找到命令
[root@localhost ~]# yum search rz
...
lrzsz.x86_64 : The lrz and lsz modem communications programs
...
[root@localhost ~]# yum install lrzsz
```

安装完成之后，进入到要上传的目标目录，执行rz命令，会弹出文件选中对话框，选中文件之后，将会上传到服务器上的当前目录中。

```shell
[root@localhost ~]# cd /home/software
[root@localhost software]# rz  
```

