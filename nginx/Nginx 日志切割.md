# Nginx 日志切割

现有的日志都会存在 <code>access.log</code> 文件中，可以通过如下命令查看nginx安装时，指定的log存放位置：

```shell
/sbin/nginx -V
```

如下所示：

```
...
--error-log-path=/var/log/nginx/error.log
--http-log-path=/var/log/nginx/access.log
...
```

但是随着时间的推移，这个文件的内容会越来越多，体积会越来越大，不便于运维人员查看，所以我们可以通过把这个大的日志文件切割为多份不同的小文件作为日志。

切割规则可以以天为单位，如果每天有几百G或者几个T的日志的话，则可以按需以每半天或者每小时对日志切割一下。



## 创建日志切割的shell文件

可以创建一个用于切割日志的shell文件，每次执行该文件时，对日志进行切割。

第一步：创建shell文件

在 /usr/local/nginx/sbin/ 目录下，创建一个shell文件：

```shell
cd /usr/local/nginx/sbin/
vim cut_my_log.sh
```

内容如下：

```shell
#!/bin/bash
#指定日志所处的目录
LOG_PATH="/var/log/nginx/"
#设置切割后的文件名 
RECORD_TIME=$(date -d "yesterday" +%Y-%m-%d+%H:%M)
PID=/var/run/nginx/nginx.pid
mv ${LOG_PATH}/access.log ${LOG_PATH}/access.${RECORD_TIME}.log
mv ${LOG_PATH}/error.log ${LOG_PATH}/error.${RECORD_TIME}.log

#向Nginx主进程发送信号，用于重新打开日志文件
kill -USR1 `cat $PID`

```

第二步：为shell文件添加可执行权限。

```shell
chmod +x cut_my_log.sh
```

第三步：运行该文件，测试日志切割后的结果。

```shell
./cut_my_log.sh
```



## 定时执行日志切割

创建好shell文件之后，可以在Linux上添加定时任务，实现在指定时间点定时执行shell文件。

第一步：安装定时任务

安装crond服务：

```shell
yum install crontabs
```

第二步：设置定时任务

运行 `crontab -e` 命令，编辑并添加一行新的任务：

```shell
crontab -e
```

在打开的文件中添加如下内容：

```shell
*/1 * * * * /usr/local/nginx/sbin/cut_my_log.sh
```

左边是执行时间，后边是将要执行的shell文件。

定时的设定使用的是Cron表达式，常用表达式：

- 每分钟执行：

  ```
  */1 * * * *
  ```

- 每日凌晨（每天晚上23:59）执行：

  ```
  59 23 * * *
  ```

- 每天凌晨1点执行：

  ```
  0 1 * * *
  ```

第三步：重启定时任务

设置完成之后，必须重新定时服务，才能够运行：

```shell
service crond restart
```

附，该定时组件常用命令：

```
service crond start         //启动服务
service crond stop          //关闭服务
service crond restart       //重启服务
service crond reload        //重新载入配置
crontab -e                  // 编辑任务
crontab -l                  // 查看任务列表

```





