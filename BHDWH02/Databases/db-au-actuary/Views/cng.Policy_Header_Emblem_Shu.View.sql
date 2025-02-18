USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_Emblem_Shu]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [cng].[Policy_Header_Emblem_Shu] AS 

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
        WHEN [ReturnDate] <= '2019-12-31' THEN
            CASE
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
            END
        WHEN [ReturnDate] > '2019-12-31' THEN
            CASE
              --WHEN [CATCode]     IN ('COR','COR1') AND [IssueDate] >= '2020-12-01' AND [IssueDate] <= '2023-06-30'                THEN 'COV'
                WHEN [CATCode] NOT IN ('COR','COR1','CAT','CO1','MHC',' ')                                                          THEN 'CAT'
              --WHEN [CFARClaimFlag]         = 1                     AND [Size75k] = 'Underlying'                                   THEN 'CFR'
              --WHEN [CFARClaimFlag]         = 1                     AND [Size75k] = 'Large'                                        THEN 'CFR_LGE'
                WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size75k] = 'Underlying'                                   THEN 'ADD'
                WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size75k] = 'Large'                                        THEN 'ADD_LGE'
                WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size75k] = 'Underlying' AND [LossDate]<=[DepartureDate]   THEN 'PRE_CAN'
                WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size75k] = 'Large'      AND [LossDate]<=[DepartureDate]   THEN 'PRE_CAN_LGE'
                WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size75k] = 'Underlying' AND [LossDate]> [DepartureDate]   THEN 'ON_CAN'
                WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size75k] = 'Large'      AND [LossDate]> [DepartureDate]   THEN 'ON_CAN_LGE'
                WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size75k] = 'Underlying'                                   THEN 'LUG'
                WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size75k] = 'Large'                                        THEN 'LUG_LGE'
                WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size75k] = 'Underlying'                                   THEN 'MED'
                WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size75k] = 'Large'                                        THEN 'MED_LGE'
                WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size75k] = 'Underlying'                                   THEN 'OTH'
                WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size75k] = 'Large'                                        THEN 'OTH_LGE'
                                                                                                                                    ELSE 'OTH'
            END
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

    --,a.[Lead Time]
    ,CASE
        WHEN                         a.[Lead Time] <=   0 THEN 0
        WHEN a.[Lead Time] >   0 AND a.[Lead Time] <= 181 THEN a.[Lead Time]
        WHEN a.[Lead Time] > 181 AND a.[Lead Time] <= 545 THEN (FLOOR(a.[Lead Time]/7.00)+1)*7-1
        WHEN a.[Lead Time] > 545                          THEN 552
        ELSE NULL
    END AS [Lead Time]
    --,a.[Trip Duration]
    ,CASE
        WHEN                             a.[Trip Duration] <=   0 THEN 1
        WHEN a.[Trip Duration] >   0 AND a.[Trip Duration] <=  90 THEN a.[Trip Duration]
        WHEN a.[Trip Duration] >  90 AND a.[Trip Duration] <= 363 THEN (FLOOR(a.[Trip Duration]/7.00)+1)*7-1
        WHEN a.[Trip Duration] > 363 AND a.[Trip Duration] <= 366 THEN 365
        WHEN a.[Trip Duration] > 366                              THEN 370
        ELSE NULL 
     END AS [Trip Duration]
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
    ,a.[Country or Area]
    ,a.[Intermediate Region Name]
    ,a.[Region Name]

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

	,a.[Trip Cost Adj]
	,a.[Cancellation Group]
	,e.[value]

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
    ,CAST(ROUND(
     (SELECT COALESCE(MAX(v),0)
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
     ),0) as int) AS [Highest EMC Score]
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

    ,COALESCE(a.[Addon Count Adventure Activities],0)   AS [Addon Count Adventure Activities]
    ,COALESCE(a.[Addon Count Aged Cover],0)             AS [Addon Count Aged Cover]
    ,COALESCE(a.[Addon Count Ancillary Products],0)     AS [Addon Count Ancillary Products]
    ,COALESCE(a.[Addon Count Cancel For Any Reason],0)  AS [Addon Count Cancel For Any Reason]
    ,COALESCE(a.[Addon Count Cancellation],0)           AS [Addon Count Cancellation]
    ,COALESCE(a.[Addon Count COVID-19],0)               AS [Addon Count COVID-19]
    ,COALESCE(a.[Addon Count Cruise],0)                 AS [Addon Count Cruise]
    ,COALESCE(a.[Addon Count Electronics],0)            AS [Addon Count Electronics]
    ,COALESCE(a.[Addon Count Freely Packs],0)           AS [Addon Count Freely Packs]
    ,COALESCE(a.[Addon Count Luggage],0)                AS [Addon Count Luggage]
    ,a.[Luggage Increase]
    --,a.[Addon Count Medical]
    ,COALESCE(a.[Addon Count Motorcycle],0)             AS [Addon Count Motorcycle]
    ,COALESCE(a.[Addon Count Rental Car],0)             AS [Addon Count Rental Car]
    ,a.[Rental Car Increase]
    ,COALESCE(a.[Addon Count Ticket],0)                 AS [Addon Count Ticket]
    ,COALESCE(a.[Addon Count Winter Sport],0)           AS [Addon Count Winter Sport]

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

    ,COALESCE(a.[Policy Count],0) AS [Policy Count]
    ,COALESCE(a.[Premium],0) AS [Premium]

	,COALESCE(c.[ClaimCount],0) AS [ClaimCount]
	,COALESCE(c.[SectionCount],0) AS [SectionCount]
	,COALESCE(c.[NetPaymentMovementIncRecoveries],0) AS [NetPaymentMovementIncRecoveries]
	,COALESCE(c.[NetIncurredMovementIncRecoveries],0) AS [NetIncurredMovementIncRecoveries]

	,COALESCE(c.[Sections MED],0) AS [Sections MED]
	,COALESCE(c.[Payments MED],0) AS [Payments MED]
	,COALESCE(c.[Incurred MED],0) AS [Incurred MED]
	,COALESCE(c.[Sections MED_LGE],0) AS [Sections MED_LGE]
	,COALESCE(c.[Payments MED_LGE],0) AS [Payments MED_LGE]
	,COALESCE(c.[Incurred MED_LGE],0) AS [Incurred MED_LGE]

	,COALESCE(c.[Sections CAN],0) AS [Sections CAN]
	,COALESCE(c.[Payments CAN],0) AS [Payments CAN]
	,COALESCE(c.[Incurred CAN],0) AS [Incurred CAN]
	,COALESCE(c.[Sections CAN_LGE],0) AS [Sections CAN_LGE]
	,COALESCE(c.[Payments CAN_LGE],0) AS [Payments CAN_LGE]
	,COALESCE(c.[Incurred CAN_LGE],0) AS [Incurred CAN_LGE]

	,COALESCE(c.[Sections PRE_CAN],0) AS [Sections PRE_CAN]
	,COALESCE(c.[Payments PRE_CAN],0) AS [Payments PRE_CAN]
	,COALESCE(c.[Incurred PRE_CAN],0) AS [Incurred PRE_CAN]
	,COALESCE(c.[Sections PRE_CAN_LGE],0) AS [Sections PRE_CAN_LGE]
	,COALESCE(c.[Payments PRE_CAN_LGE],0) AS [Payments PRE_CAN_LGE]
	,COALESCE(c.[Incurred PRE_CAN_LGE],0) AS [Incurred PRE_CAN_LGE]

	,COALESCE(c.[Sections ON_CAN],0) AS [Sections ON_CAN]
	,COALESCE(c.[Payments ON_CAN],0) AS [Payments ON_CAN]
	,COALESCE(c.[Incurred ON_CAN],0) AS [Incurred ON_CAN]
	,COALESCE(c.[Sections ON_CAN_LGE],0) AS [Sections ON_CAN_LGE]
	,COALESCE(c.[Payments ON_CAN_LGE],0) AS [Payments ON_CAN_LGE]
	,COALESCE(c.[Incurred ON_CAN_LGE],0) AS [Incurred ON_CAN_LGE]

	,COALESCE(c.[Sections ADD],0) AS [Sections ADD]
	,COALESCE(c.[Payments ADD],0) AS [Payments ADD]
	,COALESCE(c.[Incurred ADD],0) AS [Incurred ADD]
	,COALESCE(c.[Sections ADD_LGE],0) AS [Sections ADD_LGE]
	,COALESCE(c.[Payments ADD_LGE],0) AS [Payments ADD_LGE]
	,COALESCE(c.[Incurred ADD_LGE],0) AS [Incurred ADD_LGE]

	,COALESCE(c.[Sections MIS],0) AS [Sections MIS]
	,COALESCE(c.[Payments MIS],0) AS [Payments MIS]
	,COALESCE(c.[Incurred MIS],0) AS [Incurred MIS]
	,COALESCE(c.[Sections MIS_LGE],0) AS [Sections MIS_LGE]
	,COALESCE(c.[Payments MIS_LGE],0) AS [Payments MIS_LGE]
	,COALESCE(c.[Incurred MIS_LGE],0) AS [Incurred MIS_LGE]

	,COALESCE(c.[Sections LUG],0) AS [Sections LUG]
	,COALESCE(c.[Payments LUG],0) AS [Payments LUG]
	,COALESCE(c.[Incurred LUG],0) AS [Incurred LUG]
	,COALESCE(c.[Sections LUG_LGE],0) AS [Sections LUG_LGE]
	,COALESCE(c.[Payments LUG_LGE],0) AS [Payments LUG_LGE]
	,COALESCE(c.[Incurred LUG_LGE],0) AS [Incurred LUG_LGE]

	,COALESCE(c.[Sections OTH],0) AS [Sections OTH]
	,COALESCE(c.[Payments OTH],0) AS [Payments OTH]
	,COALESCE(c.[Incurred OTH],0) AS [Incurred OTH]
	,COALESCE(c.[Sections OTH_LGE],0) AS [Sections OTH_LGE]
	,COALESCE(c.[Payments OTH_LGE],0) AS [Payments OTH_LGE]
	,COALESCE(c.[Incurred OTH_LGE],0) AS [Incurred OTH_LGE]

	,COALESCE(c.[Sections CAT],0) AS [Sections CAT]
	,COALESCE(c.[Payments CAT],0) AS [Payments CAT]
	,COALESCE(c.[Incurred CAT],0) AS [Incurred CAT]

	,COALESCE(c.[Sections COV],0) AS [Sections COV]
	,COALESCE(c.[Payments COV],0) AS [Payments COV]
	,COALESCE(c.[Incurred COV],0) AS [Incurred COV]

