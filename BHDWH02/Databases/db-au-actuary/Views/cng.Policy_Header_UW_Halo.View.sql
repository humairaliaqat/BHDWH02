USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_UW_Halo]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_UW_Halo] AS 

WITH 
Policy_Header_01 AS (
    SELECT *
    FROM [db-au-actuary].[cng].[Policy_Header_UW]
    WHERE [UW Rating Group] = 'Halo'
),

UW_Factors AS (
    SELECT *
    FROM [db-au-actuary].[cng].[UW_Factors]
),

--Risk Premium
Policy_Header_02 AS (
    SELECT 
         hdr.*
        ,b.[Loading] AS [Risk Premium 2017]

    FROM Policy_Header_01 hdr
    LEFT JOIN UW_Factors b ON b.[Factor] = 'Halo' AND b.[Level] = CAST(hdr.[UW Issue Year] as varchar)+'Q'+CAST(hdr.[UW Issue Quarter] AS varchar)+' '+hdr.[Trip Type]
),

--UW Premium
Policy_Header_03 AS (
    SELECT 
         hdr.*
        ,cat.[Loading] AS [CAT Loading]
        ,tlr.[Loading] AS [TLR]
        ,[Risk Premium 2017] * cat.[Loading] / tlr.[Loading] AS [UW Premium 2017]

    FROM Policy_Header_02 hdr
    LEFT JOIN UW_Factors  cat ON cat.[Factor] = 'CAT' AND cat.[Level] = hdr.[UW Issue Year]
    LEFT JOIN UW_Factors  tlr ON tlr.[Factor] = 'TLR' AND tlr.[Level] = hdr.[UW Issue Year]
),

Policy_Header_04 AS (
    SELECT 
         hdr.*
        ,CASE 
            WHEN [UW Policy Status] = 'Active' THEN [UW Premium 2017]
            ELSE 0
         END AS [UW Premium]

    FROM Policy_Header_03 hdr
)

SELECT * 
FROM Policy_Header_04
;
GO
