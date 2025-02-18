USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_xgboost]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [cng].[Policy_Header_xgboost] AS 

WITH 
chdr AS (
SELECT
     [PolicyKey]
    ,[ProductCode]
    ,[ClaimCount]
    ,[SectionCount]
    ,[NetPaymentMovementIncRecoveries]
    ,[NetIncurredMovementIncRecoveries]
    ,CASE
        --WHEN [CATCode]     IN ('COR','COR1') AND [IssueDate] >= '2020-12-01' AND [IssueDate] <= '2023-06-30'                THEN 'COV'
        WHEN [CATCode] NOT IN ('COR','COR1','CAT','CO1','MHC',' ')                                                          THEN 'CAT'
        --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Underlying'                                   THEN 'CFR'
        --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Large'                                        THEN 'CFR_LGE'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Underlying'                                   THEN 'ADD'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Large'                                        THEN 'ADD_LGE'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Underlying' AND [LossDate]<=[DepartureDate]   THEN 'PRE_CAN'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Large'      AND [LossDate]<=[DepartureDate]   THEN 'PRE_CAN_LGE'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Underlying' AND [LossDate]> [DepartureDate]   THEN 'ON_CAN'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Large'      AND [LossDate]> [DepartureDate]   THEN 'ON_CAN_LGE'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Underlying'                                   THEN 'LUG'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Large'                                        THEN 'LUG_LGE'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Underlying'                                   THEN 'MED'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Large'                                        THEN 'MED_LGE'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Underlying'                                   THEN 'OTH'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Large'                                        THEN 'OTH_LGE'
                                                                                                                            ELSE 'OTH'
     END AS [Section]
FROM [db-au-actuary].[cng].[Claim_Header_Table]
),

