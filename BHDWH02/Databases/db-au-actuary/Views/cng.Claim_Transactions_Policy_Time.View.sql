USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Transactions_Policy_Time]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Transactions_Policy_Time] AS

WITH 
ctrn AS (
    SELECT * FROM [db-au-actuary].[cng].[Claim_Transactions_Table]
),

phdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]
),

ctrn_01 AS (
    SELECT
         [ClaimKey]
        ,a.[PolicyKey]
        ,[DomainCountry]
        ,[JV]
        ,[Trip Type] AS [TripType]
        ,[Plan Type] AS [PlanType]
        ,[CATCode]
        ,[ActuarialBenefitGroup]
        ,[Size100k]

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
     
        ,DATEPART(year ,[IncurredDate])         AS [IncurredYear]
        ,DATEPART(month,[IncurredDate])         AS [IncurredMonth]
        ,[IncurredDate]                         AS [IncurredDate]

        ,CASE WHEN DATEDIFF(DAY,[IssueDate],[IncurredDate]) + 1 > 0
              THEN DATEDIFF(DAY,[IssueDate],[IncurredDate]) + 1
              ELSE 0
         END AS [DaysToIncurred]
        ,CASE 
            WHEN [IncurredDate] < [IssueDate]               THEN 0
            WHEN [IncurredDate] < CAST([TripStart] AS date) THEN ROUND(CAST((DATEDIFF(DAY,[IssueDate],[IncurredDate])) AS float)/NULLIF(DATEDIFF(DAY,[IssueDate],[TripStart]),0) * 0.5      ,2)
            WHEN [IncurredDate] < CAST([TripEnd]   AS date) THEN ROUND(CAST((DATEDIFF(DAY,[TripStart],[IncurredDate])) AS float)/NULLIF(DATEDIFF(DAY,[TripStart],[TripEnd]  ),0) * 0.5 + 0.5,2)
            WHEN [IncurredDate] >=CAST([TripEnd]   AS date) THEN ROUND(CAST((DATEDIFF(DAY,[TripEnd]  ,[IncurredDate])) AS float)/100 + 1.0,2)
         END AS [DaysToIncurred%Rescale]

        ,a.[SectionCount]
        ,a.[NetPaymentMovementIncRecoveries]
        ,a.[NetIncurredMovementIncRecoveries]
        ,CEILING(a.[NetIncurredMovementIncRecoveries]/100) AS [Weight]

    FROM      ctrn a
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
    ,[Size100k]

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

    ,[IncurredYear]
    ,[IncurredMonth]
    ,[IncurredDate]

    ,[DaysToIncurred]
    ,ROUND(ISNULL(CAST([DaysToIncurred] AS float)/NULLIF([LeadTime] + [TripDuration],0),1),2) AS [DaysToIncurred%]
    ,[DaysToIncurred%Rescale]

    ,[SectionCount]
    ,[NetPaymentMovementIncRecoveries]
    ,[NetIncurredMovementIncRecoveries]
    ,[Weight]
FROM ctrn_01
;
GO
