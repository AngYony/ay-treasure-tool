# MySQL 与 SQL Server 语法转换



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



## SELECT 变量赋值

sqlserver：

```mssql
SELECT TOP 1 @PoliticalScore=PoliticalScore,@PoliticalScoreType=PoliticalScoreType,@VirtualSallary=VirtualSallary FROM #votByUser
```

mysql：

```mysql
SELECT  PoliticalScore,PoliticalScoreType,VirtualSallary into PoliticalScore,PoliticalScoreType,VirtualSallary FROM votByUser LIMIT 1;
```

参考链接：[ Mysql SELECT INTO 一次性给多个变量赋值_爱喝咖啡的程序员的博客-CSDN博客](https://blog.csdn.net/miaomiao19971215/article/details/105693778)







## 事务

mysql事务处理，参考：[如何在mysql下实现事务的提交与回滚(try&catch)_weixin_34348111的博客-CSDN博客](https://blog.csdn.net/weixin_34348111/article/details/91824099)



## 其他注意点

mysql存储过程：

- 所有的语句都必须以分号结尾。
- 所有的declare语句，必须在存储过程开头进行声明。