FROM 
(Select *
		,CASE WHEN
		[Product Code] in ('CPC', 'CBI') OR /*new direct*/
		[Product Code] in ('FYP', 'FYE', 'NPP', 'NPG') and [Issue Date] >= '2022-04-06' OR /*new flight centre*/
		[Product Code] in ('ICC', 'IEC') and [Issue Date] >= '2022-04-20' OR /*new HW, indies*/
		[Product Code] in ('MTP', 'MTE') /*Kogan*/
		THEN 'CPC'
	WHEN
		[Product Code] in ('CMH', 'FCO', 'FCT', 'ABW', 'BJW', 'STY', 'SYE', 'CMT', 'FCC', 'CMW', 'CMY') /*old direct*/	
		THEN 'CMH'
	 WHEN
		([Product Code] in ('ICC') and [Issue Date] < '2022-04-20') OR [Product Code] = 'APC'  /*old HW, Indies, Auspost*/
		THEN 'ICC'
	WHEN
		([Product Code] in ('IEC') and [Issue Date] < '2022-04-20')  /*old HW, Indies*/
		THEN 'IEC'
	WHEN
		[Product Code] in ('HBC', 'HCC', 'PCR', 'BCR', 'CCR')  /*HW, Indies*/
		THEN 'HBC'
	WHEN
		[Product Code] in ('FYP', 'FYE', 'NPP', 'NPG') and [Issue Date] < '2022-04-06' /*old flight centre*/
		THEN 'FYP'
	WHEN
		[Product Code] in ('FPP', 'FPG', 'SYC')  /*old flight centre*/
		THEN 'FYP'
	WHEN
		[Product Code] in ('AHM')  /*AHM*/
		THEN 'AHM'
	WHEN
		[Product Code] in ('IAL', 'NTI', 'NRI')  /*IAG*/
		THEN 'IAG'
	WHEN
		[Product Code] in ('CBT')  /*CBA*/
		THEN 'CBA'
	WHEN
		[Product Code] in ('F2B', 'F4B', 'FRB')  /*fREELY*/
		THEN 'Freely'
	WHEN
		[Product Code] in ('WJP', 'WJS')  /*WJP, same for AU & NZ*/
		THEN 'WJP'
	WHEN
		[Product Code] in ('AIN')  /*WJP*/
		THEN 'AIN'
	/**New Zealand**/
	WHEN
		[Product Code] in ('AIA')  /*WJP*/
		THEN 'AIA'
	WHEN
		[Product Code] in ('YTI', 'ETI') and [Issue Date] >= '2019-09-20' /*new flight centre*/
		THEN 'new YTI'
	WHEN
		[Product Code] in ('YTI', 'ETI') and [Issue Date] < '2019-09-20' OR
		[Product Code] in ('IAG','NZO','NZE','PNO','WTP','NZC')
		THEN 'old YTI'
	ELSE 'others'
	END AS [Cancellation Group]

	,CASE WHEN  
		([Product Code] in ('ICC', 'IEC') and [Issue Date] < '2022-04-20') OR
		[Product Code] in ('WJP', 'WJS')
		
		THEN 
		CASE WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 0 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 1000
			THEN 1000
		WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 1000 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 2000
			THEN 2000
		WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 4000 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 5000
			THEN 5000
		WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 7500 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 8000
			THEN 8000
		WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 40000 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 50000
			THEN 50000
		WHEN [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) > 50000 AND [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END) < 60000
			THEN 60000
		WHEN [Trip Cost] >= 1000000
			THEN 1000000
		ELSE [Trip Cost] / (CASE WHEN [Adult Traveller Count] >= 4 THEN 4 ELSE [Adult Traveller Count] END)
		END

	ELSE

		CASE WHEN [Trip Cost] > 0 and [Trip Cost] < 1000
			THEN 1000
		WHEN [Trip Cost] > 1000 AND [Trip Cost] < 2000
			THEN 2000
		WHEN [Trip Cost] > 8000 AND [Trip Cost] < 9000
			THEN 9000
		WHEN [Trip Cost] > 9000 AND [Trip Cost] < 10000
			THEN 10000
		WHEN [Trip Cost] > 13000 AND [Trip Cost] < 14000
			THEN 14000
		WHEN [Trip Cost] > 16000 AND [Trip Cost] < 17000
			THEN 17000
		WHEN [Trip Cost] > 17000 AND [Trip Cost] < 18000
			THEN 18000
		WHEN [Trip Cost] > 19000 AND [Trip Cost] < 20000
			THEN 20000
		WHEN [Trip Cost] > 21000 AND [Trip Cost] < 22000
			THEN 22000
		WHEN [Trip Cost] > 22000 AND [Trip Cost] < 23000
			THEN 23000
		WHEN [Trip Cost] > 26000 AND [Trip Cost] < 27000
			THEN 27000
		WHEN [Trip Cost] > 40000 AND [Trip Cost] < 50000
			THEN 50000
		WHEN [Trip Cost] > 50000 AND [Trip Cost] < 60000
			THEN 60000
		WHEN [Trip Cost] > 60000 AND [Trip Cost] < 70000
			THEN 70000
		WHEN [Trip Cost] > 85000 AND [Trip Cost] < 90000
			THEN 90000
		WHEN [Trip Cost] > 100000 AND [Trip Cost] < 220000
			THEN 200000
		WHEN [Trip Cost] > 1000000
			THEN 1000000
		ELSE [Trip Cost]
		END

	END AS [Trip Cost Adj] 

	,CASE WHEN  
		[Plan Type] in ('Domestic Inbound')
			THEN 'International'
		ELSE [Plan Type]
	END AS [Plan Type adj]
FROM
[db-au-actuary].[cng].[Policy_Header_Works_Table]) a
LEFT JOIN [db-au-actuary].[cng].[penPolicy]             b ON a.[PolicyKey] = b.[PolicyKey] AND a.[Product Code] = b.[ProductCode]
OUTER APPLY (
    SELECT *
    FROM claims c
    WHERE a.[PolicyKey]    = c.[PolicyKey] AND 
          a.[Product Code] = c.[Product Code]
    ) c
LEFT JOIN [db-au-actuary].[cng].[UW_Destinations] d ON a.[Destination] = d.[Destination]
LEFT JOIN [db-au-actuary].[cng].[GLM_trip_cost_table] e ON a.[Domain Country] = e.[Domain_Country] and
		a.[Cancellation Group] = e.[Cancellation_Group] and
		a.[Plan Type Adj] = e.[Plan_Type_Adj] and
		a.[Trip Cost Adj] = e.[Trip_Cost_Adj]

WHERE a.[Policy Status] = 'Active' 
  AND (a.[Return Date]  BETWEEN '2019-01-01' AND '2019-12-31'
       OR
       a.[Return Date]  BETWEEN '2022-08-01' AND '2023-07-31')
  AND a.[Product Group] = 'Travel'
  AND a.[Product Name] <> 'Corporate'
  AND a.[JV Description] NOT IN ('CBA NAC','BW NAC')
  AND a.[UW Rating Group] = 'GLM'
;
GO
