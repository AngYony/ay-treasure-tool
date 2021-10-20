# RabbitMQ的安装和配置



## 安装



### Docker安装RabbitMQ

```shell
docker run -d -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management
```

安装完成之后，可以通过浏览器访问对应的15672端口打开RabbitMQ的管理界面，默认用户名和密码都为guest。