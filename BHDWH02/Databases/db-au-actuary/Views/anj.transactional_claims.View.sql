USE [db-au-actuary]
GO
/****** Object:  View [anj].[transactional_claims]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [anj].[transactional_claims] AS

WITH 
[Calendar] AS (
    SELECT 
         c.[Date]
        ,c.[isHoliday]
        ,c.[isWeekDay]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[Calendar] c
    WHERE c.[Date] >= '2016-01-01'
),

[WorkStatus_01] AS (
    SELECT
         w.[Country]
        ,w.[ClaimKey]
        ,w.[WorkType]
        ,we.[EventName]
        ,we.[StatusName]
        ,w.[StatusName] as [e5_StatusName]
        ,we.[EventDate]
       ,c.CreateDate
        ,c.ReceivedDate
        ,we.[EventUser]
        ,cl.AgencySuperGroupName
        ,cl.AreaType
        ,w.CompletionDate
        ,ROW_NUMBER() OVER (PARTITION BY w.[ClaimKey], CAST(we.[EventDate] AS date) ORDER BY we.[EventDate] DESC) AS [EndOfDay]
FROM      [uldwh02].[db-au-cmdwh].[dbo].[e5WorkEvent] we WITH (NOLOCK) 
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[e5Work]      w  WITH (NOLOCK) ON w.[Work_ID]  = we.[Work_ID]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[clmClaim]    c  WITH (NOLOCK) ON c.[ClaimKey] =  w.[ClaimKey]
              LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[clmClaimSummary]    cl  WITH (NOLOCK) ON cl.[ClaimKey] =  w.[ClaimKey]

    WHERE w.[WorkType] IN ('Claim', 'New Claim')
        AND (we.[EventName] IN ('Changed Work Status') 
             OR we.[EventName] IN ('Saved Work') 
             OR (we.[EventName] IN ('Closed Work', 'Child Completed') AND we.[StatusName] = 'Complete'))
        AND NOT (we.[EventDate] >= '2015-10-03' AND we.[EventDate] < '2015-10-04' AND we.EventUser IN ('Dataract e5 Exchange Service', 'e5 Launch Service'))
        AND c.[CreateDate] >= '2019-01-01'
),

[WorkStatus_02] AS (
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
        ,CASE 
            WHEN a.[StatusName] IN ('Active', 'Diarised') AND a.[Last] = 1 THEN GETDATE()
            WHEN a.[StatusName] IN ('Complete', 'Rejected') THEN NULL
            ELSE b.[EventDate]
         END AS [NextEventDate]
        ,CASE 
            WHEN a.StatusName IN ('Active', 'Diarised') 
                 AND a.e5_StatusName = 'Complete' 
                 AND CAST(a.EventDate AS Date) >= CAST(a.CompletionDate AS Date) THEN 'Stop'
            ELSE 'Take the Value'
         END AS [Flag]
    FROM [WorkStatus_02] a 
    LEFT JOIN [WorkStatus_02] b ON a.[ClaimKey] = b.[ClaimKey] AND a.[First] = b.[First] - 1
),
 Dataract_e5_Exchange_Service AS (
    SELECT 
        a.*,
        cal.[Date] AS [Day],
        ROW_NUMBER() OVER (PARTITION BY a.[ClaimKey], a.[StatusName], a.[EventDate] ORDER BY cal.[Date]) AS [DayCount],
        LAG(a.[StatusName]) OVER (PARTITION BY a.[ClaimKey] ORDER BY cal.[Date]) AS PreviousStatus,
        1 AS [Count],
        -- Track EventUser changes
        LAG(a.[EventUser]) OVER (PARTITION BY a.[ClaimKey] ORDER BY cal.[Date]) AS PreviousEventUser
    FROM [WorkStatus_03] a
    OUTER APPLY (
        SELECT * 
        FROM [Calendar] cal 
        WHERE CAST(cal.[Date] AS date) >= CAST(a.[EventDate] AS date) 
            AND CAST(cal.[Date] AS date) < COALESCE(CAST(a.[NextEventDate] AS date), CAST(DATEADD(day, 1, a.[EventDate]) AS date))
    ) cal
    WHERE cal.[isWeekDay] = 1 
        AND cal.[isHoliday] <> 1
),
WorkStatus_06 AS (
    SELECT 
        *,
        CASE 
            -- If StatusName is 'Active' and PreviousStatus is also 'Active', increment the day count
            WHEN [StatusName] = 'Active' AND PreviousStatus = 'Active' THEN [DayCount] + 1
            -- If StatusName is 'Diarised', keep the DayCount
            WHEN [StatusName] = 'Diarised' THEN [DayCount]
            -- Reset the day count to 1 for other statuses
            ELSE 1
        END AS [FinalDayCount],
        -- Logic to reset status count when EventUser changes
        CASE 
            WHEN PreviousEventUser IS NOT NULL AND a.[EventUser] <> PreviousEventUser THEN 1  -- Reset count if EventUser changes
            ELSE
                CASE 
                    WHEN [StatusName] = 'Active' AND PreviousStatus = 'Active' THEN [DayCount] + 1
                    WHEN [StatusName] = 'Diarised' THEN [DayCount]
                    ELSE 1
                END
        END AS [FinalDayCountWithEventUserChange]
    FROM Dataract_e5_Exchange_Service a
)

SELECT 
     [Country]
    ,[ClaimKey]
    ,[WorkType]
    ,[EventDate]
    ,[NextEventDate]
    ,CAST([Day] AS date) AS [Date]
    ,CreateDate
    ,ReceivedDate
    ,[StatusName]
    ,[e5_StatusName]
    ,[DayCount]
    ,AgencySuperGroupName
    ,AreaType
    ,[EventUser]
    ,CompletionDate
    ,[Flag]
    ,SUM([Count]) AS [Count]
FROM [WorkStatus_06]
WHERE e5_StatusName IN ('Active', 'Diarised', 'Complete')
    --AND [ClaimKey] ='AU-1646268' --''
GROUP BY 
     [Country]
    ,[ClaimKey]
    ,[WorkType]
    ,[EventDate]
    ,[NextEventDate]
    ,[Day]
    ,CreateDate
    ,ReceivedDate
    ,[StatusName]
    ,[e5_StatusName]
    ,[DayCount]
    ,AgencySuperGroupName
    ,AreaType
    ,[EventUser]
    ,CompletionDate
    ,[Flag]


GO
