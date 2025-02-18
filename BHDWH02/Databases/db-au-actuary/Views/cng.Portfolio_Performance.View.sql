USE [db-au-actuary]
GO
/****** Object:  View [cng].[Portfolio_Performance]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Portfolio_Performance] AS

SELECT TOP 10000000
    --Dimensions
     [Domain Country]
    ,[JV Description]
    ,EOMONTH([Issue Date])                      AS [Issue Month]

    --Policy Counts
    ,COUNT(*)                                   AS [Policy Count]
    ,SUM(IIF([Policy Status]= 'Active',1,0))    AS [Policy Count - Active]
    ,SUM(IIF([Policy Status]<>'Active',1,0))    AS [Policy Count - Cancelled]

    --Premium
    ,SUM([Sell Price])                          AS [Sell Price]
    ,SUM([Premium])                             AS [Premium]
    ,SUM([Agency Commission])                   AS [Commission]
    ,SUM([UW Premium]+[UW Premium COVID19])     AS [UW Premium]
    ,SUM([Premium]) - 
     SUM([Agency Commission]) - 
     SUM([UW Premium]+[UW Premium COVID19])     AS [CM Expenses]

    --Claims
    ,SUM([ClaimCount])                          AS [Claim Count]
    ,SUM([SectionCount])                        AS [Section Count]
    ,SUM([NetIncurredMovementIncRecoveries])    AS [Incurred]
    ,SUM([NetPaymentMovementIncRecoveries])     AS [Payments]

    --Measures
    ,SUM([ClaimCount])   * 1.00              / SUM(IIF([Policy Status]='Active',1,0))   AS [Claim Frequency]
    ,SUM([SectionCount]) * 1.00              / SUM(IIF([Policy Status]='Active',1,0))   AS [Section Frequency]
    ,SUM([NetIncurredMovementIncRecoveries]) / SUM([ClaimCount])                        AS [Average Claim Size]
    ,SUM([NetIncurredMovementIncRecoveries]) / SUM([SectionCount])                      AS [Average Section Size]

    ,SUM([NetIncurredMovementIncRecoveries]) / SUM(IIF([Policy Status]='Active',1,0))   AS [Cost Per Policy]
    ,SUM([UW Premium]+[UW Premium COVID19])  / SUM(IIF([Policy Status]='Active',1,0))   AS [Average UW Premium]
    ,SUM([Premium])                          / SUM(IIF([Policy Status]='Active',1,0))   AS [Average Premium]

    ,SUM([NetIncurredMovementIncRecoveries]) / SUM([Premium])                           AS [Loss Ratio]
    ,SUM([UW Premium]+[UW Premium COVID19])  / SUM([Premium])                           AS [UW Prem Ratio]
    ,SUM([NetIncurredMovementIncRecoveries]) / SUM([UW Premium]+[UW Premium COVID19])   AS [UW Loss Ratio]

FROM [db-au-actuary].[cng].[Policy_Header_Works_Table] -- 1 row per policy

WHERE [Issue Date] >= '2017-06-01'

GROUP BY 
     [Domain Country]
    ,[JV Description]
    ,EOMONTH([Issue Date])

ORDER BY 
     [Domain Country]
    ,[JV Description]
    ,EOMONTH([Issue Date])
;
GO
