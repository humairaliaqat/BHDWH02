USE [db-au-actuary]
GO
/****** Object:  View [cng].[UW_Premiums]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [cng].[UW_Premiums] AS
WITH
UWPremium_201805_Final AS (
    SELECT 
         [PolicyKey]
        ,[Previous_Policy_Status] AS [UW_Policy_Status]
        ,[Previous_UW_Premium]    AS [UW_Premium]
        ,NULL                     AS [Previous_Policy_Status]
        ,0                        AS [Previous_UW_Premium]
        ,[Previous_UW_Premium]    AS [Movement]
        ,[Domain_Country]
        ,[Issue_Mth]
        ,[Rating_Group]
        ,[JV_Description_Orig]
        ,[JV_Group]
        ,[Product_Code]
        ,[UW_Premium_COVID19]
        ,0                        AS [Previous_UW_Premium_COVID19]
        ,[UW_Premium_COVID19]     AS [Movement_COVID19]
    FROM [db-au-actuary].[cng].[UWPremium_201806_Final]
    WHERE [Previous_Policy_Status] IS NOT NULL
),

UWPremium AS (
    SELECT EOMONTH(CAST('2018-05-01' AS date),0) AS 'UW_Month',a.* FROM                       [UWPremium_201805_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201806_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201807_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201808_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201809_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201810_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201811_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2018-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201812_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201901_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201902_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201903_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201904_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201905_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201906_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201907_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201908_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201909_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201910_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201911_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2019-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_201912_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202001_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202002_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202003_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202004_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202005_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202006_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202007_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202008_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202009_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202010_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202011_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2020-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202012_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202101_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202102_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202103_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202104_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202105_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202106_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202107_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202108_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202109_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202110_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202111_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2021-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202112_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202201_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202202_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202203_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202204_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202205_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202206_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202207_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202208_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202209_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202210_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202211_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2022-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202212_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202301_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202302_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202303_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202304_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2023-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202305_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2023-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202306_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2023-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202307_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2023-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202308_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2023-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202309_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202310_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202311_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
    SELECT EOMONTH(CAST('2023-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202312_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-01-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202401_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-02-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202402_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-03-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202403_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-04-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202404_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-05-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202405_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-06-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202406_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-07-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202407_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-08-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202408_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-09-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202409_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-10-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202410_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-11-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202411_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) UNION ALL
	SELECT EOMONTH(CAST('2024-12-01' AS date),0) AS 'UW_Month',a.* FROM [db-au-actuary].[cng].[UWPremium_202412_Final] a WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL)
)

SELECT
     RANK() OVER (PARTITION BY a.[PolicyKey],a.[Product_Code] ORDER BY a.[UW_Month] DESC,(COALESCE(a.[UW_Premium],0)+COALESCE(a.[UW_Premium_COVID19],0))) AS [Rank]
    ,a.[UW_Month]
    ,a.[PolicyKey]
    ,IIF(a.[UW_Policy_Status] IN ('Cancel','Cancelled'),'Cancelled 100',a.[UW_Policy_Status]) AS [UW_Policy_Status]
    ,COALESCE(a.[UW_Premium],0)                  AS [UW_Premium]
    ,COALESCE(a.[UW_Premium_COVID19],0)          AS [UW_Premium_COVID19]
    ,a.[Previous_Policy_Status]
    ,COALESCE(a.[Previous_UW_Premium],0)         AS [Previous_UW_Premium]
    ,COALESCE(a.[Previous_UW_Premium_COVID19],0) AS [Previous_UW_Premium_COVID19]
    ,COALESCE(a.[Movement],0)                    AS [Movement]
    ,COALESCE(a.[Movement_COVID19],0)            AS [Movement_COVID19]
    ,SUM(a.[Movement])         OVER (PARTITION BY a.[PolicyKey],a.[Product_Code] ORDER BY a.[UW_Month],(COALESCE(a.[UW_Premium],0)+COALESCE(a.[UW_Premium_COVID19],0)) DESC) AS [Total_Movement]
    ,SUM(a.[Movement_COVID19]) OVER (PARTITION BY a.[PolicyKey],a.[Product_Code] ORDER BY a.[UW_Month],(COALESCE(a.[UW_Premium],0)+COALESCE(a.[UW_Premium_COVID19],0)) DESC) AS [Total_Movement_COVID19]
    ,a.[Domain_Country]
    ,a.[Issue_Mth]
    ,a.[Rating_Group]
    ,IIF(a.[JV_Description_Orig] = 'CBA White Label','CBA WL',a.[JV_Description_Orig]) AS [JV_Description_Orig]
    ,a.[JV_Group]
    ,a.[Product_Code]
FROM UWPremium a
WHERE (COALESCE(a.[Movement],0) <> 0 OR COALESCE(a.[Movement_COVID19],0) <> 0 OR a.[Previous_Policy_Status] IS NULL) 
;
GO
