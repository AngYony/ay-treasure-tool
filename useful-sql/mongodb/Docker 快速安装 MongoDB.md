# Docker 快速安装 MongoDB

```shell
docker run -it --volume=/root/docker/mongo01/data:/data/db -p 27017:27017 --name mongo01 -d mongo
```

上述命令中，--volume指定数据库挂载的位置，防止docker停止后，数据丢失。

上述命令，没有指定密码。

