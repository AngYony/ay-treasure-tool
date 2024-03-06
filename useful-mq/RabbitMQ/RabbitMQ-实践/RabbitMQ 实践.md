# RabbitMQ 实践

一个完整的消息生产与消费，需要实现如下几个过程：

- ConnectionFactory：获取连接工厂
- Connection：建立一个连接
- Channel：创建数据通信信道，可发送和接收消息；
- Queue：具体的消息存储队列
- Producer & Consumer：生产者和消费者



实际开发中，选择手动ACK。



实际开发中，不建议使用代码的形式，绑定Exchange和Queue，而是使用Rabbit的Web操作界面维护好。



