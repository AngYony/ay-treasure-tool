# 适用于SQL Server的SQL语句积累



### 获取表的所有列名

```sql
SELECT name FROM sys.syscolumns WHERE id=OBJECT_ID(N'{dbo.TableName}',N'U')
```

通过该语句可以扩展很多场景，例如查询某个表中所有列存储的数据值的最大长度。

```mssql
SELECT CONCAT('SELECT ''',name,''',maxLen= MAX(LEN(',name,')) FROM ts_i_EmpInfoFromAD UNION') FROM sys.syscolumns WHERE id=OBJECT_ID(N'dbo.ts_i_EmpInfoFromAD',N'U')
```



### 数据表快速备份

```mssql
SELECT * INTO 要创建的新的表名 FROM 旧表名;
```



### 去除重复项的Count统计

```mssql
select [Country],count(distinct [ClientIP]) from [RequestLog]  group by [Country]; 
```

该语句关键在于count统计distinct后的数据



### 表联接删除语句

```mssql
DELETE FROM Base_Customer FROM Base_Customer a INNER JOIN ts_i_prm_bp b ON a.PRMID=b.PRMID
```



### 使用循环的方法将字符串分割

```mssql
DECLARE @P_SalesOrg VARCHAR(100)='abc,de,sgcg,efg,ef'
declare @All_SalesOrg VARCHAR(1000)='c,e,d,a'
DECLARE @sumlength INT =LEN(@P_SalesOrg)--获取传入的总长度
DECLARE @start INT=1
DECLARE @index INT = CHARINDEX(',',@P_SalesOrg) --获取逗号出现的位置，截取第一个字符
DECLARE @onelength INT
IF @index<>0
BEGIN
    SET @onelength=@index-1
    PRINT SUBSTRING(@P_SalesOrg,@start,@onelength); 
END
ELSE BEGIN
    SET @onelength=@sumlength;
END
WHILE @index<>0
BEGIN
    SET @index=@start+@onelength; --获取逗号出现的位置
        SET @start=@index+1; --下一个字符 开始位置
        --PRINT @start;
        SET @index=CHARINDEX(',',SUBSTRING(@P_SalesOrg,@start,@sumlength-@index));--获取下一个逗号在剩余字符中出现的位置
        IF @index<>0
        BEGIN      
            SET @onelength=@index-1;--获取字符长度
            PRINT SUBSTRING(@P_SalesOrg,@start,@onelength); --sgcg
        END 
        ELSE BEGIN
            PRINT SUBSTRING(@P_SalesOrg,@start,@sumlength-@index)
        END   
       
END 
```



### 将查询的结果显示为一行

```mssql
select STUFF((SELECT ','+SalesOrgCode FROM  Sys_Employee_DataAuth a WHERE  ITCode='mayh6' and IsReport=1 FOR XML PATH('')),1,1,'') 
```

多个结果列：

```mssql
SELECT BillingNumber , stuff(
    (
    	SELECT ',' + CONVERT(VARCHAR(10),FactorId) FROM
    	ts_i_em_BWbilling_Accrual_EndCus_Split_temp AS a
    	WHERE a.BillingNumber=b.BillingNumber ORDER BY FactorId FOR xml path('')
    ), 1, 1, '')
FROM ts_i_em_BWbilling_Accrual_EndCus_Split_temp b
GROUP BY BillingNumber
```



### sys.sp_executesql

使用sys.sp_executesql执行SQL语句时，SQL语句类型，必须定义为nvarchar，例如：

```mssql
DECLARE @sql NVARCHAR(200)=N'SELECT * FROM [Ex_ThinkPad_ThinkPad_X240] WHERE Model=@ModelCode';
```

#### 带有参数的示例：

```mssql
DECLARE @Model NVARCHAR(100)='20AL0011++'
DECLARE @sql NVARCHAR(200)=N'SELECT * FROM [Ex_ThinkPad_ThinkPad_X240] WHERE Model=@ModelCode';
EXEC sys.sp_executesql @sql,N'@ModelCode  nvarchar(100)',@ModelCode=@Model;
PRINT @sql;
```

注意：外部调用时，需要指定@Model的定义参数，不需要指定@ModelCode。

