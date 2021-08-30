# MySQL 与 SQL Server 语法转换



## 变量相关操作

### 定义变量

sqlserver：

```mssql
DECLARE 
@now DATETIME =GETDATE(),
@tcId Int=0;
```

mysql：

方式一，使用DECLARE定义局部变量。

```mysql
DECLARE now DATETIME DEFAULT NOW();
DECLARE tcId Int default 0;
DECLARE TotalMomentCount Int DEFAULT 0;
```

方式二，直接定义用户变量，并赋值，不需要指定变量的类型。与局部变量的区别是，用户变量不用提前声明，在用的时候直接“@变量名”即可。

```mysql
SET @now=NOW();
SET @tcId=0;
或
set @age:=20;
```

注意：MySQL中的用户变量，受同一个连接的外部变量的影响，参考链接：[MySQL存储过程中declare和set定义变量的区别 - PC君 - 博客园 (cnblogs.com)](https://www.cnblogs.com/pcheng/p/4943096.html)

所以，推荐使用DECLARE定义变量。

### SELECT 变量赋值

sqlserver：

```mssql
select @wy=1
```

```mssql
SELECT TOP 1 @PoliticalScore=PoliticalScore,@PoliticalScoreType=PoliticalScoreType,@VirtualSallary=VirtualSallary FROM #votByUser
```

mysql：

在为用户变量赋值时，使用 select 时必须用 “`:=`” 赋值符号赋值。

```mysql
select @age:=22;
```

```mysql
select @age:=StuAge from demo.student where StuNo='A001';
```

在为使用 DECLARE 定义的局部变量赋值时，必须结合 SELECT...INTO... 进行赋值。

```mysql
SELECT es_role_id, es_role_name INTO v_role_id, v_role_name FROM es_role WHERE es_role_id=20; 
```

注意：使用SELECT...INTO...赋值时，变量名不能和字段名称相同，否则可能报错。

参考链接：[ Mysql SELECT INTO 一次性给多个变量赋值_爱喝咖啡的程序员的博客-CSDN博客](https://blog.csdn.net/miaomiao19971215/article/details/105693778)









## 临时表操作

### select ... into ...

sqlserver：

```mssql
SELECT 字段名 INTO #tempTableName FROM TableName
```

mysql：

```mysql
drop temporary table if exists new_table_name;
Create temporary table IF NOT EXISTS new_table_name (Select * from TableName);
```

或创建结构，再写入数据：

```mysql
create temporary table new_table_name(
　　id int primary key,
　　name varchar(20) 
)Engine=InnoDB default charset utf8;
```







## 事务

mysql事务处理，参考：[如何在mysql下实现事务的提交与回滚(try&catch)_weixin_34348111的博客-CSDN博客](https://blog.csdn.net/weixin_34348111/article/details/91824099)



## update ... inner join ...

sqlserver：

```mssql
UPDATE a SET a.Modifier = b.UserID,a.ModifyTime = GETDATE()
FROM T_Edu_AttendSignin a
INNER JOIN T_Base_Student b ON a.userid = b.userid
WHERE a.SignInDate = @SignInDate
```

mysql：

```mysql
UPDATE employees INNER JOIN merits ON employees.performance = merits.performance 
SET salary = salary + salary * percentage;
```

多表更新，同时更新T1，T2：

```mysql
UPDATE T1, T2,
[INNER JOIN | LEFT JOIN] T1 ON T1.C1 = T2. C1
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE condition
```

注意，必须在`UPDATE`子句之后至少指定一个表。`UPDATE`子句后未指定的表中的数据未更新。

参考链接：

- [MySQL update join语句 @狐狸教程:~# (freeaihub.com)](https://www.freeaihub.com/mysql/join-update.html)
- [Mysql使用update...inner join和select更新数据 - 经验笔记 (nhooo.com)](https://www.nhooo.com/note/qa0p9u.html)



## 日期与时间操作

### 获取日期字符串

mysql：

```mysql
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s');
```

字符串转时间：

```mysql
SELECT STR_TO_DATE('2019-01-20 16:01:45', '%Y-%m-%d %H:%i:%s');
```



## return

mysql的存储过程中没有return语句，需要借助LEAVE关键字实现。

```mysql
create PROCEDURE myproc()
proc_label:BEGIN
	...
	LEAVE proc_label; -- 跳出存储过程，proc_label是个别名，在begin前起的别名
	...
END
```



## WITH 语句

sqlserver：

```mssql
;WITH student AS 
(
	...
)
INSERT / SELECT
```

mysql：

```mysql
INSERT ... WITH ... SELECT ...
REPLACE ... WITH ... SELECT ...
CREATE TABLE ... WITH ... SELECT ...
CREATE VIEW ... WITH ... SELECT ...
DECLARE CURSOR ... WITH ... SELECT ...
EXPLAIN ... WITH ... SELECT ...
```

mysql中，需要将with语句放在要操作的后面，例如：

````
insert into talbeName(.....)
with wy as (...)
select * from wy;
````







## 其他注意点

mysql存储过程：

- 所有的语句都必须以分号结尾。
- 所有的declare语句，必须在存储过程开头进行声明。