claims AS (
    SELECT 
         [PolicyKey]        AS [PolicyKey]
        ,[ProductCode]      AS [Product Code]

		,SUM([ClaimCount]                      ) AS [ClaimCount]
		,SUM([SectionCount]                    ) AS [SectionCount]
		,SUM([NetPaymentMovementIncRecoveries] ) AS [NetPaymentMovementIncRecoveries]
		,SUM([NetIncurredMovementIncRecoveries]) AS [NetIncurredMovementIncRecoveries]

		,SUM(CASE WHEN [Section] = 'MED'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections MED]
		,SUM(CASE WHEN [Section] = 'MED'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED]
		,SUM(CASE WHEN [Section] = 'MED'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED]
		,SUM(CASE WHEN [Section] = 'MED_LGE'                        THEN [SectionCount]                     ELSE 0 END) AS [Sections MED_LGE]
		,SUM(CASE WHEN [Section] = 'MED_LGE'                        THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED_LGE]
		,SUM(CASE WHEN [Section] = 'MED_LGE'                        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED_LGE]

		,SUM(CASE WHEN [Section] IN ('PRE_CAN'    ,'ON_CAN'    )    THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN]
		,SUM(CASE WHEN [Section] IN ('PRE_CAN'    ,'ON_CAN'    )    THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN]
		,SUM(CASE WHEN [Section] IN ('PRE_CAN'    ,'ON_CAN'    )    THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN]
		,SUM(CASE WHEN [Section] IN ('PRE_CAN_LGE','ON_CAN_LGE')    THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN_LGE]
		,SUM(CASE WHEN [Section] IN ('PRE_CAN_LGE','ON_CAN_LGE')    THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN_LGE]
		,SUM(CASE WHEN [Section] IN ('PRE_CAN_LGE','ON_CAN_LGE')    THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN_LGE]

		,SUM(CASE WHEN [Section] = 'PRE_CAN'                        THEN [SectionCount]                     ELSE 0 END) AS [Sections PRE_CAN]
		,SUM(CASE WHEN [Section] = 'PRE_CAN'                        THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments PRE_CAN]
		,SUM(CASE WHEN [Section] = 'PRE_CAN'                        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred PRE_CAN]
		,SUM(CASE WHEN [Section] = 'PRE_CAN_LGE'                    THEN [SectionCount]                     ELSE 0 END) AS [Sections PRE_CAN_LGE]
		,SUM(CASE WHEN [Section] = 'PRE_CAN_LGE'                    THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments PRE_CAN_LGE]
		,SUM(CASE WHEN [Section] = 'PRE_CAN_LGE'                    THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred PRE_CAN_LGE]

		,SUM(CASE WHEN [Section] = 'ON_CAN'                         THEN [SectionCount]                     ELSE 0 END) AS [Sections ON_CAN]
		,SUM(CASE WHEN [Section] = 'ON_CAN'                         THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ON_CAN]
		,SUM(CASE WHEN [Section] = 'ON_CAN'                         THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ON_CAN]
		,SUM(CASE WHEN [Section] = 'ON_CAN_LGE'                     THEN [SectionCount]                     ELSE 0 END) AS [Sections ON_CAN_LGE]
		,SUM(CASE WHEN [Section] = 'ON_CAN_LGE'                     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ON_CAN_LGE]
		,SUM(CASE WHEN [Section] = 'ON_CAN_LGE'                     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ON_CAN_LGE]

		,SUM(CASE WHEN [Section] = 'ADD'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD]
		,SUM(CASE WHEN [Section] = 'ADD'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD]
		,SUM(CASE WHEN [Section] = 'ADD'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD]
		,SUM(CASE WHEN [Section] = 'ADD_LGE'                        THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD_LGE]
		,SUM(CASE WHEN [Section] = 'ADD_LGE'                        THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD_LGE]
		,SUM(CASE WHEN [Section] = 'ADD_LGE'                        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD_LGE]

		,SUM(CASE WHEN [Section] IN ('LUG'    ,'OTH'    )           THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS]
		,SUM(CASE WHEN [Section] IN ('LUG'    ,'OTH'    )           THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS]
		,SUM(CASE WHEN [Section] IN ('LUG'    ,'OTH'    )           THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS]
		,SUM(CASE WHEN [Section] IN ('LUG_LGE','OTH_LGE')           THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS_LGE]
		,SUM(CASE WHEN [Section] IN ('LUG_LGE','OTH_LGE')           THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS_LGE]
		,SUM(CASE WHEN [Section] IN ('LUG_LGE','OTH_LGE')           THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS_LGE]

		,SUM(CASE WHEN [Section] = 'LUG'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections LUG]
		,SUM(CASE WHEN [Section] = 'LUG'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments LUG]
		,SUM(CASE WHEN [Section] = 'LUG'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred LUG]
		,SUM(CASE WHEN [Section] = 'LUG_LGE'                        THEN [SectionCount]                     ELSE 0 END) AS [Sections LUG_LGE]
		,SUM(CASE WHEN [Section] = 'LUG_LGE'                        THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments LUG_LGE]
		,SUM(CASE WHEN [Section] = 'LUG_LGE'                        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred LUG_LGE]

		,SUM(CASE WHEN [Section] = 'OTH'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections OTH]
		,SUM(CASE WHEN [Section] = 'OTH'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments OTH]
		,SUM(CASE WHEN [Section] = 'OTH'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred OTH]
		,SUM(CASE WHEN [Section] = 'OTH_LGE'                        THEN [SectionCount]                     ELSE 0 END) AS [Sections OTH_LGE]
		,SUM(CASE WHEN [Section] = 'OTH_LGE'                        THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments OTH_LGE]
		,SUM(CASE WHEN [Section] = 'OTH_LGE'                        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred OTH_LGE]

		,SUM(CASE WHEN [Section] = 'CAT'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections CAT]
		,SUM(CASE WHEN [Section] = 'CAT'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAT]
		,SUM(CASE WHEN [Section] = 'CAT'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAT]

		,SUM(CASE WHEN [Section] = 'COV'                            THEN [SectionCount]                     ELSE 0 END) AS [Sections COV]
		,SUM(CASE WHEN [Section] = 'COV'                            THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments COV]
		,SUM(CASE WHEN [Section] = 'COV'                            THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred COV]

    FROM chdr
    GROUP BY [PolicyKey],[ProductCode]
)

