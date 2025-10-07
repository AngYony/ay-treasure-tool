# DDD实践总结

领域拆分的原则：

- 以减少分布式事务的产生为原则；
- 强耦合的两个不应该进行拆分，比如用户和权限。
- 应该以线性依赖为主，而不是网状依赖。

领域边界：绝对不是应拆尽拆，而是应该由粗到细。

业务中常见的领域：

- 用户与权限（比如登录、角色、权限等）







## 领域层（Domain）

领域层不会添加任何其他层的类库引用。也就是其它层依赖领域层，而领域层不依赖任何其他层。

### 实体

#### 充血模型

领域实体中的方法，即充血模型中的行为，它是为业务服务的，而不是为数据库服务的。（为数据库服务的东西很多，比如仓储）

充血模型规范：

- 充血模型中的方法只对实体进行赋值，只为了改变领域的状态。
- 必须是对属性进行了更改才叫充血模型，否则依然是贫血模型。
- 充血模型中的方法，是不能直接访问数据库的。而是使用领域事件。

充血模型下的实体示例：

```c#
public class Order
{
    public int Id { get; set; }
    public string Name { get; set; }

    /// <summary>
    /// 价格
    /// </summary>
    public decimal Price { get; set; }

    /// <summary>
    /// 积分
    /// </summary>
    public decimal Integral { get; set; }

    public Order SetPrice(decimal price)
    {
        this.Price = price * 0.8m;
        return this;
    }

    public void Pay()
    {
        Integral = Price * 10;

        //todo: 付款需要触发的领域事件
        //EventBus.Raise(new OrderPayEvent { Order = this });
    }
}
```

注意：实体中，是不允许直接访问数据库的。

