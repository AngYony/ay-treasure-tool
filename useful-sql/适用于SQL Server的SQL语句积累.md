# 适用于SQL Server的SQL语句积累



## 获取表的所有列名

```sql
SELECT name FROM sys.syscolumns WHERE id=OBJECT_ID(N'{dbo.TableName}',N'U')
```

跨库查询表的所有列名：

```mssql
SELECT name FROM [2014PSREF_Debug].sys.syscolumns WHERE id=OBJECT_ID(N'[2014PSREF_Debug].dbo.Ex_ThinkCentre_ThinkCentre_M920_Tower')
```

通过该语句可以扩展很多场景，例如查询某个表中所有列存储的数据值的最大长度。

```mssql
SELECT CONCAT('SELECT ''',name,''',maxLen= MAX(LEN(',name,')) FROM ts_i_EmpInfoFromAD UNION') FROM sys.syscolumns WHERE id=OBJECT_ID(N'dbo.ts_i_EmpInfoFromAD',N'U')
```



## 数据表快速备份

```mssql
SELECT * INTO 要创建的新的表名 FROM 旧表名;
```



## 去除重复项的Count统计

```mssql
select [Country],count(distinct [ClientIP]) from [RequestLog]  group by [Country]; 
```

该语句关键在于count统计distinct后的数据



## 表联接删除语句

```mssql
DELETE FROM Base_Customer FROM Base_Customer a INNER JOIN ts_i_prm_bp b ON a.PRMID=b.PRMID
```



## 使用循环的方法将字符串分割

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



## 将查询的结果显示为一行

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

除此之外，也可以使用变量运算的形式拼接：

```mssql
DECLARE @a NVARCHAR(MAX)='' --必须初始化
SELECT @a=@a+','+AttributeGUID FROM AttributeNameTable;
SELECT @a;
```



## sys.sp_executesql

使用sys.sp_executesql执行SQL语句时，SQL语句类型，必须定义为nvarchar，例如：

```mssql
DECLARE @sql NVARCHAR(200)=N'SELECT * FROM [Ex_ThinkPad_ThinkPad_X240] WHERE Model=@ModelCode';
```

### 带有参数的示例：

```mssql
DECLARE @Model NVARCHAR(100)='20AL0011++'
DECLARE @sql NVARCHAR(200)=N'SELECT * FROM [Ex_ThinkPad_ThinkPad_X240] WHERE Model=@ModelCode';
EXEC sys.sp_executesql @sql,N'@ModelCode  nvarchar(100)',@ModelCode=@Model;
PRINT @sql;
```

注意：外部调用时，需要指定@Model的定义参数，不需要指定@ModelCode。



## 使用 WAITFOR DELAY '0:0:10' 语句判断是否正在执行SQL的写入

```mssql
declare @Startdate datetime=getdate();
declare @countStart int;
declare @countEnd int;
select @countStart=count(1) from ts_i_em_BWbilling where ssisdatetime<@Startdate
WAITFOR DELAY '0:0:10';
select @countEnd=count(1) from ts_i_em_BWbilling
if @countEnd<>@countStart
     insert into GTN_SSIS_BWBilling_EMEA_log(jobRundatetime,dataPartialorNot) values(getdate(),1);
```



## 查看数据库被阻塞的情况

