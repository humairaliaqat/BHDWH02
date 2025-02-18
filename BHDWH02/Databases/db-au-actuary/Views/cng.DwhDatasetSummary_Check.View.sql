USE [db-au-actuary]
GO
/****** Object:  View [cng].[DwhDatasetSummary_Check]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[DwhDatasetSummary_Check] AS 

WITH 
dwhdataset_old AS (SELECT * FROM [db-au-actuary].[ws].[DWHDataSetSummary20240401]),
dwhdataset_new AS (SELECT * FROM [db-au-actuary].[ws].[DWHDataSetSummary]),
Summary AS (
    SELECT 
        'Domain Country' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Domain Country] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Domain Country]) AS new
    FULL JOIN (SELECT [Domain Country] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Domain Country]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Company' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Company] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Company]) AS new
    FULL JOIN (SELECT [Company] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Company]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Issue Date' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT CONVERT(varchar,CAST([Issue Date] AS date),10) AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY CAST([Issue Date] AS date)) AS new
    FULL JOIN (SELECT CONVERT(varchar,CAST([Issue Date] AS date),10) AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY CAST([Issue Date] AS date)) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Destination' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Destination] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Destination]) AS new
    FULL JOIN (SELECT [Destination] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Destination]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Product Code' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Product Code] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Product Code]) AS new
    FULL JOIN (SELECT [Product Code] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Product Code]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Product Group' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Product Group] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Product Group]) AS new
    FULL JOIN (SELECT [Product Group] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Product Group]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Policy Type' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Policy Type] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Policy Type]) AS new
    FULL JOIN (SELECT [Policy Type] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Policy Type]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Plan Type' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Plan Type] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Plan Type]) AS new
    FULL JOIN (SELECT [Plan Type] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Plan Type]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Trip Type' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Trip Type] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Trip Type]) AS new
    FULL JOIN (SELECT [Trip Type] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Trip Type]) AS old ON new.[Value] = old.[Value]
UNION ALL
    SELECT 
        'Product Classification' AS [Column]
        ,COALESCE(new.[Value],old.[Value]) AS [Value]
        ,COALESCE([New],0) AS [New]
        ,COALESCE([Old],0) AS [Old]
        , COALESCE([New],0)-COALESCE([Old],0) AS [Diff]
        ,(COALESCE([New],0)-COALESCE([Old],0))*1.00/COALESCE([New],0.01) AS [Diff%]
    FROM      (SELECT [Product Classification] AS [Value],COUNT(*) AS [New] FROM dwhdataset_new GROUP BY [Product Classification]) AS new
    FULL JOIN (SELECT [Product Classification] AS [Value],COUNT(*) AS [Old] FROM dwhdataset_old GROUP BY [Product Classification]) AS old ON new.[Value] = old.[Value]
)

SELECT TOP 1000000 *
FROM Summary
WHERE [Diff%]>0.1 OR [Diff%]<0 OR [Value] IS NULL OR [Value] = ''
ORDER BY [Column],[Value]
;
GO
