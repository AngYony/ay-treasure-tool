# RabbitMQ的安装和配置



## 安装



### Docker安装RabbitMQ

```shell
docker run -d -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management
```