```mssql
SELECT
    SPID                = er.session_id                --当前窗口的ID
    ,STATUS             = ses.STATUS                   --正在执行的状态
    ,[LOGIN]            = ses.login_name               --当前的执行用户
    ,HOST               = ses.host_name                --从哪台电脑执行的程序
    ,阻塞者SPID              = er.blocking_session_id  --被哪个程序阻塞
    ,DBName             = DB_NAME(er.database_id)      --在哪个数据库上执行
    ,CommandType        = er.command                   --执行的是什么
    ,SQLStatement       = st.text                      --执行的是什么语句
    ,program_name               =ses.program_name
        ,status                         = er.status
    ,ObjectName         = OBJECT_NAME(st.objectid)
    ,ElapsedMS          = er.total_elapsed_time
    ,CPUTime            = er.cpu_time
    ,IOReads            = er.logical_reads + er.reads
    ,IOWrites           = er.writes
    ,LastWaitType       = er.last_wait_type
    ,StartTime          = er.start_time               --从什么时候开始执行的
    ,Protocol           = con.net_transport
    ,ConnectionWrites   = con.num_writes
    ,ConnectionReads    = con.num_reads
    ,ClientAddress      = con.client_net_address      --从哪里执行的IP地址
    ,Authentication     = con.auth_scheme
FROM sys.dm_exec_requests er
OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
LEFT JOIN sys.dm_exec_sessions ses
ON ses.session_id = er.session_id
LEFT JOIN sys.dm_exec_connections con
ON con.session_id = ses.session_id
WHERE er.session_id > 50
ORDER BY er.blocking_session_id DESC,er.session_id
```



## 添加主键

```mssql
--添加主键
	ALTER TABLE #pool_item_ag WITH NOCHECK ADD CONSTRAINT PK_rat_temp_pool_item_ag_poolItemID PRIMARY KEY CLUSTERED(PoolItemID);
```



## 添加唯一聚集索引

```mssql
--添加唯一聚集索引
CREATE UNIQUE CLUSTERED INDEX IX_temp_notNA_end_billing  ON #notNA_diff_billing  (BillingNumber, BillingItemNumber,PolicyNum,PoolItemID);
```



## row_number() over(partition by..) 

