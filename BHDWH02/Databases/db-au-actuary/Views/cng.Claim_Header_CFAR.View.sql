USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Header_CFAR]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Header_CFAR] AS 

WITH 
chdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Claim_Header_Table]
),

phdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]
),

cfar_e5 AS (
    SELECT [ClaimNumber]
    FROM [db-au-actuary].[cng].[e5WorkCaseNote]
    WHERE LOWER([CaseNote]) LIKE '%cfar%'       OR 
          LOWER([CaseNote]) LIKE '%any reason%' OR 
          LOWER([CaseNote]) LIKE '%75[%]%'
    GROUP BY [ClaimNumber]
),

cfar_claims AS (
    SELECT 
         a.*
        ,c.[ClaimNumber] AS [ClaimNumber_e5]
        ,CASE WHEN a.[PerilCode] IN ('PHI','PHJ' )                  THEN 0
              WHEN a.[PerilCode] IN ('CFR'       )                  THEN 1 
              WHEN a.[CATCode]   IN ('COR','COR1')                  THEN 1
              WHEN LOWER(a.[EventDescription]) LIKE '%cfar%'        THEN 1
              WHEN LOWER(a.[EventDescription]) LIKE '%any reason%'  THEN 1
              WHEN c.[ClaimNumber] IS NOT NULL                      THEN 1
                                                                    ELSE 0
         END AS CFARClaimFlag
    FROM      chdr    a
    LEFT JOIN phdr    b ON a.[PolicyKey] = b.[PolicyKey] AND a.[ProductCode] = b.[Product Code]
    LEFT JOIN cfar_e5 c ON a.[ClaimNo] = c.[ClaimNumber]
    WHERE a.[ActuarialBenefitGroup] = 'Cancellation' AND (b.[Addon Count Cancel For Any Reason] > 0 OR b.[Gross Premium Cancel For Any Reason] > 0)
)

SELECT *
FROM cfar_claims
;
GO
