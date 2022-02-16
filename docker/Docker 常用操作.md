# Docker 常用操作



### docker 服务关闭与重启

重启 docker 服务：

```shell
sudo systemctl restart docker
```

或：

```shell
sudo service docker restart
```

关闭 docker：

```shell
sudo systemctl stop docker
```

或：

```shell
sudo service docker stop
```



### 设置容器自启动

为已经存在的容器配置自启：

```shell
docker update --restart=always 容器id或容器名称
```

取消容器自启：

```shell
docker update --restart=no 容器id或容器名称
```

批量设置容器自启：

```shell
docker update --restart=always $(docker ps -aq)
```





