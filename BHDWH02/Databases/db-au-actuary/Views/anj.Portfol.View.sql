USE [db-au-actuary]
GO
/****** Object:  View [anj].[Portfol]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [anj].[Portfol] AS

WITH 
[WorkStatus_01] AS (
    SELECT
         w.[Country]
        ,w.[ClaimKey]
        ,we.[EventName]
		,w.StatusName as LatestStatus
		,w.CompletionDate
        --If event date is Sunday or Saturday, make it Monday
        ,CASE WHEN DATEPART(weekday,CAST(we.[EventDate] as date)) = 1 THEN DATEADD(day,1,CAST(we.[EventDate] as date))
              WHEN DATEPART(weekday,CAST(we.[EventDate] as date)) = 7 THEN DATEADD(day,2,CAST(we.[EventDate] as date))
                                                                      ELSE CAST(we.[EventDate] as date) 
         END AS [EventDate]
      --,CAST(we.[EventDate] as date) AS [EventDate]
        ,we.[StatusName]
        ,1 AS [Count]
        ,ROW_NUMBER() OVER (PARTITION BY w.[ClaimKey],CAST(we.[EventDate] as date) ORDER BY we.[EventDate] desc) AS [EndOfDay]

    FROM      [uldwh02].[db-au-cmdwh].[dbo].[e5WorkEvent] we WITH (NOLOCK) 
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[e5Work]      w  WITH (NOLOCK) ON w.[Work_ID]  = we.[Work_ID]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[clmClaim]    c  WITH (NOLOCK) ON c.[ClaimKey] =  w.[ClaimKey]
    WHERE  w.[WorkType] IN ('Claim','New Claim')
	      
        AND we.[EventName]  = 'Changed Work Status'
        AND c.[CreateDate] >= '2022-01-01'
        --AND c.[ClaimKey] IN ('AU-1498040')
    --ORDER BY we.[EventDate]
)

,[WorkStatus_02] AS (
    SELECT 
         *
        ,ROW_NUMBER() OVER (PARTITION BY [ClaimKey] ORDER BY [EventDate] ASC) AS [First]
        ,ROW_NUMBER() OVER (PARTITION BY [ClaimKey] ORDER BY [EventDate] DESC) AS [Last]
    FROM [WorkStatus_01]
    WHERE [EndOfDay] = 1
),
[WorkStatus_03] AS (
    SELECT
         a.*
        ,CASE WHEN a.[StatusName] IN ('Active','Diarised') AND a.[LatestStatus] <> 'Complete' AND a.[Last] = 1 THEN GETDATE()
              WHEN a.[StatusName] IN ('Complete','Rejected')                THEN NULL
			  --WHEN a.[LatestStatus] IN ('Complete')							THEN b.CompletionDate
                                                                            ELSE b.[EventDate]
         END AS [NextEventDate]
    FROM      [WorkStatus_02] a 
    LEFT JOIN [WorkStatus_02] b ON a.[ClaimKey] = b.[ClaimKey] AND a.[First] = b.[First]-1
),

[WorkStatus_04] AS (
    SELECT 
         [Country]
        ,[ClaimKey]
        ,[EventName]
		,LatestStatus
		,CompletionDate
        ,[EventDate]
        ,[NextEventDate]
        ,[StatusName]
        ,[Count]
        ,[EndOfDay]
        ,[First]
        ,[Last]
        ,[EventDate] AS [Day]


    FROM [WorkStatus_03] 

    UNION ALL

    SELECT 
         [Country]
        ,[ClaimKey]
        ,[EventName]
		,LatestStatus
		,CompletionDate
        ,[EventDate]
        ,[NextEventDate]
        ,[StatusName]
        ,[Count]
        ,[EndOfDay]
        ,[First]
        ,[Last]
        --If Friday or Saturday then next day is Monday.
        ,CASE WHEN DATEPART(weekday,[Day]) = 6 THEN DATEADD(day,3,[Day])
              WHEN DATEPART(weekday,[Day]) = 7 THEN DATEADD(day,2,[Day])
                                               ELSE DATEADD(day,1,[Day]) 
         END AS [Day]
    FROM [WorkStatus_04]
    WHERE (CASE WHEN DATEPART(weekday,[Day]) = 6 THEN DATEADD(day,3,[Day])
                WHEN DATEPART(weekday,[Day]) = 7 THEN DATEADD(day,2,[Day])
                                                 ELSE DATEADD(day,1,[Day]) 
           END ) < [NextEventDate] 
      AND DATEDIFF(day,[EventDate],[NextEventDate]) <= 100
      AND [NextEventDate] IS NOT NULL
),

[WorkStatus_05] AS (
    SELECT 
         *
       ,SUM([Count]) OVER (PARTITION BY [ClaimKey], [EventDate]  ORDER BY [Day]) AS [DayCount]

    FROM [WorkStatus_04]
)


SELECT 
     [Country]
	 ,[ClaimKey]
	 ,LatestStatus
	,CompletionDate
    ,[Day]
    ,[StatusName]
    ,[DayCount]
    ,SUM([Count]) AS [Count]
FROM [WorkStatus_05]
--where Country = 'AU' --and [Day] >= '2021-09-01'
GROUP BY 
     [Country]
	 ,[ClaimKey]
	 ,LatestStatus
		,CompletionDate
    ,[Day]
    ,[StatusName]
    ,[DayCount]

;



GO