SELECT 
    --a.[BIRowID]
     a.[Domain Country]
    --,a.[Company]
    ,a.[PolicyKey]
    ,a.[Base Policy No]
    --,a.[Policy Status]

    ,a.[Issue Date]
    ,FORMAT(a.[Issue Date],'yyyyMM')  AS [Issue Year-Month]
    ,DATEPART(mm,a.[Issue Date])      AS [Issue Month]
    ,DATEPART(qq,a.[Issue Date])      AS [Issue Quarter]
    ,DATEPART(yy,a.[Issue Date])      AS [Issue Year]

    --,a.[Posting Date]
    --,a.[Last Transaction Issue Date]
    --,a.[Last Transaction Posting Date]
    --,a.[Transaction Type]

    ,a.[Departure Date]
    ,FORMAT(a.[Departure Date],'yyyyMM') AS [Departure Year-Month]
    ,DATEPART(mm,a.[Departure Date])     AS [Departure Month]
    ,DATEPART(qq,a.[Departure Date])     AS [Departure Quarter]
    ,DATEPART(yy,a.[Departure Date])     AS [Departure Year]

    ,a.[Return Date]
    ,FORMAT(a.[Return Date],'yyyyMM')    AS [Return Year-Month]
    ,DATEPART(mm,a.[Return Date])        AS [Return Month]
    ,DATEPART(qq,a.[Return Date])        AS [Return Quarter]
    ,DATEPART(yy,a.[Return Date])        AS [Return Year]

    ,a.[Lead Time]
    ,a.[Trip Duration]
    --,a.[Trip Length]
    ,a.[Maximum Trip Length]

    ,a.[Destination]
    ,CASE WHEN a.[Domain Country] = 'AU' AND a.[Plan Type] = 'Domestic' THEN 'Australia - Domestic'
          WHEN a.[Domain Country] = 'NZ' AND a.[Plan Type] = 'Domestic' THEN 'New Zealand - Domestic'
          WHEN d.[GLM_Region_2024] IS NULL THEN 'World'
          ELSE d.[GLM_Region_2024]
     END AS [GLM_Region_2024]
    --,b.[MultiDestination]
    ,IIF(CHARINDEX(';',b.[MultiDestination])>0,'Y','N') AS [MultiDestinationFlag]
    --,a.[Area Name]
    --,a.[Area Number]
    --,a.[Country or Area]
    --,a.[Intermediate Region Name]
    --,a.[Region Name]

    ,a.[Excess]
    ,a.[Trip Cost]
    --,a.[Group Policy]
    --,a.[Has Rental Car]
    --,a.[Has Motorcycle]
    --,a.[Has Wintersport]
    --,a.[Has Medical]

    ,a.[Single/Family]
    ,a.[Purchase Path]
    --,a.[TRIPS Policy]

    ,a.[Product Code]
    --,a.[Plan Code]
    --,a.[Product Name]
    ,a.[Product Plan]
    --,a.[Product Type]
    --,a.[Product Group]
    ,a.[Policy Type]
    ,a.[Plan Type]
    ,a.[Trip Type]
    ,a.[Product Classification]
    --,a.[Finance Product Code]
    --,a.[OutletKey]
    --,a.[Alpha Code]
	,CASE WHEN
		a.[Outlet Channel] = 'Integrated'
		THEN 'Integrated'
	WHEN
		a.[Product Code] in ('STY', 'FCO', 'CMB', 'FCT', 'FCC', 'BJW', 'ABW', 'GTS', 'CMY') OR /*Flight Centre*/
		a.[Product Code] in ('CMB', 'GTS', 'CMW') OR /*Direct*/
		a.[Product Code] in ('NCC', 'CMB', 'CMT', 'CHH', 'GTS', 'GMC', 'PNO', 'VTI') OR /*HW, Indies*/
		a.[Product Code] in ('API', 'APP') OR /*Auspost*/
		a.[Product Code] in ('VDC', 'AWT', 'VAS', 'VBC', 'VTC', 'VAI', 'VTI') OR /*Virgin*/
		a.[Product Code] in ('FRB', 'F4B', 'F2B') OR /*Freely*/
		a.[Product Code] in ('ANC', 'ANF','AIN','AIW') OR /*Air New Zealand*/
		a.[Product Code] in ('HIF') OR /*HIF*/
		a.[Product Code] in ('MOT') OR /*QACC*/
		a.[Product Code] in ('CMY') OR /*YouGo*/
		a.[Product Code] in ('CTI') OR /*Coles*/
		a.[Product Code] in ('MHA') OR /*Malaysia Airlines*/
		a.[Product Code] in ('CMY') OR /*YouGo*/
		/*****New Zealand******/
		a.[Product Code] in ('NZC', 'CMU','TMC') OR /*Flight Centre*/
		a.[Product Code] in ('IAG') OR /*IAG*/
		(a.[Domain Country] = 'NZ' and a.[Product Code] in ('ANI','ANF','ANB','AND','ANK','ANV','AIW')) OR /*Air New Zealand*/
		a.[Product Code] in ('CAL', 'CNB') OR /*Direct*/
		a.[Product Code] in ('PNO', 'GTS', 'CMU') OR /*HW, Indies*/
		a.[Product Code] in ('WTP') OR /*WestPac*/
		a.[Product Code] in ('VNS') /*Virgin*/
		THEN 'Single tier'
	WHEN
		(a.[Plan Type] = 'Domestic' and a.[Product Plan] like '%DA-ST%') or
		a.[Product Code] in ('FYE','NPG','FPG','SYE') or   /*Flight Centre*/
		(a.[Product Code] in ('DII') and a.[Product Plan] like '%IB%') OR /*DII product*/
		(a.[Product Code] in ('CMH') and a.[Product Plan] like '%Medical%') or  /*old Direct*/
		a.[Product Code] in ('CBI') or   /*new Direct*/
		a.[Product Code] in ('MBM', 'MNM') or  /*Medibank*/
		(a.[Product Code] in ('AHM') and a.[Product Plan] like '%Med%') or  /*AHM*/
		a.[Product Code] in ('IEC', 'HBC', 'BCR', 'DTS', 'CBP')  or  /*HW, Indies*/
		a.[Product Code] in ('APB') or  /*Auspost*/
		(a.[Product Code] in ('NTI', 'NRI', 'IAL') and a.[Product Plan] like '%Essn%') or  /*NRMA*/
		(a.[Product Code] in ('CBT') and (a.[Product Plan] like '%ST-Med%' or a.[Product Plan] like '%Canx%')) or  /*CBA WL*/
		(a.[Product Code] in ('VAW', 'AIR', 'AIO') and a.[Product Plan] like '%Ess%') or  /*Virgin*/
		a.[Product Code] in ('WJS') OR /*Webjet*/
		(a.[Domain Country] = 'AU' and a.[Product Code] in ('ANB')) OR /*Air New Zealand*/
		a.[Product Code] in ('MTE') OR /*Kogan*/
		a.[Product Code] in ('BDB') OR /*Budget Direct*/
		/*****New Zealand******/
		a.[Product Code] in ('ETI', 'NZE') or  /*Main products*/
		a.[Product Code] in ('WJS') or  /*Webjet*/
		(a.[Product Code] in ('VNW') and a.[Product Plan] like '%Ess%') /*Virgin*/
		THEN 'Basic Essentials'
	 WHEN
		a.[Product Code] in ('FYP','NPP','FPP','SYC') or /*Flight Centre*/
		a.[Product Code] in ('DII') or
		a.[Product Code] in ('CMH') or /*old Direct*/
		a.[Product Code] in ('ICC','HCC','DTP','CCP') or /*HW, Indies*/
		a.[Product Code] in ('MBC', 'MNC') or /*Medibank*/
		a.[Product Code] in ('APC') or /*Auspost*/
		a.[Product Code] in ('NTI', 'NRI', 'IAL') or  /*NRMA*/
		a.[Product Code] in ('AHM') or  /*AHM*/
		a.[Product Code] in ('VAW', 'AIR', 'AIO') or  /*Virgin*/
		a.[Product Code] in ('WJP') or  /*Webjet*/
		a.[Product Code] in ('MTP') or  /*Kogan*/
		/*****New Zealand******/
		a.[Product Code] in ('YTI', 'NZO') or  /*Main products*/
		a.[Product Code] in ('WJP') or  /*Webjet*/
		a.[Product Code] in ('VNW')  /*Virgin*/
		THEN 'Top - 2 tiers'
	WHEN
		(a.[Product Code] in ('CPC') and a.[Product Plan] NOT like '%Comp+%') or  /*new Direct*/
		a.[Product Code] in ('CCR') or /*HW, Indies*/
		(a.[Product Code] in ('CBT') and a.[Product Plan] like '%Ess%') or  /*CBA WL*/
		(a.[Product Code] in ('BDC') and a.[Product Plan] like '%Ess%') /*Budget Direct*/
		THEN 'Mid - 3 tiers'
	WHEN
		(a.[Product Code] in ('CPC') and a.[Product Plan] like '%Comp+%') or  /*new Direct*/
		a.[Product Code] in ('PCR') or /*HW, Indies*/
		a.[Product Code] in ('CBT') or /*CBA WL*/
		a.[Product Code] in ('BDC') /*Budget Direct*/
		THEN 'Top - 3 tiers'
	ELSE 'z. error'
	END AS [Plan Tier grouped]

	,CASE WHEN [Return Date]  BETWEEN '2019-01-01' AND '2019-12-31'
		THEN '2019'
	ELSE '2022/23'
	END AS [Period]

    --,a.[Customer Post Code]
    ,a.[Customer State]

    --,a.[Unique Traveller Count]
    --,a.[Unique Charged Traveller Count]
    ,a.[Traveller Count]
    ,a.[Charged Traveller Count]
    ,a.[Adult Traveller Count]
    
    --,a.[Youngest Charged DOB]
    --,a.[Oldest Charged DOB]
    --,a.[Youngest Age]
    --,a.[Oldest Age]
    --,a.[Youngest Charged Age]
    ,a.[Oldest Charged Age]

    ,a.[EMC Traveller Count]
    --,a.[Max EMC Score]
    --,a.[Total EMC Score]
    --Highest EMC Score
    ,(SELECT COALESCE(MAX(v),0)
        FROM (VALUES ([Charged Traveller 1 EMC Score]),
                    ([Charged Traveller 2 EMC Score]),
                    ([Charged Traveller 3 EMC Score]),
                    ([Charged Traveller 4 EMC Score]),
                    ([Charged Traveller 5 EMC Score]),
                    ([Charged Traveller 6 EMC Score]),
                    ([Charged Traveller 7 EMC Score]),
                    ([Charged Traveller 8 EMC Score]),
                    ([Charged Traveller 9 EMC Score]),
                    ([Charged Traveller 10 EMC Score])
            ) AS value(v)
        ) AS [Highest EMC Score]
    ,a.[Has EMC]
    ,a.[Has Manual EMC]
    --,CAST(
    -- CASE WHEN CAST([Issue Date] as date) >='2020-06-09' 
    --      THEN IIF(ROUND([Highest EMC Score]                    ,0)>8, 8, CAST(ROUND([Highest EMC Score]                    ,0) as int))
    --      ELSE IIF(ROUND([Highest EMC Score]/[UW EMC Multiplier],0)>8, 8, CAST(ROUND([Highest EMC Score]/[UW EMC Multiplier],0) as int))
    -- END as varchar) 
    -- +
    -- IIF([EMC Traveller Count]*1.00/IIF([Charged Traveller Count]=0,[Traveller Count],[Charged Traveller Count])>0.5,'_>50%','_<50%') AS [UW EMC Band]

    --,a.[Gender]

    ,DATEDIFF(YEAR,a.[Charged Traveller 1 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 1 DOB],a.[Issue Date]), a.[Charged Traveller 1 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 1 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 2 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 2 DOB],a.[Issue Date]), a.[Charged Traveller 2 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 2 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 3 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 3 DOB],a.[Issue Date]), a.[Charged Traveller 3 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 3 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 4 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 4 DOB],a.[Issue Date]), a.[Charged Traveller 4 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 4 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 5 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 5 DOB],a.[Issue Date]), a.[Charged Traveller 5 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 5 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 6 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 6 DOB],a.[Issue Date]), a.[Charged Traveller 6 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 6 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 7 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 7 DOB],a.[Issue Date]), a.[Charged Traveller 7 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 7 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 8 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 8 DOB],a.[Issue Date]), a.[Charged Traveller 8 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 8 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 9 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 9 DOB],a.[Issue Date]), a.[Charged Traveller 9 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 9 Age]
    ,DATEDIFF(YEAR,a.[Charged Traveller 10 DOB],a.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,a.[Charged Traveller 10 DOB],a.[Issue Date]), a.[Charged Traveller 10 DOB]) > a.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 10 Age]

    --,a.[Charged Traveller 1 Gender]
    --,a.[Charged Traveller 1 DOB]
    --,a.[Charged Traveller 1 Has EMC]
    --,a.[Charged Traveller 1 Has Manual EMC]
    --,a.[Charged Traveller 1 EMC Score]
    --,a.[Charged Traveller 1 EMC Reference]
    --,a.[Charged Traveller 2 Gender]
    --,a.[Charged Traveller 2 DOB]
    --,a.[Charged Traveller 2 Has EMC]
    --,a.[Charged Traveller 2 Has Manual EMC]
    --,a.[Charged Traveller 2 EMC Score]
    --,a.[Charged Traveller 2 EMC Reference]
    --,a.[Charged Traveller 3 Gender]
    --,a.[Charged Traveller 3 DOB]
    --,a.[Charged Traveller 3 Has EMC]
    --,a.[Charged Traveller 3 Has Manual EMC]
    --,a.[Charged Traveller 3 EMC Score]
    --,a.[Charged Traveller 3 EMC Reference]
    --,a.[Charged Traveller 4 Gender]
    --,a.[Charged Traveller 4 DOB]
    --,a.[Charged Traveller 4 Has EMC]
    --,a.[Charged Traveller 4 Has Manual EMC]
    --,a.[Charged Traveller 4 EMC Score]
    --,a.[Charged Traveller 4 EMC Reference]
    --,a.[Charged Traveller 5 Gender]
    --,a.[Charged Traveller 5 DOB]
    --,a.[Charged Traveller 5 Has EMC]
    --,a.[Charged Traveller 5 Has Manual EMC]
    --,a.[Charged Traveller 5 EMC Score]
    --,a.[Charged Traveller 5 EMC Reference]
    --,a.[Charged Traveller 6 Gender]
    --,a.[Charged Traveller 6 DOB]
    --,a.[Charged Traveller 6 Has EMC]
    --,a.[Charged Traveller 6 Has Manual EMC]
    --,a.[Charged Traveller 6 EMC Score]
    --,a.[Charged Traveller 6 EMC Reference]
    --,a.[Charged Traveller 7 Gender]
    --,a.[Charged Traveller 7 DOB]
    --,a.[Charged Traveller 7 Has EMC]
    --,a.[Charged Traveller 7 Has Manual EMC]
    --,a.[Charged Traveller 7 EMC Score]
    --,a.[Charged Traveller 7 EMC Reference]
    --,a.[Charged Traveller 8 Gender]
    --,a.[Charged Traveller 8 DOB]
    --,a.[Charged Traveller 8 Has EMC]
    --,a.[Charged Traveller 8 Has Manual EMC]
    --,a.[Charged Traveller 8 EMC Score]
    --,a.[Charged Traveller 8 EMC Reference]
    --,a.[Charged Traveller 9 Gender]
    --,a.[Charged Traveller 9 DOB]
    --,a.[Charged Traveller 9 Has EMC]
    --,a.[Charged Traveller 9 Has Manual EMC]
    --,a.[Charged Traveller 9 EMC Score]
    --,a.[Charged Traveller 9 EMC Reference]
    --,a.[Charged Traveller 10 Gender]
    --,a.[Charged Traveller 10 DOB]
    --,a.[Charged Traveller 10 Has EMC]
    --,a.[Charged Traveller 10 Has Manual EMC]
    --,a.[Charged Traveller 10 EMC Score]
    --,a.[Charged Traveller 10 EMC Reference]

    --,a.[Commission Tier]
    --,a.[Volume Commission]
    --,a.[Discount]

    --,a.[Base Base Premium]
    --,a.[Base Premium]
    --,a.[Canx Premium]
    --,a.[Undiscounted Canx Premium]
    --,a.[Rental Car Premium]
    --,a.[Motorcycle Premium]
    --,a.[Luggage Premium]
    --,a.[Medical Premium]
    --,a.[Winter Sport Premium]
    --,a.[Unadjusted Sell Price]
    --,a.[Unadjusted GST on Sell Price]
    --,a.[Unadjusted Stamp Duty on Sell Price]
    --,a.[Unadjusted Agency Commission]
    --,a.[Unadjusted GST on Agency Commission]
    --,a.[Unadjusted Stamp Duty on Agency Commission]
    --,a.[Unadjusted Admin Fee]
    --,a.[Sell Price]
    --,a.[GST on Sell Price]
    --,a.[Stamp Duty on Sell Price]
    --,a.[Premium]
    --,a.[Risk Nett]
    --,a.[GUG]
    --,a.[Agency Commission]
    --,a.[GST on Agency Commission]
    --,a.[Stamp Duty on Agency Commission]
    --,a.[Admin Fee]
    --,a.[NAP]
    --,a.[NAP (incl Tax)]
    --,a.[Policy Count]

    --,a.[Price Beat Policy]
    --,a.[Competitor Name]
    --,a.[Competitor Price]
    --,a.[Category]

    --,a.[ActuarialPolicyID]
    --,a.[EMC Tier Oldest Charged]
    --,a.[EMC Tier Youngest Charged]
    --,a.[Has Cruise]
    --,a.[Cruise Premium]
    --,a.[Plan Name]
    --,a.[Has COVID19]
    --,a.[Has Pre-Trip]
    --,a.[Has COVID19 Cruise]

    --,a.[Policy Count Fix]
    --,a.[TripStart]
    --,a.[TripEnd]
    --,a.[LeadTime]
    --,a.[TripDuration]
    
    --,a.[UW Policy Status]
    --,a.[UW Premium]
    --,a.[UW Premium COVID19]
    --,a.[UW Premium COVID19 Estimate]
    --,a.[UW Domain Country]
    --,a.[UW Issue Month]
    --,a.[UW Rating Group]
    --,a.[UW JV Description Orig]
    --,a.[UW JV Group]
    --,a.[UW Product Code]

    --,a.[Outlet Name]
    --,a.[Outlet Sub Group Code]
    ,a.[Outlet Sub Group Name]
    --,a.[Outlet Group Code]
    ,a.[Outlet Group Name]
    ,a.[Outlet Super Group]
    ,a.[JV Description]
    ,a.[Outlet Channel]
    --,a.[Outlet BDM]
    --,a.[Outlet Post Code]
    --,a.[Outlet Sales State Area]
    --,a.[Outlet Trading Status]
    --,a.[Outlet Type]
    --,a.[JV Code]
    --,a.[Underwriter]
    --,a.[ClaimCount]

    --,a.[Youngest EMC DOB]
    --,a.[Oldest EMC DOB]
    --,a.[Youngest EMC Age]
    --,a.[Oldest EMC Age]

    --,a.[Gross Premium Adventure Activities]
    --,a.[Gross Premium Aged Cover]
    --,a.[Gross Premium Ancillary Products]
    --,a.[Gross Premium Cancel For Any Reason]
    --,a.[Gross Premium Cancellation]
    --,a.[Gross Premium COVID-19]
    --,a.[Gross Premium Cruise]
    --,a.[Gross Premium Electronics]
    --,a.[Gross Premium Freely Packs]
    --,a.[Gross Premium Luggage]
    --,a.[Gross Premium Medical]
    --,a.[Gross Premium Motorcycle]
    --,a.[Gross Premium Rental Car]
    --,a.[Gross Premium Ticket]
    --,a.[Gross Premium Winter Sport]
    --,a.[UnAdj Gross Premium Adventure Activities]
    --,a.[UnAdj Gross Premium Aged Cover]
    --,a.[UnAdj Gross Premium Ancillary Products]
    --,a.[UnAdj Gross Premium Cancel For Any Reason]
    --,a.[UnAdj Gross Premium Cancellation]
    --,a.[UnAdj Gross Premium COVID-19]
    --,a.[UnAdj Gross Premium Cruise]
    --,a.[UnAdj Gross Premium Electronics]
    --,a.[UnAdj Gross Premium Freely Packs]
    --,a.[UnAdj Gross Premium Luggage]
    --,a.[UnAdj Gross Premium Medical]
    --,a.[UnAdj Gross Premium Motorcycle]
    --,a.[UnAdj Gross Premium Rental Car]
    --,a.[UnAdj Gross Premium Ticket]
    --,a.[UnAdj Gross Premium Winter Sport]

    ,a.[Addon Count Adventure Activities]
    ,a.[Addon Count Aged Cover]
    ,a.[Addon Count Ancillary Products]
    ,a.[Addon Count Cancel For Any Reason]
    ,a.[Addon Count Cancellation]
    ,a.[Addon Count COVID-19]
    ,a.[Addon Count Cruise]
    ,a.[Addon Count Electronics]
    ,a.[Addon Count Freely Packs]
    ,a.[Addon Count Luggage]
    ,a.[Luggage Increase]
    --,a.[Addon Count Medical]
    ,a.[Addon Count Motorcycle]
    ,a.[Addon Count Rental Car]
    ,a.[Rental Car Increase]
    ,a.[Addon Count Ticket]
    ,a.[Addon Count Winter Sport]

    --,a.[Promo Code]
    --,a.[Promo Name]
    --,a.[Promo Type]
    --,a.[Promo Discount]

    --,a.[Sell Price - Total]
    --,a.[Sell Price - Active]
    --,a.[Sell Price - Active Base]
    --,a.[Sell Price - Active Extension]
    --,a.[Sell Price - Cancelled]
    --,a.[Sell Price - Cancelled Base]
    --,a.[Sell Price - Cancelled Extension]
    --,a.[Premium - Total]
    --,a.[Premium - Active]
    --,a.[Premium - Active Base]
    --,a.[Premium - Active Extension]
    --,a.[Premium - Cancelled]
    --,a.[Premium - Cancelled Base]
    --,a.[Premium - Cancelled Extension]
    --,a.[First Active Date]
    --,a.[First Active Date - Base]
    --,a.[First Active Date - Extension]
    --,a.[Last Active Date]
    --,a.[Last Active Date - Base]
    --,a.[Last Active Date - Extension]
    --,a.[First Cancelled Date]
    --,a.[First Cancelled Date - Base]
    --,a.[First Cancelled Date - Extension]
    --,a.[Last Cancelled Date]
    --,a.[Last Cancelled Date - Base]
    --,a.[Last Cancelled Date - Extension]
    --,a.[Days to Cancelled]
    --,a.[Work Days to Cancelled]
    --,a.[Policy Status Detailed]
    --,a.[Credit Note Number]
    --,a.[Credit Note Issue Date]
    --,a.[Credit Note Start Date]
    --,a.[Credit Note Expiry Date]
    --,a.[Credit Note Status]
    --,a.[Credit Note Amount]
    --,a.[Credit Note Amount Redeemed]
    --,a.[Credit Note Amount Remaining]

    ,a.[Policy Count]
    ,a.[Premium]

	,c.[ClaimCount]
	,c.[SectionCount]
	,c.[NetPaymentMovementIncRecoveries]
	,c.[NetIncurredMovementIncRecoveries]

	,c.[Sections MED]
	,c.[Payments MED]
	,c.[Incurred MED]
	,c.[Sections MED_LGE]
	,c.[Payments MED_LGE]
	,c.[Incurred MED_LGE]

	,c.[Sections CAN]
	,c.[Payments CAN]
	,c.[Incurred CAN]
	,c.[Sections CAN_LGE]
	,c.[Payments CAN_LGE]
	,c.[Incurred CAN_LGE]

	,c.[Sections PRE_CAN]
	,c.[Payments PRE_CAN]
	,c.[Incurred PRE_CAN]
	,c.[Sections PRE_CAN_LGE]
	,c.[Payments PRE_CAN_LGE]
	,c.[Incurred PRE_CAN_LGE]

	,c.[Sections ON_CAN]
	,c.[Payments ON_CAN]
	,c.[Incurred ON_CAN]
	,c.[Sections ON_CAN_LGE]
	,c.[Payments ON_CAN_LGE]
	,c.[Incurred ON_CAN_LGE]

	,c.[Sections ADD]
	,c.[Payments ADD]
	,c.[Incurred ADD]
	,c.[Sections ADD_LGE]
	,c.[Payments ADD_LGE]
	,c.[Incurred ADD_LGE]

	,c.[Sections MIS]
	,c.[Payments MIS]
	,c.[Incurred MIS]
	,c.[Sections MIS_LGE]
	,c.[Payments MIS_LGE]
	,c.[Incurred MIS_LGE]

	,c.[Sections LUG]
	,c.[Payments LUG]
	,c.[Incurred LUG]
	,c.[Sections LUG_LGE]
	,c.[Payments LUG_LGE]
	,c.[Incurred LUG_LGE]

	,c.[Sections OTH]
	,c.[Payments OTH]
	,c.[Incurred OTH]
	,c.[Sections OTH_LGE]
	,c.[Payments OTH_LGE]
	,c.[Incurred OTH_LGE]

	,c.[Sections CAT]
	,c.[Payments CAT]
	,c.[Incurred CAT]

	,c.[Sections COV]
	,c.[Payments COV]
	,c.[Incurred COV]

FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]  a
LEFT JOIN [db-au-actuary].[cng].[penPolicy]             b ON a.[PolicyKey] = b.[PolicyKey] AND a.[Product Code] = b.[ProductCode]
OUTER APPLY (
    SELECT *
    FROM claims c
    WHERE a.[PolicyKey]    = c.[PolicyKey] AND 
          a.[Product Code] = c.[Product Code]
    ) c
LEFT JOIN [db-au-actuary].[cng].[UW_Destinations] d ON a.[Destination] = d.[Destination]

WHERE a.[Policy Status] = 'Active' 
  AND 
       a.[Return Date]  BETWEEN '2022-08-01' AND '2023-07-31'
  AND a.[Product Group] = 'Travel'
  AND a.[Product Name] <> 'Corporate'
  AND a.[JV Description] NOT IN ('CBA NAC','BW NAC')
  AND a.[UW Rating Group] = 'GLM'
;
GO
