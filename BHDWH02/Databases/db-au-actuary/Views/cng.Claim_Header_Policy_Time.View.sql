USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Header_Policy_Time]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Header_Policy_Time] AS

WITH 
chdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Claim_Header_Table]
),

phdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]
),

chdr_01 AS (
    SELECT
         [ClaimKey]
        ,a.[PolicyKey]
        ,[DomainCountry]
        ,[JV]
        ,[Trip Type] AS [TripType]
        ,[Plan Type] AS [PlanType]
        ,[CATCode]
        ,[ActuarialBenefitGroup]
        ,[Size50k]

        ,DATEPART(year     ,[IssueDate])    AS [IssueYear]
        ,DATEPART(quarter  ,[IssueDate])    AS [IssueQuarter]
        ,DATEPART(month    ,[IssueDate])    AS [IssueMonth]
        ,DATEPART(week     ,[IssueDate])    AS [IssueWeek]
        ,DATEPART(dayofyear,[IssueDate])    AS [IssueDayOfYear]
        ,DATEPART(day      ,[IssueDate])    AS [IssueDayOfMonth]
        ,DATEPART(weekday  ,[IssueDate])    AS [IssueDayOfWeek]
        ,[IssueDate]                        AS [IssueDate]

        ,DATEPART(year     ,[TripStart])    AS [DepartureYear]
        ,DATEPART(quarter  ,[TripStart])    AS [DepartureQuarter]
        ,DATEPART(month    ,[TripStart])    AS [DepartureMonth]
        ,DATEPART(week     ,[TripStart])    AS [DepartureWeek]
        ,DATEPART(dayofyear,[TripStart])    AS [DepartureDayOfYear]
        ,DATEPART(day      ,[TripStart])    AS [DepartureDayOfMonth]
        ,DATEPART(weekday  ,[TripStart])    AS [DepartureDayOfWeek]
        ,CAST([TripStart] as date)          AS [DepartureDate]

        ,DATEPART(year     ,[TripEnd])      AS [ReturnYear]
        ,DATEPART(quarter  ,[TripEnd])      AS [ReturnQuarter]
        ,DATEPART(month    ,[TripEnd])      AS [ReturnMonth]
        ,DATEPART(week     ,[TripEnd])      AS [ReturnWeek]
        ,DATEPART(dayofyear,[TripEnd])      AS [ReturnDayOfYear]
        ,DATEPART(day      ,[TripEnd])      AS [ReturnDayOfMonth]
        ,DATEPART(weekday  ,[TripEnd])      AS [ReturnDayOfWeek]
        ,CAST([TripEnd] as date)            AS [ReturnDate]

        ,CASE WHEN DATEDIFF(DAY,[IssueDate],[TripStart]) > 0
              THEN DATEDIFF(DAY,[IssueDate],[TripStart])
              ELSE 0
         END AS [LeadTime]
        ,CASE WHEN DATEDIFF(DAY,[TripStart],[TripEnd]) + 1 > 0
              THEN DATEDIFF(DAY,[TripStart],[TripEnd]) + 1
              ELSE 0
         END AS [TripDuration]
     
        ,DATEPART(year ,[LossDate])         AS [LossYear]
        ,DATEPART(month,[LossDate])         AS [LossMonth]
        ,[LossDate]                         AS [LossDate]

        ,CASE WHEN DATEDIFF(DAY,[IssueDate],[LossDate]) + 1 > 0
              THEN DATEDIFF(DAY,[IssueDate],[LossDate]) + 1
              ELSE 0
         END AS [DaysToLoss]
        ,CASE 
            WHEN [LossDate] < [IssueDate]               THEN 0
            WHEN [LossDate] < CAST([TripStart] AS date) THEN ROUND(CAST((DATEDIFF(DAY,[IssueDate],[LossDate])) AS float)/NULLIF(DATEDIFF(DAY,[IssueDate],[TripStart]),0) * 0.5      ,2)
            WHEN [LossDate] < CAST([TripEnd]   AS date) THEN ROUND(CAST((DATEDIFF(DAY,[TripStart],[LossDate])) AS float)/NULLIF(DATEDIFF(DAY,[TripStart],[TripEnd]  ),0) * 0.5 + 0.5,2)
                                                        ELSE 1
         END AS [DaysToLoss%Rescale]

        ,a.[SectionCount]
        ,a.[NetIncurredMovementIncRecoveries]
        ,CEILING(a.[NetIncurredMovementIncRecoveries]/100) AS [Weight]

    FROM      chdr a
    LEFT JOIN phdr b ON a.[PolicyKey] = b.[PolicyKey] AND a.[ProductCode] = b.[Product Code]
)

SELECT 
     [ClaimKey]
    ,[PolicyKey]
    ,[DomainCountry]
    ,[JV]
    ,[TripType]
    ,[PlanType]
    ,[CATCode]
    ,[ActuarialBenefitGroup]
    ,[Size50k]

    ,[IssueYear]
    ,[IssueQuarter]
    ,[IssueMonth]
    ,[IssueWeek]
    ,[IssueDayOfYear]
    ,[IssueDayOfMonth]
    ,[IssueDayOfWeek]
    ,[IssueDate]

    ,[DepartureYear]
    ,[DepartureQuarter]
    ,[DepartureMonth]
    ,[DepartureWeek]
    ,[DepartureDayOfYear]
    ,[DepartureDayOfMonth]
    ,[DepartureDayOfWeek]
    ,[DepartureDate]

    ,[ReturnYear]
    ,[ReturnQuarter]
    ,[ReturnMonth]
    ,[ReturnWeek]
    ,[ReturnDayOfYear]
    ,[ReturnDayOfMonth]
    ,[ReturnDayOfWeek]
    ,[ReturnDate]

    ,[LeadTime]
    ,[TripDuration]
    ,[LeadTime] + [TripDuration] AS [PolicyDuration]
    ,ROUND(ISNULL(CAST([LeadTime]     AS float)/NULLIF([LeadTime] + [TripDuration],0),0),2) AS [LeadTime%]
    ,ROUND(ISNULL(CAST([TripDuration] AS float)/NULLIF([LeadTime] + [TripDuration],0),1),2) AS [TripDuration%]

    ,[LossYear]
    ,[LossMonth]
    ,[LossDate]

    ,[DaysToLoss]
    ,ROUND(ISNULL(CAST([DaysToLoss]   AS float)/NULLIF([LeadTime] + [TripDuration],0),1),2) AS [DaysToLoss%]
    ,[DaysToLoss%Rescale]

    ,[SectionCount]
    ,[NetIncurredMovementIncRecoveries]
    ,[Weight]
FROM chdr_01
;
GO