当需要查询某个结果集中的最新值、最小值、最大值时，可以使用row_number()over(partition by..）替换之前的MAX()等聚合函数，筛选出数据。

未优化前的语句：

```mssql
select 'history' as VersionType,h.PoolID,h.SalesOfficeCode,h.ProfitCenterCode,h.CompanyCurrency,sum(h.AccrualValue) as AccrualValue,sum(h.AccrualValueUSD) as AccrualValueUSD
        ,sum(h.AccrualValueP) as AccrualValueP
            from (
                select y.*
                from (select max(VersionDate) as VersionDate
                        ,BillingNumber
                        ,BillingItemNumber
                        ,BillingCategory
                        ,CompanyCode
                        ,GTNType
                        ,FISCYEAR
                        ,MTMSOURCEID
                        ,FactorSource
                        ,FactorId
                        ,PoolID
                        ,SegmentCode_3
                    from GTN_BillingByPoolHistory_EMEA_BW_Increment_2019Q4_S
                    where VersionDate<='2020-03-31'
                    group by BillingNumber
                        ,BillingItemNumber
                        ,BillingCategory
                        ,CompanyCode
                        ,GTNType
                        ,FISCYEAR
                        ,MTMSOURCEID
                        ,FactorSource
                        ,FactorId
                        ,PoolID
                        ,SegmentCode_3) as t
                left join GTN_BillingByPoolHistory_EMEA_BW_Increment_2019Q4_S as y
                on t.BillingNumber=y.BillingNumber
                        and t.BillingItemNumber=y.BillingItemNumber
                        and t.BillingCategory=y.BillingCategory
                        and t.CompanyCode=y.CompanyCode
                        and t.GTNType=y.GTNType
                        and t.FISCYEAR=y.FISCYEAR
                        and t.MTMSOURCEID=y.MTMSOURCEID
                        and t.FactorSource=y.FactorSource
                        and t.FactorId=y.FactorId
                        and t.PoolID=y.PoolID
                        and isnull(t.SegmentCode_3,'')=isnull(y.SegmentCode_3,'')
                        and t.VersionDate=y.VersionDate
                where y.IsDel=0
            )   h 
 group by h.PoolID,h.SalesOfficeCode,h.ProfitCenterCode,h.CompanyCurrency
```

优化后：

```mssql
select 'history' as VersionType,t1.PoolID,t1.SalesOfficeCode,t1.ProfitCenterCode,t1.CompanyCurrency,
SUM(t1.AccrualValue) as AccrualValue,sum(t1.AccrualValueUSD) as AccrualValueUSD
        ,sum(t1.AccrualValueP) as AccrualValueP 
from (
select
 PoolID
,SalesOfficeCode
,ProfitCenterCode
,CompanyCurrency
,AccrualValue
,AccrualValueUSD
,AccrualValueP
,IsDel
,row_number() OVER(partition by BillingNumber,BillingItemNumber,BillingCategory,CompanyCode,GTNType,FISCYEAR,MTMSOURCEID,FactorSource,FactorId,PoolID,SegmentCode_3 order by VersionDate desc) as rk
from GTN_BillingByPoolHistory_EMEA_BW_Increment_2019Q4_S
where VersionDate<='2020-03-31'
) t1
WHERE  t1.rk=1 and t1.IsDel=0 
group by t1.PoolID,t1.SalesOfficeCode,t1.ProfitCenterCode,t1.CompanyCurrency  OPTION ( MAXDOP 8 )
```



## 表连接时指定字符串类型的列排序规则

```mssql
SELECT * FROM  [dbo].[emea_pre_Q_final_increment_2020Q1] y INNER JOIN  #first t 
on t.BillingNumber collate chinese_prc_ci_as=y.BillingNumber
and t.BillingItemNumber collate chinese_prc_ci_as=y.BillingItemNumber
and t.BillingCategory collate chinese_prc_ci_as=y.BillingCategory
and t.CompanyCode collate chinese_prc_ci_as=y.CompanyCode
and t.GTNType collate chinese_prc_ci_as=y.GTNType
and t.FISCYEAR collate chinese_prc_ci_as=y.FISCYEAR
and t.MTMSOURCEID collate chinese_prc_ci_as=y.MTMSOURCEID
and t.FactorSource=y.FactorSource
and t.FactorId=y.FactorId
and t.PoolID=y.PoolID
and isnull(t.SegmentCode_3 collate chinese_prc_ci_as,'')=isnull(y.SegmentCode_3,'')
```



## 行转列 / 列转行

除了使用复杂的 SELECT...CASE 语句之外，更推荐使用 [PIVOT 和 UNPIVOT](https://docs.microsoft.com/zh-cn/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-ver15)，前者行转列，后者列转行。

使用 unpivot 列转行：

```mssql
SELECT ColumnName,ColumnValue FROM (
		SELECT * FROM [2014PSREF_Debug].dbo.Ex_ThinkCentre_ThinkCentre_M920_Tower WHERE Model='10SF0001KR'
	 ) a
    unpivot 
	(   
		 ColumnValue FOR ColumnName IN (Product,Region,[Machine Type])
	) up
```



## 字符串指定字符分割为list

```mssql
-- 字符串指定字符分割为list 
CREATE FUNCTION [dbo].[splitl] ( 
    @String VARCHAR(MAX), 
    @Delimiter VARCHAR(MAX) 
) RETURNS @temptable TABLE (items VARCHAR(MAX)) AS 
BEGIN 
    DECLARE @idx INT=1 
    DECLARE @slice VARCHAR(MAX)  
    IF LEN(@String) < 1 OR LEN(ISNULL(@String,'')) = 0 
        RETURN 
    WHILE @idx != 0 
    BEGIN 
        SET @idx = CHARINDEX(@Delimiter,@String) 
        IF @idx != 0 
            SET @slice = LEFT(@String,@idx - 1) 
        ELSE 
            SET @slice = @String 
        IF LEN(@slice) > 0 
            INSERT INTO @temptable(items) VALUES(@slice) 
        SET @String = RIGHT (@String, LEN(@String) - @idx) 
        IF LEN(@String) = 0 
            BREAK 
    END 
    RETURN 
END 
GO 
-- 调用方式  
SELECT * FROM dbo.splitl('aaa|bbb|ccc','|') 
```

## 数字去掉末尾的0

```mssql
-- 数字去掉末尾的0 
CREATE function [dbo].[ClearZero](@inValue varchar(50)) 
returns varchar(50) 
as 
begin 
declare @returnValue varchar(20) 
if(@inValue='') 
   set @returnValue='' --空的时候为空 
else if (charindex('.',@inValue) ='0') 
   set @returnValue=@inValue --针对不含小数点的 
else if ( substring(reverse(@inValue),patindex('%[^0]%',reverse(@inValue)),1)='.') 
          set @returnValue = 
            left(@inValue,len(@inValue)-patindex('%[^0]%',reverse(@inValue)))  
            --针对小数点后全是0的 
      else 
          set @returnValue =left(@inValue,len(@inValue)-  
                                 patindex('%[^0]%.%',reverse(@inValue))+1) --其他任何情形 
return @returnValue 
end 
--调用示例 
SELECT dbo.ClearZero(258.250300) 
```



## 创建表、视图、函数、存储过程判断是否存在

```mssql
/*判断函数/方法是否存在,若存在则删除函数/方法*/ 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'Func_Name')  
DROP FUNCTION Func_Name; 
GO 
--创建函数/方法 
CREATE FUNCTION Func_Name 
( 
    @a INT 
) 
RETURN INT 
AS 
BEGIN 
--coding 
END 
GO 
/*判断存储过程是否存在,若存在则删除存储过程*/ 
IF EXISTS (OBJECT_NAME('Proc_Name','P') IS NOT NULL DROP PROC Proc_Name; 
GO 
--创建存储过程 
CREATE PROC Proc_Name 
AS SELECT * FROM Table_Name 
GO 
/*判断数据表是否存在,若存在则删除数据表*/ 
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE name = 'Table_Name')  
DROP VIEW Table_Name; 
GO 
--创建数据表 
CREATE TABLE Table_Name 
( 
    Id INT PRIMARY KEY NOT NULL 
) 
/*判断视图是否存在,若存在则删除视图*/ 
IF EXISTS (SELECT * FROM sys.views WHERE name = 'View_Name')  
DROP VIEW View_Name  
GO 
--创建视图 
CREATE VIEW View_Name AS 
    SELECT SELECT * FROM table_name 
GO 
```

## 金额转换为大写

```mssql
/* 
    说明：数字金额转中文金额 
    示例：187.4 转成 壹佰捌拾柒圆肆角整 
*/ 
 
CREATE FUNCTION [dbo].[CNumeric](@num numeric(14,2)) 
    returns nvarchar(100) 
BEGIN 
    Declare @n_data nvarchar(20),@c_data nvarchar(100),@n_str nvarchar(10),@i int 
    Set @n_data=right(space(14)+cast(cast(abs(@num*100) as bigint) as nvarchar(20)),14) 
    Set @c_data='' 
    Set @i=1 
 
    WHILE @i<=14 
    Begin 
        set @n_str=substring(@n_data,@i,1) 
        if @n_str<>'' 
        begin 
        IF not ((SUBSTRING(@n_data,@i,2)= '00') or 
        ((@n_str= '0') and ((@i=4) or (@i=8) or (@i=12) or (@i=14)))) 
        SET @c_data=@c_data+SUBSTRING( N'零壹贰叁肆伍陆柒捌玖',CAST(@n_str AS int)+1,1) 
        IF not ((@n_str= '0') and (@i <> 4) and (@i <> 8) and (@i <> 12)) 
        SET @c_data=@c_data+SUBSTRING( N'仟佰拾亿仟佰拾万仟佰拾圆角分',@i,1) 
        IF SUBSTRING(@c_data,LEN(@c_data)-1,2)= N'亿万' 
        SET @c_data=SUBSTRING(@c_data,1,LEN(@c_data)-1) 
        END 
        SET @i=@i+1 
    END 
    IF @num <0 
        SET @c_data= '（负数）'+@c_data 
    IF @num=0 
        SET @c_data= '零圆' 
    IF @n_str= '0' 
        SET @c_data=@c_data+ '整' 
 
    RETURN(@c_data) 
END 
```

