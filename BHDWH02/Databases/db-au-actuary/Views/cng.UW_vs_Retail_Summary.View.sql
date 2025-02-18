USE [db-au-actuary]
GO
/****** Object:  View [cng].[UW_vs_Retail_Summary]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[UW_vs_Retail_Summary] AS 

SELECT TOP 1000000000
     [Domain Country]
    ,[Product Code]
    ,[JV]
    ,[UW Rating Group]
    ,[Issue Month]
    ,[Transaction Month]
    ,[Cancelled Month]
    ,[Departure Month]
    ,[Departure >17Sep20]
    ,[Departure >17Dec20]
    ,[Policy Status]
    ,[UW Policy Status]
    ,SUM([Premium])                     AS [Premium]
    ,SUM([Premium +])                   AS [Premium +]
    ,SUM([Premium -])                   AS [Premium -]
    ,SUM([Premium Top Up Refund])       AS [Premium Top Up Refund]
    ,SUM([Sell Price])                  AS [Sell Price]
    ,SUM([Sell Price +])                AS [Sell Price +]
    ,SUM([Sell Price -])                AS [Sell Price -]
    ,SUM([Sell Price Top Up Refund])    AS [Sell Price Top Up Refund]
    ,SUM([UW Movement])                 AS [UW Movement]
    ,SUM([UW Movement +])               AS [UW Movement +]
    ,SUM([UW Movement -])               AS [UW Movement -]
FROM [db-au-actuary].[cng].[UW_vs_Retail]
WHERE 
    [UW Rating Group] IS NOT NULL AND 
    [Transaction Month] >= '2018-06-01'
GROUP BY
     [Domain Country]
    ,[Product Code]
    ,[JV]
    ,[UW Rating Group]
    ,[Issue Month]
    ,[Transaction Month]
    ,[Cancelled Month]
    ,[Departure Month]
    ,[Departure >17Sep20]
    ,[Departure >17Dec20]
    ,[Policy Status]
    ,[UW Policy Status]
ORDER BY
     [Domain Country]
    ,[Product Code]
    ,[JV]
    ,[UW Rating Group]
    ,[Issue Month]
    ,[Transaction Month]
    ,[Cancelled Month]
    ,[Departure Month]
    ,[Departure >17Sep20]
    ,[Departure >17Dec20]
    ,[Policy Status]
    ,[UW Policy Status]
;
GO
