# MySQL 语法



## 变量

### 局部变量

```mysql
CREATE PROCEDURE 方法名()
BEGIN
    定义
      DECLARE 变量名 数据类型 DEFAULT [默认值]
    赋值
      SET 变量名 = 值
      将SELECT查询语句的结果赋值给变量
      SELECT ... INTO 变量名 FROM.....;
END
使用
    CALL 方法名();
删除
    DROP PROCEDURE pro_vari;
```

### 用户变量

```mysql
定义：
 SET @变量名 = 值;
使用：
 SELECT @变量名;
```

### 会话变量

```mysql
每次建立新的连接的时候由MYSQL初始化
修改定义
SET 变量名 = 值;
查看定义
SHOW SESSION VARIABLES;
```

### 全局变量

```mysql
通过my.ini文件修改定义变量
查看定义
SHOW GLOBAL VARIABLES;
```



## 控制结构

### IF 

```mysql
IF 条件 THEN 
满足条件执行的代码
ELSEIF 条件2 THEN
满足条件2执行的代码
ELSE
条件都不满足执行的代码
END IF;
```

### 循环

- REPEAT
- WHILE
- LOOP

```mysql
WHILE 继续条件 DO 
执行的代码
END WHILE;

REPEAT
执行的代码
UNTIL 结束条件
END REPEAT;
```

#### 跳出循环

```mysql
循环名:WHILE 继续条件 DO 
执行的代码
循环跳出关键字(iterate or leave) 循环名;
END WHILE 循环名;
```

##### 跳过当次循环

```mysql
- iterate
```

##### 终止循环

````mysql
- leave
````



## 存储过程

- 接收输入参数并以输出参数的形式将多个值返回至调用过程或批处理
- 包含执行数据库操作
- 优点
  - 安全机制：只给用户访问存储过程的权限，而不授予用户访问表和视图的权限
  - 改良了执行性能：只在第一次执行时进行编译，以后执行无需重新编译
  - 减少网络流量：存储在服务器中
  - 模块化的程序设计：减少重写次数



### 有输入参数的存储过程

```mysql
CREATE PROCEDURE 方法名(IN 参数名 参数定义)
BEGIN
    使用：调用参数名;
    SELECT 返回列 FROM 表 WHERE 列=参数;
END
CALL 方法名(实际参数);
```

### 有输出参数的存储过程

```mysql
CREATE PROCEDURE 方法名(OUT 参数名 参数定义)
BEGIN
    使用：调用参数名;
    SELECT 返回列 INTO 参数 FROM 表;
END
CALL 方法名(@实际参数);
SELECT @实际参数;
```



## 触发器

- 特殊类型的存储过程，不由用户直接调用
- 特点
  - 与表紧密相连，可以看作表定义的一部分
  - 不能通过名称被直接调用，更不允许带参数，而是当用户对表中的数据进行修改肘，自动执行
  - 可以用于MySQL约束、默认值和规则的完整性检查，实施更为复杂的数据完整性约束。
- 触发器里可通过new来获取将要插入或者更新的数据
- 触发器里可通过o1d来获取更新之前或者将要删除的数据



```mysql
CREATE TRIGGER 触发器名 
BEFORE/AFTER(操作之前或之后) 
INSERT/UPDATE/DELETE(操作类型)
ON 表名 FOR EACH ROW
BEGIN
    满足条件执行的代码(可包含SQL语句)
END
```



## 事务

- 事务是一个不可分割的工作逻辑单元
- 多个操作作为一个整体向系统提交，要么都执行、要么都不执行
- MyISAM：不支持事务，用于只读程序提高性能
- Innodb：引擎不能结构化编程，只能通过标记为开启、提交或回滚事务

### 事务特性

- 原子性
  - 组成事务处理的语句形成了一个逻辑单元，不能只执行其中的一部分。换句话说，事务是不可分割的最小单元。比如：银行转帐过程中，必须同时从一个帐户减去转帐金额，并加到另一个帐户中，只改变一个帐户是不合理的。
- 一致性：
  - 在事务处理执行前后，数据库是一致的。也就是说，事务应该正确的转换系统状态。比如：银行转帐过程中，要么转帐金额从一个帐户转入另一个帐户，要么两个帐户都不变，没有其他的情况。
- 隔离性：
  - 一个事务处理对另一个事务处理没有影响。就是说任何事务都不可能看到一个处在不完整状态下的事务。比如说，银行转帐过程中，在转帐事务没有提交之前，另一个转帐事务只能处于等待状态。
- 持久性：
  - 事务处理的效果能够被永久保存下来。反过来说，事务应当能够承受所有的失败，包括服务器、进程、通信以及媒体失败等等。比如：银行转帐过程中，转帐后帐户的状态要能被保存下来。

### 事务控制语句

- BEGIN或START TRANSACTION：显式地开启一个事务
- COMMIT：也可以使用COMMITWORK，不过二者是等价的。COMMIT会提交事务，并使己对数据库进行的所有修改称为永久性的；
- ROLLBACK：有可以使用ROLLBACK WORK，不过二者是等价的。回滚会结束用户的事务，并撤销正在进行的所有未提交的修改；SAVEPOINT identifier；SAVEPOINT允许在事务中创建一个保存点，一个事务中可以有多个SAVEPOINT；RELEASE SAVEPOINT identifier；删除一个事务的保存点，当没有指定的保存点时，执行该语句会抛出一个异常；
- ROLLBACK TO identifier；把事务回滚到标记点；SET TRANSACTION；用来设置事务的隔离级别。InnoDB存储引擎提供事务的隔离级别有READ UNCOMMITTED、READ COMMITTED、REPEATABLE READ和SERIALIZABLE。



## 条件处理器

```mysql
CREATE PROCEDURE 环境名()
BEGIN
DECLARE 指定程序是否继续执行 
HANDLER FOR 异常类型发生异常要执行的代码;
END
```



## 游标

```mysql
定义
DECLARE 游标名 CURSOR FOR select语句;
打开游标
open 游标名;
取值
FETCH 游标名 INTO 变量名;
关闭游标
close 游标名;
```

