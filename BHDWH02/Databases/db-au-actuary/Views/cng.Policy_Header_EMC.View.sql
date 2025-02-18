USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_EMC]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_EMC] AS 

WITH 
Policy_Header AS (
    SELECT 
         *
        ,(SELECT MAX(v) 
          FROM (VALUES (CASE WHEN [Charged Traveller 1 Has EMC]  > 0 THEN [Charged Traveller 1 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 2 Has EMC]  > 0 THEN [Charged Traveller 2 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 3 Has EMC]  > 0 THEN [Charged Traveller 3 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 4 Has EMC]  > 0 THEN [Charged Traveller 4 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 5 Has EMC]  > 0 THEN [Charged Traveller 5 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 6 Has EMC]  > 0 THEN [Charged Traveller 6 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 7 Has EMC]  > 0 THEN [Charged Traveller 7 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 8 Has EMC]  > 0 THEN [Charged Traveller 8 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 9 Has EMC]  > 0 THEN [Charged Traveller 9 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 10 Has EMC] > 0 THEN [Charged Traveller 10 DOB] ELSE NULL END)
               ) AS value(v)
         ) AS [Youngest EMC DOB]
        ,(SELECT MIN(v) 
          FROM (VALUES (CASE WHEN [Charged Traveller 1 Has EMC]  > 0 THEN [Charged Traveller 1 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 2 Has EMC]  > 0 THEN [Charged Traveller 2 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 3 Has EMC]  > 0 THEN [Charged Traveller 3 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 4 Has EMC]  > 0 THEN [Charged Traveller 4 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 5 Has EMC]  > 0 THEN [Charged Traveller 5 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 6 Has EMC]  > 0 THEN [Charged Traveller 6 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 7 Has EMC]  > 0 THEN [Charged Traveller 7 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 8 Has EMC]  > 0 THEN [Charged Traveller 8 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 9 Has EMC]  > 0 THEN [Charged Traveller 9 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 10 Has EMC] > 0 THEN [Charged Traveller 10 DOB] ELSE NULL END)
               ) AS value(v)
         ) AS [Oldest EMC DOB]
    FROM [db-au-actuary].[cng].[Policy_Header]
)

SELECT 
     *
    ,CASE WHEN [Issue Date] IS NULL OR [Youngest EMC DOB] IS NULL THEN -1
          ELSE FLOOR((DATEDIFF(MONTH,[Youngest EMC DOB],[Issue Date]) - CASE WHEN DATEPART(DAY,[Issue Date]) < DATEPART(DAY,[Youngest EMC DOB]) THEN 1 ELSE 0 END) / 12 )
     END [Youngest EMC Age]
    ,CASE WHEN [Issue Date] IS NULL OR [Oldest EMC DOB] IS NULL THEN -1
          ELSE FLOOR((DATEDIFF(MONTH,[Oldest EMC DOB],[Issue Date]) - CASE WHEN DATEPART(DAY,[Issue Date]) < DATEPART(DAY,[Oldest EMC DOB]) THEN 1 ELSE 0 END) / 12 )
     END [Oldest EMC Age]
FROM Policy_Header
;
GO
