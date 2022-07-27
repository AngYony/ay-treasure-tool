# Docker 安装与配置



## 安装docker

可参考官方文档：https://docs.docker.com/engine/install/centos/

### 安装docker命令

下载get-docker.sh文件到本地，并执行该文件。

```shell
curl -fsSL get.docker.com -o get-docker.sh
ls
sudo sh get-docker.sh
```

上述操作，也可以直接使用下述方式一步完成：

```shell
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 设置开机自动启动docker

```shell
systemctl enable docker
```

### 检查docker是否启动

```shell
docker ps -a 
ps -ef|grep docker
# 启动docker
systemctl start docker
```

### 配置阿里云镜像

登录阿里云，在“控制台”-“产品与服务”-"容器镜像服务"-“镜像加速器”页，有相关的配置方法，复制对应的shell脚本即可。

[容器镜像服务 (aliyun.com)](https://cr.console.aliyun.com/cn-qingdao/instances/mirrors)

```
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://f5dancr2.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### 启动docker

```
sudo systemctl start docker
```



## 安装docker-compose（最新版Docker已不需要单独安装）

参考链接：

[Install Docker Compose CLI plugin | Docker Documentation](https://docs.docker.com/compose/install/compose-plugin/#install-using-the-repository)

### 下载docker-compose

```
sudo curl -SL https://github.com/docker/compose/releases/download/v2.6.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
```

### 对二进制文件应用可执行权限

```
sudo chmod +x /usr/local/bin/docker-compose
```

