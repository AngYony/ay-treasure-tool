USE [NewGTN_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  wangyang    
-- Create date: 2019-12-25  
-- Description:AccountTemplate 优化
-- =============================================    
ALTER PROCEDURE [dbo].[GTN_Report_AccountTemplate_AG_NA_WangYang]
	@FY INT,
	@FiscalMonth INT,
	@RegionCode VARCHAR(50)=NULL,
	@DummyOrg VARCHAR(50)=NULL,
	@SalesOrgCode VARCHAR(50)=NULL,
	@ITCode VARCHAR(80) = NULL, --如@ITCode=null，则表明当前是由SuperAdmin做的报表请求	
	@BGCode VARCHAR(50)=NULL    --2018年7月24日  添加 @BGCode VARCHAR(50)=null 	
AS
BEGIN
	SET NOCOUNT ON;
	

	--#######################################################################################################
	--##*****************************************************************************************************
	--##**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读**改前必读***  
	--##-----------------------------------------------------------------------------------------------------
	--##**对本存储过程的任何改动，请务必通知作者（wangyang)，否则将以作者本地保存的代码为主，额外添加的代码一旦丢失，概不负责！！！
	--##*****************************************************************************************************
	--########################################################################################################

	--注意：Increment中存储的PoolCode有误，实际的应该存储的是PoolItemCode，因此牵扯到PoolCode的显示，一律通过PoolItem关联进行查询



	DECLARE @BeginDate DATE=CONVERT(DATE,CONCAT(@FY,'-',@FiscalMonth,'-01')); --传入月份的第一天
	DECLARE @EndDate DATE = DATEADD(DAY,-1,DATEADD(MONTH,1,@BeginDate));--传入月份的最后一天
	DECLARE @SQLStatement NVARCHAR(max) --动态SQL


	--创建Pool临时表并添加必要的索引，为了避免产生大量日志，采用select..into..方式写入（备注：如果Pool表的数据超过5万，请改用create方式，以缓和系统表资源）
	IF OBJECT_ID('tempdb..#pool_item_ag') IS NOT NULL  BEGIN
	           DROP TABLE #pool_item_ag
	END
	SELECT ID AS PoolItemID,BusinessGroup,APCCode INTO #pool_item_ag FROM GTN_Pool_Item_AG  AS p  WITH(NOLOCK)
	WHERE p.Enabled=1 AND p.Status IN('Active','Closed') AND p.CreateDate<DATEADD(DAY,1,@EndDate) AND SecondLevel NOT IN ('3','4')
	AND (@RegionCode IS NULL OR p.RegionCode=@RegionCode)
	AND (@DummyOrg IS NULL OR p.DummyOrg=@DummyOrg) 
	AND (@SalesOrgCode IS NULL OR p.SalesOrgCode=@SalesOrgCode) 	
	AND (@ITCode IS NULL OR EXISTS ( SELECT 1 FROM Sys_Employee_DataAuth AS d WITH(NOLOCK) WHERE d.IsReport=1 AND d.ITCode=@ITCode AND d.SalesOrgCode=p.DummyOrg ))
	--添加主键
	ALTER TABLE #pool_item_ag WITH NOCHECK ADD CONSTRAINT PK_rat_temp_pool_item_ag_poolItemID PRIMARY KEY CLUSTERED(PoolItemID);


	--==================================
	-- Not NA，非NA的Billing处理
	--==================================
	BEGIN

		DECLARE @increment_VersionDate_NotNA DATE=NULL;
		DECLARE @increment_TableName VARCHAR(255)=NULL;

		IF OBJECT_ID('tempdb..#notNA_diff_billing') IS NOT NULL  BEGIN
			   DROP TABLE #notNA_diff_billing
		END
		--由于sp_executesql执行动态脚本不能使用select..into #t方式，因此必须使用该方式创建临时表，该方式弊端：insert数据时，会产生日志文件
		CREATE TABLE #notNA_diff_billing(
			BillingNumber CHAR(10) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			BillingItemNumber CHAR(6) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			PolicyNum CHAR(10) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			PostingDate DATE NULL,
			End_AccrualValue MONEY NOT NULL,
			Begin_AccrualValue MONEY NOT NULL,
			Diff_AccrualValue MONEY NOT NULL,

			CompanyCurrency CHAR(3)  COLLATE Chinese_PRC_CI_AS NULL,
			PoolItemID INT NULL,
			SalesOrgCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
			SegmentCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL,
			ProfitCenterCode CHAR(10) COLLATE Chinese_PRC_CI_AS NULL,
			BusinessGroup CHAR(6)  COLLATE Chinese_PRC_CI_AS NULL,
			APCCode VARCHAR(1000)   COLLATE Chinese_PRC_CI_AS NULL,
			RegionCode VARCHAR(50)  COLLATE Chinese_PRC_CI_AS NULL
		)


		if(@FY=YEAR(GETDATE()) and @FiscalMonth=MONTH(GETDATE()))
		BEGIN
			PRINT 'NotNA当前月'
			insert into GTN_TASK_LOG_AG(LogDate,Tag,Detail) values(GETDATE(),'GTN_Report_AccountTemplate_AG','查询当月数据，截止日期变为今天'+convert(varchar(10),getdate(),23)+',需要模拟当前和昨天版,itcode:'+isnull(@ITCode,'null'));
		
			INSERT into #notNA_diff_billing(
				BillingNumber,		BillingItemNumber,	PolicyNum,			PostingDate,		End_AccrualValue,
				CompanyCurrency,	PoolItemID,			SalesOrgCode,		SegmentCode,		ProfitCenterCode,
				BusinessGroup,		APCCode,			RegionCode,			Begin_AccrualValue,	Diff_AccrualValue
			) 
			SELECT
				b.BillingNumber,	b.BillingItemNumber,	b.PolicyNum,		b.PostingDate,		ISNULL(b.CompanyCurrencyAccrualValue,0) AS 'End_AccrualValue',
				b.CompanyCurrency,	b.PoolItemID,			b.SalesOrgCode,		b.SegmentCode,		b.ProfitCenterCode,
				p.BusinessGroup,	p.APCCode,				b.RegionCode,		0,					ISNULL(b.CompanyCurrencyAccrualValue,0) AS 'Diff_AccrualValue'
			FROM GTN_Billing_AG AS b WITH(NOLOCK) INNER JOIN #pool_item_ag p ON b.PoolItemID=p.PoolItemID --WHERE b.PostingDate<DATEADD(day,1,GETDATE() 该条件始终为true
		
		END ELSE 
		BEGIN
			PRINT 'NotNA其他月'
			SET @increment_VersionDate_NotNA=@EndDate;
			SET @increment_TableName ='GTN_BillingByPoolHistory_AG_Increment_'+dbo.GTN_Fun_CalculateHistoryTableSuffix(@increment_VersionDate_NotNA);
		
			IF EXISTS(SELECT * FROM sysobjects WHERE id=OBJECT_ID(@increment_TableName) AND OBJECTPROPERTY(id,N'IsUserTable')=1)	
			BEGIN
				--注意：此处临时表的列名一定要和上述的相同，即要保证所有用到select..into #t的地方，#t的列名必须相同。
				SET @SQLStatement=N'
				SELECT
					b.BillingNumber,	b.BillingItemNumber,	b.PolicyNum,	b.PostingDate,	isnull(b.AccrualValue,0) as End_AccrualValue,
					b.CompanyCurrency,	b.PoolID as PoolItemID,	b.SalesOrgCode,	b.SegmentCode,	b.ProfitCenterCode,
					p.BusinessGroup,	p.APCCode,				b.RegionCode,	0 as Begin_AccrualValue,isnull(b.AccrualValue,0) as Diff_AccrualValue
				FROM
					(select max(VersionDate) as VersionDate	,BillingNumber,BillingItemNumber,PolicyNum,PoolID
						from '+@increment_TableName+' WITH(NOLOCK)
						where VersionDate<='''+convert(varchar(10),@increment_VersionDate_NotNA,120)+'''
						group by BillingNumber,BillingItemNumber,PolicyNum,PoolID
					) as t
				LEFT JOIN '+@increment_TableName+' as b WITH(NOLOCK)
				on t.BillingNumber=b.BillingNumber
				and t.BillingItemNumber=b.BillingItemNumber
				and t.PolicyNum=b.PolicyNum
				and t.PoolID=b.PoolID
				and t.VersionDate=b.VersionDate
				INNER JOIN #pool_item_ag p on b.PoolID=p.PoolItemID
				where b.IsDel=0 ';

				INSERT into #notNA_diff_billing(
					BillingNumber,		BillingItemNumber,	PolicyNum,			PostingDate,		End_AccrualValue,
					CompanyCurrency,	PoolItemID,			SalesOrgCode,		SegmentCode,		ProfitCenterCode,
					BusinessGroup,		APCCode,			RegionCode,			Begin_AccrualValue,	Diff_AccrualValue
				)	EXEC sp_executesql	@SQLStatement;	

			END
		END
		--PRINT '开始创建索引'
		--PRINT GETDATE()
		----添加唯一聚集索引
		--CREATE UNIQUE CLUSTERED INDEX IX_temp_notNA_end_billing  ON #notNA_diff_billing  (BillingNumber, BillingItemNumber,PolicyNum,PoolItemID);
		--PRINT GETDATE()
		--PRINT '索引创建结束'

		SET @increment_VersionDate_NotNA=dateadd(day,-1,@BeginDate);
		SET @increment_TableName='GTN_BillingByPoolHistory_AG_Increment_'+dbo.GTN_Fun_CalculateHistoryTableSuffix(@increment_VersionDate_NotNA)
	
		IF EXISTS(SELECT * FROM sysobjects WHERE id=object_id(@increment_TableName) and OBJECTPROPERTY(id,N'IsUserTable')=1)
		BEGIN 
			set @SQLStatement=N'
			;MERGE #notNA_diff_billing as e
			using(
				SELECT
					b.BillingNumber,	b.BillingItemNumber,		b.PolicyNum,	b.PostingDate,	isnull(b.AccrualValue,0) as Begin_AccrualValue,
					b.CompanyCurrency,	b.PoolID as PoolItemID,		b.SalesOrgCode,	b.SegmentCode,	b.ProfitCenterCode,
					p.BusinessGroup,	p.APCCode,					b.RegionCode
				FROM (
						select max(VersionDate) as VersionDate	,BillingNumber	,BillingItemNumber	,PolicyNum,PoolID
							from '+@increment_TableName+' WITH(NOLOCK)
							where VersionDate<='''+convert(varchar(10),@increment_VersionDate_NotNA,120)+'''
							group by BillingNumber,BillingItemNumber,PolicyNum,PoolID
					) as t
				left join '+@increment_TableName+' as b WITH(NOLOCK)
				on t.BillingNumber=b.BillingNumber
				and t.BillingItemNumber=b.BillingItemNumber
				and t.PolicyNum=b.PolicyNum
				and t.PoolID=b.PoolID
				and t.VersionDate=b.VersionDate
				INNER JOIN #pool_item_ag p on b.PoolID=p.PoolItemID
				where b.IsDel=0
			) as s
			ON e.BillingNumber=s.BillingNumber and e.BillingItemNumber=s.BillingItemNumber 
			and e.PolicyNum=s.PolicyNum and e.PoolItemID=s.PoolItemID
			WHEN MATCHED THEN 
				UPDATE SET e.Begin_AccrualValue = s.Begin_AccrualValue, e.Diff_AccrualValue=e.End_AccrualValue-s.Begin_AccrualValue
			WHEN NOT MATCHED THEN  
				INSERT	(
					BillingNumber,			BillingItemNumber,		PolicyNum,		PostingDate,		End_AccrualValue,
					CompanyCurrency,		PoolItemID,				SalesOrgCode,	SegmentCode,		ProfitCenterCode,
					Begin_AccrualValue,		Diff_AccrualValue,		BusinessGroup,	APCCode,			RegionCode
				) VALUES (
					s.BillingNumber,		s.BillingItemNumber,	s.PolicyNum,	s.PostingDate,		0,
					s.CompanyCurrency,		s.PoolItemID,			s.SalesOrgCode,	s.SegmentCode,		s.ProfitCenterCode,
					s.Begin_AccrualValue,	0-s.Begin_AccrualValue,	s.BusinessGroup,s.APCCode,			s.RegionCode
				);	';
			
			EXEC sp_executesql  @SQLStatement;

		END


	END



	--==================================
	-- NA，NA的Billing处理
	--==================================

	BEGIN

		DECLARE @increment_VersionDate_NA DATE=NULL;
		DECLARE @increment_S_TableName VARCHAR(255)=NULL;
		
		IF OBJECT_ID('tempdb..#NA_diff_billing') IS NOT NULL  BEGIN
           DROP TABLE #NA_diff_billing
		END
		CREATE TABLE #NA_diff_billing(
			BillingNumber VARCHAR(100) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			BillingItemNumber CHAR(6) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			BillingCategory CHAR(1)  COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			CompanyCode CHAR(4) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			FISCYEAR CHAR(4) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			MTMSOURCEID CHAR(10) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			GTNType VARCHAR(50) COLLATE Chinese_PRC_CI_AS NOT NULL DEFAULT '',
			FactorSource TINYINT NULL,

			PostingDate DATE,

			End_AccrualValue MONEY NOT NULL,
			Begin_AccrualValue MONEY NOT NULL,
			Diff_AccrualValue MONEY NOT NULL,

			CompanyCurrency CHAR(5) COLLATE Chinese_PRC_CI_AS NULL,
			PoolItemID INT NOT NULL,
			SalesOrgCode VARCHAR(50)  COLLATE Chinese_PRC_CI_AS NULL,
			SegmentCode VARCHAR(50)  COLLATE Chinese_PRC_CI_AS NULL,
			SegmentCode_3 VARCHAR(50)  COLLATE Chinese_PRC_CI_AS NULL,
			ProfitCenterCode CHAR(10) COLLATE Chinese_PRC_CI_AS NULL,
			BusinessGroup CHAR(6)  COLLATE Chinese_PRC_CI_AS NULL,
			APCCode VARCHAR(1000) COLLATE Chinese_PRC_CI_AS NULL,
			RegionCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NULL
		);
		DECLARE @MaxVersionDate DATE= dbo.GTN_Fun_GetAGBillingPoolHistroyDate('AG_BillingBW_S')
		if(@EndDate>=@MaxVersionDate)
		BEGIN 
			PRINT 'NA当月的'
			insert into GTN_TASK_LOG_AG(LogDate,Tag,Detail) values(GETDATE(),'GTN_Report_AccountTemplate_NA','查询当月数据，截止日期变为今天'+convert(varchar(10),getdate(),23)+',需要模拟当前和昨天版,itcode:'+isnull(@ITCode,'null'));
			
			INSERT INTO #NA_diff_billing
			(
				BillingNumber,		BillingItemNumber,	BillingCategory,	CompanyCode,	FISCYEAR,
				MTMSOURCEID,		GTNType,			FactorSource,		PostingDate	,	End_AccrualValue,
				CompanyCurrency,	PoolItemID,			SalesOrgCode,		SegmentCode,	SegmentCode_3,
				ProfitCenterCode,	BusinessGroup,		APCCode,			RegionCode,		
				Begin_AccrualValue,	Diff_AccrualValue
			)
			SELECT 
				b.BillingNumber,	b.BillingItemNumber,b.BillingCategory,	b.CompanyCode,	b.FISCYEAR,
				b.MTMSOURCEID,		b.GTNType,			b.FactorSource,		b.PostingDate,	b.GTNTypeCompanyCurrencyNetValue AS 'End_AccrualValue',
				b.CompanyCurrency,	b.PoolItemID,		b.SalesOrgCode,		b.SegmentCode,	b.SegmentCode_3,
				b.ProfitCenterCode,	p.BusinessGroup,	p.APCCode,			b.RegionCode,
				0 AS 'Begin_AccrualValue',	b.GTNTypeCompanyCurrencyNetValue AS 'Diff_AccrualValue'
			FROM GTN_Billing_NA AS b WITH(NOLOCK) INNER JOIN #pool_item_ag p ON p.PoolItemID=b.PoolItemID
			--WHERE b.PostingDate<DATEADD(DAY,1,getdate()) --该条件始终true	
 

		END ELSE
		BEGIN
			PRINT 'NA其他月'
			SET @increment_VersionDate_NA=DATEADD(DAY,1, @EndDate)
			SET @increment_S_TableName='GTN_BillingByPoolHistory_NA_Increment_'+dbo.GTN_Fun_CalculateHistoryTableSuffix(@increment_VersionDate_NA)+'_S'

			--准备数据
			IF EXISTS(SELECT * FROM sysobjects WHERE id=OBJECT_ID(@increment_S_TableName) AND OBJECTPROPERTY(id,N'IsUserTable')=1)		
			BEGIN
				SET @SQLStatement=N'
				SELECT 
					b.BillingNumber,	b.BillingItemNumber,		b.BillingCategory,	b.CompanyCode,	b.FISCYEAR,
					b.MTMSOURCEID,		b.GTNType,					b.FactorSource,		b.PostingDate,	isnull(b.AccrualValue,0) as End_AccrualValue,
					b.CompanyCurrency,	b.PoolID as PoolItemID,		b.SalesOrgCode,		b.SegmentCode,	b.SegmentCode_3,
					b.ProfitCenterCode,	p.BusinessGroup,			p.APCCode,			b.RegionCode,
					0 as Begin_AccrualValue,	isnull(b.AccrualValue,0) as Diff_AccrualValue
				FROM (
						select 
							BillingNumber,	BillingItemNumber,	BillingCategory,	CompanyCode,	FISCYEAR,
							MTMSOURCEID,	GTNType,			FactorSource,		PoolID,			SegmentCode_3,
							max(VersionDate) as VersionDate						
						from '+@increment_S_TableName+' WITH(NOLOCK)
						where VersionDate<='''+convert(varchar(10),@increment_VersionDate_NA,120)+'''
						group by BillingNumber,BillingItemNumber,BillingCategory,CompanyCode,FISCYEAR,MTMSOURCEID,GTNType,
						PoolID,SegmentCode_3,FactorSource
					) as t
				left join '+@increment_S_TableName+' as b WITH(NOLOCK)
				on t.BillingNumber=b.BillingNumber
				and t.BillingItemNumber=b.BillingItemNumber
				and t.BillingCategory=b.BillingCategory
				and t.CompanyCode=b.CompanyCode
				and t.FISCYEAR=b.FISCYEAR
				and t.MTMSOURCEID=b.MTMSOURCEID
				and t.GTNType=b.GTNType
				and t.PoolID=b.PoolID
				and t.SegmentCode_3=b.SegmentCode_3
				and t.FactorSource=b.FactorSource
				and t.VersionDate=b.VersionDate
				INNER join #pool_item_ag p on b.PoolID=p.PoolItemID
				where b.IsDel=0';
				--为了使索引更高效，上述的联查顺序尽量保证和多列索引的列顺序相同

				
				INSERT INTO #NA_diff_billing
				(
					BillingNumber,		BillingItemNumber,	BillingCategory,	CompanyCode,	FISCYEAR,
					MTMSOURCEID,		GTNType,			FactorSource,		PostingDate	,	End_AccrualValue,
					CompanyCurrency,	PoolItemID,			SalesOrgCode,		SegmentCode,	SegmentCode_3,
					ProfitCenterCode,	BusinessGroup,		APCCode,			RegionCode,
					Begin_AccrualValue,	Diff_AccrualValue
				)	EXEC sp_executesql 	@SQLStatement;
			END
		END

		--PRINT '开始创建索引'
		--PRINT GETDATE()
		----添加索引
		--CREATE UNIQUE CLUSTERED  INDEX IX_temp_NA_diff_billing  ON #NA_diff_billing  (
		--	BillingNumber,		BillingItemNumber,	BillingCategory,	CompanyCode,	FISCYEAR,
		--	MTMSOURCEID,		GTNType,			PoolItemID,			SegmentCode_3,	FactorSource
		--);
		--PRINT GETDATE()
		--PRINT '索引创建完成'

		
		SET @increment_VersionDate_NA=@BeginDate;
		SET @increment_S_TableName='GTN_BillingByPoolHistory_NA_Increment_'+dbo.GTN_Fun_CalculateHistoryTableSuffix(@increment_VersionDate_NA)+'_S'

		IF exists(select * from sysobjects where id=object_id(@increment_S_TableName) and OBJECTPROPERTY(id,N'IsUserTable')=1)
		BEGIN
			SET @SQLStatement=N'
			;MERGE #NA_diff_billing as e
			using(
				SELECT 
					b.BillingNumber,	b.BillingItemNumber,		b.BillingCategory,	b.CompanyCode,	b.FISCYEAR,
					b.MTMSOURCEID,		b.GTNType,					b.FactorSource,		b.PostingDate,	isnull(b.AccrualValue,0) as Begin_AccrualValue,
					b.CompanyCurrency,	b.PoolID as PoolItemID,		b.SalesOrgCode,		b.SegmentCode,	b.SegmentCode_3,
					b.ProfitCenterCode,	p.BusinessGroup,			p.APCCode,			b.RegionCode
				FROM (
						select 
							BillingNumber,	BillingItemNumber,	BillingCategory,	CompanyCode,	FISCYEAR,
							MTMSOURCEID,	GTNType,			FactorSource,		PoolID,			SegmentCode_3,
							max(VersionDate) as VersionDate	
						from '+@increment_S_TableName+' WITH(NOLOCK)
						where VersionDate<='''+convert(varchar(10),@increment_VersionDate_NA,120)+'''
						group by BillingNumber,BillingItemNumber,BillingCategory,CompanyCode,FISCYEAR,MTMSOURCEID,GTNType,
						PoolID,SegmentCode_3,FactorSource
					 ) as t
				left join '+@increment_S_TableName+' as b WITH(NOLOCK)
				on t.BillingNumber=b.BillingNumber
				and t.BillingItemNumber=b.BillingItemNumber
				and t.BillingCategory=b.BillingCategory
				and t.CompanyCode=b.CompanyCode
				and t.FISCYEAR=b.FISCYEAR
				and t.MTMSOURCEID=b.MTMSOURCEID
				and t.GTNType=b.GTNType
				and t.PoolID=b.PoolID
				and t.SegmentCode_3=b.SegmentCode_3
				and t.FactorSource=b.FactorSource
				and t.VersionDate=b.VersionDate
				INNER join #pool_item_ag p on b.PoolID=p.PoolItemID
				where b.IsDel=0
			) as s
			ON e.BillingNumber=s.BillingNumber and e.BillingItemNumber=s.BillingItemNumber and e.BillingCategory=s.BillingCategory
			and e.CompanyCode=s.CompanyCode and e.FISCYEAR=s.FISCYEAR  and e.MTMSOURCEID=s.MTMSOURCEID
			and e.GTNType=s.GTNType and e.PoolItemID=s.PoolItemID and e.SegmentCode_3=s.SegmentCode_3
			and e.FactorSource=s.FactorSource
			WHEN MATCHED THEN 
				UPDATE SET e.Begin_AccrualValue = s.Begin_AccrualValue, e.Diff_AccrualValue=e.End_AccrualValue-s.Begin_AccrualValue
			WHEN NOT MATCHED THEN  
				INSERT	(
					BillingNumber,		BillingItemNumber,		BillingCategory,	CompanyCode,	FISCYEAR,
					MTMSOURCEID,		GTNType,				FactorSource,		PostingDate	,	End_AccrualValue,
					CompanyCurrency,	PoolItemID,				SalesOrgCode,		SegmentCode,	SegmentCode_3,
					ProfitCenterCode,	BusinessGroup,			APCCode,			RegionCode,		
					Begin_AccrualValue,	Diff_AccrualValue
				) VALUES (
					s.BillingNumber,	s.BillingItemNumber,	s.BillingCategory,	s.CompanyCode,	s.FISCYEAR,
					s.MTMSOURCEID,		s.GTNType,				s.FactorSource,		s.PostingDate,	0,
					s.CompanyCurrency,	s.PoolItemID,			s.SalesOrgCode,		s.SegmentCode,	s.SegmentCode_3,
					s.ProfitCenterCode,	s.BusinessGroup,		s.APCCode,			s.RegionCode,
					s.Begin_AccrualValue,	0-s.Begin_AccrualValue
				);	';
			EXEC sp_executesql  @SQLStatement;
			
		END
    
		
	END



	--定义表变量
	DECLARE @t_Company TABLE(
		SalesOrgCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
		CompanyCode CHAR(6)  COLLATE Chinese_PRC_CI_AS NOT NULL,
		TaxCode VARCHAR(50)   COLLATE Chinese_PRC_CI_AS NOT NULL
	)
	INSERT INTO @t_Company
	(
	    SalesOrgCode,	    CompanyCode,	TaxCode
	)
	SELECT DISTINCT SalesOrgCode,	CompanyCode,	TaxCode FROM Base_SalesOrg_AG -- WHERE State='1';

	;MERGE @t_Company c USING(
		SELECT SalesOrgCode= 'HK10' UNION 
		SELECT 'TW10' UNION 
		SELECT 'KR10' UNION 
		SELECT 'SG10' UNION 
		SELECT 'SG90' UNION 
		SELECT 'MY10' UNION 
		SELECT 'TH10' UNION 
		SELECT 'AU10' UNION 
		SELECT 'NZ10' UNION 
		SELECT 'JP10' UNION 
		SELECT 'HK66'
	) AS b 
	ON c.SalesOrgCode=b.SalesOrgCode
	WHEN MATCHED THEN 
		UPDATE SET c.CompanyCode='HK13'
	WHEN NOT MATCHED THEN
		INSERT ( SalesOrgCode,CompanyCode,TaxCode)
		VALUES(b.SalesOrgCode,'HK13','');



	----定义segment数据源，将level=3的先写入
	--DECLARE @t_Segment TABLE(
	--	SegmentCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	--	MaterialCode VARCHAR(50) COLLATE Chinese_PRC_CI_AS NOT NULL,
	--	SegmentLevel CHAR(1)   COLLATE Chinese_PRC_CI_AS NOT NULL
	--)
	--INSERT INTO @t_Segment
	--(
	--    SegmentCode,	    MaterialCode,	    SegmentLevel
	--)
	--SELECT DISTINCT SegmentCode,MaterialCode ,'3' FROM Base_Segment_AG  WHERE State=1 and SegmentLevel='3';

	----找出level=1的，并且MaterialCode<>''的，插入并修改level=3的
	--;MERGE @t_Segment s USING(
	--	SELECT DISTINCT SegmentCode,MaterialCode FROM Base_Segment_AG WHERE State=1 AND SegmentLevel='1' AND MaterialCode<>''
	--) AS b 
	--ON s.SegmentCode=b.SegmentCode
	--WHEN MATCHED THEN 
	--	UPDATE SET s.MaterialCode=b.MaterialCode,s.SegmentLevel=1
	--WHEN NOT MATCHED THEN
	--	INSERT ( SegmentCode,	    MaterialCode,	    SegmentLevel)
	--	VALUES ( b.SegmentCode,		b.MaterialCode,		1);
	----找出level=2的，并且MaterialCode<>''的，插入并修改level=1或者3的，最终的优先级会是：2>1>3
	--;MERGE @t_Segment s USING(
	--	SELECT DISTINCT SegmentCode,MaterialCode FROM Base_Segment_AG WHERE State=1 AND SegmentLevel='2' AND MaterialCode<>''
	--) AS b 
	--ON s.SegmentCode=b.SegmentCode
	--WHEN MATCHED THEN 
	--	UPDATE SET s.MaterialCode=b.MaterialCode,s.SegmentLevel=2
	--WHEN NOT MATCHED THEN
	--	INSERT ( SegmentCode,	    MaterialCode,	    SegmentLevel)
	--	VALUES ( b.SegmentCode,		b.MaterialCode,		2);






	


	DECLARE @mm CHAR(3)=CASE MONTH(@BeginDate) 
		WHEN 1 THEN 'Jan'
		WHEN 2 THEN 'Feb'
		WHEN 3 THEN 'Mar'
		WHEN 4 THEN 'Apr'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'Jun'
		WHEN 7 THEN 'Jul'
		WHEN 8 THEN 'Aug'
		WHEN 9 THEN 'Sep'
		WHEN 10 THEN 'Oct'
		WHEN 11 THEN 'Nov'	
		WHEN 12 THEN 'Dec' END;


	

	;with t4050 as
	(
		select 40 as PostingKey,5010700 as [G/L Account]
		union
		select 50 as PostingKey,2316000 as [G/L Account]
	)
	,ab AS(
		SELECT RegionCode,SalesOrgCode,ProfitCenterCode,SegmentCode,'' AS SegmentCode_3, '' AS GTNType,CompanyCurrency as 'Currency',
				'' as MaterialNumber,MONTH(PostingDate) as 'M',	'Accrual By Order' as 'Type',
				CASE SegmentCode when 'SMB' then 1 when 'CON' then 2 else 3 end as 'Accounting Document Indicator',
				SUM(Diff_AccrualValue) as 'V',APCCode,BusinessGroup AS 'BGType'
		FROM #notNA_diff_billing WHERE Diff_AccrualValue<>0
		GROUP BY RegionCode,SalesOrgCode,ProfitCenterCode,SegmentCode,MONTH(PostingDate),CompanyCurrency,APCCode,BusinessGroup
		UNION ALL
		SELECT	RegionCode,SalesOrgCode,ProfitCenterCode,SegmentCode,SegmentCode_3,GTNType,CompanyCurrency as 'Currency',
				'' as MaterialNumber,MONTH(PostingDate) as 'M','Accrual By Order' as 'Type',
				CASE b.SegmentCode when 'SMB' then 1 when 'CON' then 2 else 3 end as 'Accounting Document Indicator',
				SUM(Diff_AccrualValue) as 'V',APCCode,BusinessGroup AS 'BGType'
		FROM #NA_diff_billing AS b WHERE Diff_AccrualValue<>0
		GROUP BY b.RegionCode,b.SalesOrgCode,b.ProfitCenterCode,b.SegmentCode,b.SegmentCode_3,MONTH(b.PostingDate),b.CompanyCurrency,b.GTNType,APCCode,b.BusinessGroup
	   	 
		UNION ALL
    
		SELECT head.RegionCode, head.SalesOrgCode,i.ProfitCenterCode,i.SegmentCode,'' AS SegmentCode_3,i.GTNTypeCode,head.CurrencyCode as 'Currency',
		i.MaterialNumber,MONTH(head.PostingDate) as 'M',CASE WHEN i.APCCode='9999' THEN 'Dummy Adjustment' ELSE 'Adjustment' END AS 'Type',
		case i.SegmentCode when 'SMB' then 4 when 'CON' then 5 else 6 end as 'Accounting Document Indicator',
		sum((case when i.InputOrOutput='input' then i.AdjustmentValue else -i.AdjustmentValue end)) as 'V',
		apc.GPNCode as APCCode,p.BusinessGroup AS 'BGType'
		from GTN_Adjustment_Item_AG i 
			left join GTN_Adjustment_AG head on head.AdjustmentID=i.AdjustmentID
			left join Base_APC_AG apc on apc.APCCode=i.MaterialNumber
			INNER join #pool_item_ag p on p.PoolItemID=i.PoolItemID
		where head.PostingDate>=@BeginDate and head.PostingDate<dateadd(day,1,@EndDate)
		and head.Enabled=1 and head.Status='Approved'
		group BY head.RegionCode,head.SalesOrgCode,i.ProfitCenterCode,i.SegmentCode,i.GTNTypeCode,MONTH(head.PostingDate),head.CurrencyCode
		,i.MaterialNumber,apc.GPNCode,p.BusinessGroup,CASE WHEN i.APCCode='9999' THEN 'Dummy Adjustment' ELSE 'Adjustment' END	 
	)
	,r_s AS
	(
	
		SELECT [_s].SegmentCode,[_s].MaterialCode ,[_s].ParentSegment,[_s].SegmentLevel FROM Base_Segment_AG _s 
		WHERE   [_s].State=1 and  [_s].SegmentLevel=3
	)
	,r_s_1 AS
	(
		SELECT [_s].SegmentCode,[_s].MaterialCode ,[_s].ParentSegment,[_s].SegmentLevel FROM Base_Segment_AG _s 
		WHERE   [_s].State=1 and  [_s].SegmentLevel=1
	),
	r_s_2 AS
	(
		SELECT [_s].SegmentCode,[_s].MaterialCode ,[_s].ParentSegment,[_s].SegmentLevel FROM Base_Segment_AG _s 
		WHERE   [_s].State=1 and  [_s].SegmentLevel=2
	)
	SELECT DISTINCT
	ab.[Accounting Document Indicator]
	,'' as 'Acct type'
	,@EndDate as 'Document Date'
	,@EndDate as 'Posting Date'	
	,'SA'as 'Document Type'
	,c.CompanyCode AS 'Company Code'
	,ab.SegmentCode as 'Reference'	
	,@mm + '-' + right(year(@BeginDate),2) + ' ' + c.CompanyCode + ' FBA' as 'Doc.Header Text'
	,Currency
	,'' as 'Exchange Rate'
	,t4050.PostingKey as 'Posting Key'
	,t4050.[G/L Account]
	,'' 'Special G/L Indicator'
	,'' 'Asset transaction type'
	, CAST(ROUND(ab.V,2) AS DECIMAL(18,2)) as 'Amount In Document Currency'  --显示两位小数
	,'' 'Amount'
	,c.TaxCode as 'Tax Code'
	,'' as 'Tax base amount'
	,'' as 'Business Area'	
	,'' as 'Cost Center'
	,ab.ProfitCenterCode as 'Profit Center'
	,'' 'Internal Order'
	,'' as 'Sale Order'
	,'' as 'Sale Order Item'
	,'' 'WBS element'
	,'' 'Network'
	,'' 'Cost object'
	,'' as 'Quantity'
	,ab.Type as 'Assignment'
	,ab.GTNType+' '+@mm + '-' + right(year(@BeginDate),2) + ' FBA' as 'Text'
	,'' as 'Baseline Payment Date'
	,'' 'Terms of Payment'
	,'' 'Tax Jurisdiction'
    ,CASE WHEN ab.BGType='MBG' THEN '' WHEN ab.BGType='DCG' AND ab.Type = 'Accrual By Order' THEN ''
	 ELSE (
		CASE WHEN isnull(ab.MaterialNumber,'')=''
        THEN CASE WHEN  isnull( r_s_2.MaterialCode,'')<>'' THEN r_s_2.MaterialCode   
	         WHEN  isnull( r_s_1.MaterialCode,'')<>''   THEN r_s_1.MaterialCode
		     WHEN ISNULL( r_s.MaterialCode,'')<>''   THEN r_s.MaterialCode   
 		     ELSE '' END   
         ELSE   ab.MaterialNumber  END 
	) END AS 'Material'
	,'' as 'Unit'
	,'' as 'Trading Partner'
	,'' 'lagacy account'
	,'' 'PARTNER PC'	
	,ab.BGType
	FROM ab
	LEFT JOIN @t_Company AS c ON c.SalesOrgCode = ab.SalesOrgCode
	LEFT join r_s on r_s.SegmentCode=ab.SegmentCode_3
	LEFT join r_s_1 on r_s_1.SegmentCode=ab.SegmentCode
	left join r_s_2 on r_s_2.SegmentCode=ab.SegmentCode
	left join t4050 on 1=1	
	ORDER by ab.[Accounting Document Indicator]
		

END