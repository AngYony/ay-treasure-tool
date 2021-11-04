# RabbitMQ 介绍与核心概念

RabbitMQ 是一个开源的消息代理和队列中间件，用来通过普通协议在完全不同的应用之间共享数据。

RabbitMQ 是使用 Erlang 语言来编写的，基于 AMQP 协议。



## AMQP

AMQP 全称：Advanced Message Queuing Protocol，高级消息队列协议。

AMQP 定义：是具有现代特征的二进制协议。是一个提供统一消息服务的应用层标准高级消息队列协议，是应用层协议的一个开放标准，为面向消息的中间件设计。

![image-20211104181307932](assets/image-20211104181307932.png)



### AMQP 核心概念

- **Server**：又称 Broker，接受客户端的连接，实现 AMQP 实体服务；
- **Connection**：连接，应用程序与 Broker 建立的网络连接；
- **Channel**：网络信道，几乎所有的操作都在 Channel 中进行，Channel 是进行消息读写的通道。客户端可以建立多个 Channel，每个 Channel 代表一个会话任务。
- **Message**：消息，服务器和应用程序之间传送的数据，由 Properties 和 Body 组成。Properties 可以对消息进行修饰，比如消息的优先级、延迟等高级特性；Body 则就是消息体内容。
- **Virtual host**：虚拟主机地址，用于进行逻辑隔离，最上层的消息路由。一个 Virtual Host 里面可以有若干个 Exchange 和 Queue，但同一个 Virtual Host 里面不能有相同名称的 Exchange 或 Queue。
- **Exchange**：交换机，接收消息，根据**路由键（routing key）**转发消息到绑定的队列。
- **Binding**：Exchange 和 Queue 之间的虚拟连接，binding 中可以包含 routing key。
- **Routing key**：一个路由规则，虚拟机可用它来确定如何路由一个特定消息。
- **Queue**：也称为 Message Queue，消息队列，保存消息并将它们转发给消费者。



## RabbitMQ 整体架构图

RabbitMQ的整体架构模型：

![image-20211104192242191](assets/image-20211104192242191.png)

- exchange和message queue可以是多对多的关系，但在实际开发中，一般采用一对多的关系，一个exchange对应多个queue。
- 一个queue可以被多个consume消费，但在实际开发中， 一般采用一个queue只被一个特定的consume消费。



## RabbitMQ 消息如何流转

RabbitMQ的消息流转过程：

![image-20211104192621869](assets/image-20211104192621869.png)