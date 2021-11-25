# Docker 安装与配置



## 安装docker

可参考官方文档：https://docs.docker.com/engine/install/centos/

### 安装docker命令

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



## 安装docker-compose

参考链接：

[安装码头工人撰写|码头文档 (docker.com)](https://docs.docker.com/compose/install/)

### 下载docker-compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

### 对二进制文件应用可执行权限

```
sudo chmod +x /usr/local/bin/docker-compose
```