[DDD简单实现领域服务 (qubcedu.com)](https://www.qubcedu.com/postdetail/3a05f540-3ba4-09a4-470a-a0c694e3c233/1)

### 领域事件和事件总线

领域事件的作用：

- 解耦性：领域事件可以让领域之间解耦，更加灵活的设计和修改领域
- 交互规范：领域事件是领域模型之间进行交互的一种规范，使之间的交互更加清晰明确
- 保持一致性：领域事件可以保证不同领域之间的数据一致性
- 支持异步：领域事件可以支持异步处理，提供系统的并发能力，降低系统复杂度。

==领域事件通过事件总线来触发==，下面的代码自定义了一个事件总线EventBus，实际使用中，推荐用MediatR作为总线组件。

定义领域事件的基类：

```c#
public abstract class DomainEvent
{
    public DateTime OccurredOn { get; protected set; }

    public DomainEvent()
    {
        OccurredOn = DateTime.Now;
    }
}

//定义领域事件
public class OrderPayEvent : DomainEvent
{
    public Order Order { get; set; }
}
```

定义事件总线：

```c#
/// <summary>
/// 事件总线，负责领域事件交互
/// </summary>
public static class EventBus
{
    private static readonly List<Delegate> _handlers = new List<Delegate>();

    public static void Register<T>(Action<T> handler) where T : DomainEvent
    {
        _handlers.Add(handler);
    }

    public static void Raise<T>(T domainEvent) where T : DomainEvent
    {
        foreach (var handler in _handlers)
        {
            if (handler is Action<T> action)
            {
                action.Invoke(domainEvent);
            }
        }
    }
}
```

定义处理订单相关的领域事件逻辑代码：

```c#
public class OrderHandler
{
    public void Handle(OrderPayEvent domainEvent)
    {
        Console.WriteLine($"订单 {domainEvent.Order.Id} 创建于 {domainEvent.Order.CreatedOn}.");
    }
}
```

**在实体中进行调用：**

```c#
public void Pay()
{
    Integral = Price * 10;
    //触发领域事件，执行上述的逻辑代码
    EventBus.Raise(new OrderPayEvent { Order = this });
}
```

Program测试代码：

```c#
var handler = new OrderHandler();
EventBus.Register<OrderPayEvent>(handler.Handle);
var order = new Order { Id = 1, Price = 100 };
order.Pay();
```



领域事件的实际应用场景：

- 分布式事务：当多个领域模型需要进行数据的更新时，可以通过领域事件保持事务的一致性。
- 业务流程：当领域模型之间需要进行复杂的业务流程时，可以通过领域事件来规范执行过程。
- 实时分析：当需要实时分析领域中的数据时，可以通过领域事件来捕获。
- 异步通信：当需要实现异步通信时，可以通过领域事件及消息队列来实现领域模型指向的异步交互。

[C#中DDD领域驱动设计与领域事件的使用 (qubcedu.com)](https://www.qubcedu.com/postdetail/3a0a0520-f20e-ca58-e9e7-553fd1cdf611/1)

### 聚合根

聚合根出现在顶层对象，例如Pool是顶层对象，PoolItems下级对象。注意：聚合根只针对顶层对象。

聚合根有唯一的标识：顶层对象的ID；可以通过该标识访问聚合根中的对象。

聚合根的设计需要遵循的原则：

- 不变性
- 聚合性
- 一致性
- 封装

聚合根只操作顶层实体，例如所有都操作都写在Pool中，而不是PoolItem中。顶层实体中的对下级对象操作的方法称为聚合方法。

标准规范下，聚合方法也不涉及对数据库的任何操作，只负责对当前领域的属性的状态更改。但并不是绝对的，例如ABP就在聚合根中进行了数据库操作。

[C#中DDD领域驱动设计的聚合根案例 (qubcedu.com)](https://www.qubcedu.com/PostDetail/3a0a432d-ee3f-b65a-38de-ed0225b81b5e/1)

### 领域服务

一般以**Manager结尾

领域服务一般不涉及增删改（需要考虑工作单元的情况），和数据库关联，只涉及到查询或验证操作。

领域服务是没有接口的。

[DDD简单实现领域服务 (qubcedu.com)](https://www.qubcedu.com/postdetail/3a05f540-3ba4-09a4-470a-a0c694e3c233/1)



## 应用服务层（Application）

### 应用服务

Application，abpvnext框架中，Application层还承担在微服务之间相互调度的协议服务。





todo:96.2



















微服务之间跨服务器。

DDD的核心就是领域。

一个微服务对应一个数据库，如果多个微服务对应同一个数据库，只能叫分布式。



领域事件用于通信交互。

如果是同一个单体项目内通信，可以使用事件总线。

如果是微服务的通信，一般使用RabbitMQ。

契约（如rpc）是同步的，事件总线的异步的。



最终一致性：通过记日志的方式，做二次补救（需要人工干预），实现幂等操作。大多数的订单都会有这种操作的存在。

强一致性：如果一个失败，都必须全部回滚，这种情况下，最好的处理方案是不拆，放在一个领域中。尤其是实时回滚的事务。

一般强耦合的时候，才使用rpc；EventBus是异步的（此处的异步不是Async），而是操作异步，只管发送出去即可。









 

abpvnext 的设计思想更多倾向于ERP项目的开发。



微服务设计：

一个服务一个解决方案。

鉴权授权平摊到每一个服务中，而不是在网关中。





为了不产生外键，使用[NotMapped]

IDesignTimeDbContextFactory



### 工作单元 WorkUnit（事务操作）

把对象的增删改组合成一个单元，要么一起成功，要么一起失败。防止出现脏数据，其实就是事务。





推荐阅读：

- [领域驱动设计与实现-ABP](https://docs.abp.io/zh-Hans/abp/latest/Domain-Driven-Design)
- [C#中DDD领域驱动设计与领域事件的使用 (qubcedu.com)](https://www.qubcedu.com/postdetail/3a0a0520-f20e-ca58-e9e7-553fd1cdf611/1)
- [DDD简单实现领域服务 (qubcedu.com)](https://www.qubcedu.com/postdetail/3a05f540-3ba4-09a4-470a-a0c694e3c233/1)
- [C#中DDD领域驱动设计的聚合根案例 (qubcedu.com)](https://www.qubcedu.com/PostDetail/3a0a432d-ee3f-b65a-38de-ed0225b81b5e/1)

