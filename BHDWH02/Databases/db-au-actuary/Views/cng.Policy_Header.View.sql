USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header] AS 

WITH 
DWHDataSetSummary AS (
    SELECT * FROM [db-au-actuary].[cng].[DWHDataSetSummary]

    --SELECT ROW_NUMBER() OVER (PARTITION BY [PolicyKey] ORDER BY [BIRowID]) AS [Rank],
    --       * 
    --FROM [db-au-actuary].[ws].[DWHDataSetSummary]
    --WHERE [Domain Country] IN ('AU','NZ') AND ([Issue Date] >= '2017-07-01' OR [Departure Date] >= '2017-07-01' OR [Return Date] >= '2017-07-01')
    --UNION ALL
    --SELECT ROW_NUMBER() OVER (PARTITION BY [PolicyKey] ORDER BY [BIRowID]) AS [Rank],
    --       * 
    --FROM [db-au-actuary].[ws].[DWHDataSetSummary_CBA]
    --WHERE [Domain Country] IN ('AU','NZ') AND ([Issue Date] >= '2017-07-01' OR [Departure Date] >= '2017-07-01' OR [Return Date] >= '2017-07-01')
),

Regions AS (
    SELECT df.[Destination],dr.*
    FROM [db-au-actuary].[cng].[Destination_Fix]     df
    JOIN [db-au-actuary].[cng].[Destination_Regions] dr ON df.[Fix] = dr.[Country or Area]
),

UWPremium AS (
  --SELECT * FROM [db-au-actuary].[cng].[UWPremiumEndorsement_202105]
    SELECT *,0 AS [UW_Premium_Current] FROM [db-au-actuary].[cng].[UW_Premiums_Table] WHERE [Rank] = 1
),

postcodes AS (
    SELECT
         RANK() OVER (PARTITION BY [postcode] ORDER BY COUNT(*) DESC) AS [Rank]
        ,[postcode]
        ,[state]
        ,COUNT(*) AS [Count]
    FROM [db-au-actuary].[cng].[Postcodes]
    GROUP BY [postcode],[state] 
),

--penPolicyTransSummary AS (
--    SELECT 
--         [PolicyKey]
--        ,[ProductCode] AS [Product Code]
--        ,SUM(CASE WHEN [TopUp] = 1 AND [BasePolicyCount] = -1 THEN 0 ELSE [BasePolicyCount] END) AS [Policy Count]
--    FROM [db-au-actuary].[cng].[penPolicyTransSummary] --[ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]
--    GROUP BY [PolicyKey],[ProductCode]
--),

penPolicyTransSummary1 AS 
(
    SELECT
         [PolicyKey]
        ,[ProductCode]
        ,IIF(SUM([BasePolicyCount]) OVER (PARTITION BY [PolicyKey],[ProductCode] ORDER BY [PolicyTransactionKey])>=0,[BasePolicyCount],0) AS [BasePolicyCount]
    FROM [db-au-actuary].[cng].[penPolicyTransSummary] --[ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]
),

penPolicyTransSummary AS (
    SELECT 
         [PolicyKey]
        ,[ProductCode] AS [Product Code]
        ,SUM([BasePolicyCount]) AS [Policy Count]
    FROM penPolicyTransSummary1
    GROUP BY [PolicyKey],[ProductCode]
),

penPolicy AS (
    SELECT 
         [PolicyKey]
        ,[PolicyNumber]
        ,[ProductCode] AS [Product Code]
        ,[TripStart]
        ,[TripEnd]
        ,[Area]
        ,[AreaCode]
        ,[MultiDestination]
    FROM [db-au-actuary].[cng].[penPolicy]
),

Policy_Transactions AS (
    SELECT 
         [PolicyKey]
        ,[Product Code]
        ,[Policy Status]
        ,[Transaction Status]
        ,[Transaction Type]
        ,[Transaction Issue Date]
        ,[Departure Date]
        ,[Return Date]
    FROM [db-au-actuary].[cng].[Policy_Transactions]
  --WHERE [Base Policy No] = '717000274699'
),

dimOutlet AS (
    SELECT 
         ROW_NUMBER() OVER (PARTITION BY [OutletKey] ORDER BY [LoadDate] DESC) AS [Rank]
        ,[LoadDate]
        ,[OutletKey]          AS [Outlet Key]
        ,[OutletName]         AS [Outlet Name]
        ,[SubGroupCode]       AS [Outlet Sub Group Code]
        ,[SubGroupName]       AS [Outlet Sub Group Name]
        ,[GroupCode]          AS [Outlet Group Code]
        ,[GroupName]          AS [Outlet Group Name]
        ,[SuperGroupName]     AS [Outlet Super Group]
        ,[Channel]            AS [Outlet Channel]
        ,[BDMName]            AS [Outlet BDM]
        ,[ContactPostCode]    AS [Outlet Post Code]
        ,[StateSalesArea]     AS [Outlet Sales State Area]
        ,[TradingStatus]      AS [Outlet Trading Status]
        ,[OutletType]         AS [Outlet Type]
        ,[JV]                 AS [JV Code]
        ,[JVDesc]             AS [JV Description]
    FROM  [db-au-actuary].[cng].[dimOutlet]
    WHERE [isLatest] = 'Y' AND [OutletKey] <> ''
),

penOutlet AS (
    SELECT
         ROW_NUMBER() OVER (PARTITION BY [OutletKey] ORDER BY [OutletStartDate] DESC) AS [Rank]
        ,[OutletStartDate]
        ,[OutletKey]        AS [Outlet Key]
        ,[OutletName]       AS [Outlet Name]
        ,[SubGroupCode]     AS [Outlet Sub Group Code]
        ,[SubGroupName]     AS [Outlet Sub Group Name]
        ,[GroupCode]        AS [Outlet Group Code]
        ,[GroupName]        AS [Outlet Group Name]
        ,[SuperGroupName]   AS [Outlet Super Group]
        ,[Channel]          AS [Outlet Channel]
        ,[BDMName]          AS [Outlet BDM]
        ,[ContactPostCode]  AS [Outlet Post Code]
        ,[StateSalesArea]   AS [Outlet Sales State Area]
        ,[TradingStatus]    AS [Outlet Trading Status]
        ,[OutletType]       AS [Outlet Type]
        ,[JVCode]           AS [JV Code]
        ,[JV]               AS [JV Description]
    FROM  [db-au-actuary].[cng].[penOutlet]
    WHERE [OutletStatus] = 'Current'
),

claims AS (
    SELECT 
         [PolicyKey]        AS [PolicyKey]
        ,[ProductCode]      AS [Product Code]
      --,[JVCode]           AS [JV Code]

		,SUM([ClaimCount]                      ) AS [ClaimCount]
		,SUM([SectionCount]                    ) AS [SectionCount]
		,SUM([NetPaymentMovementIncRecoveries] ) AS [NetPaymentMovementIncRecoveries]
		,SUM([NetIncurredMovementIncRecoveries]) AS [NetIncurredMovementIncRecoveries]

		,SUM(CASE WHEN [Section] = 'MED'     THEN [SectionCount]                     ELSE 0 END) AS [Sections MED]
		,SUM(CASE WHEN [Section] = 'MED'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED]
		,SUM(CASE WHEN [Section] = 'MED'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED]
		,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections MED_LGE]
		,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED_LGE]
		,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED_LGE]

		,SUM(CASE WHEN [Section] = 'CAN'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN]
		,SUM(CASE WHEN [Section] = 'CAN'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN]
		,SUM(CASE WHEN [Section] = 'CAN'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN]
		,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN_LGE]
		,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN_LGE]
		,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN_LGE]

	  --,SUM(CASE WHEN [Section] = 'CFR'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CFR]
	  --,SUM(CASE WHEN [Section] = 'CFR'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CFR]
	  --,SUM(CASE WHEN [Section] = 'CFR'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CFR]
      --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections CFR_LGE]
      --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CFR_LGE]
      --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CFR_LGE]

		,SUM(CASE WHEN [Section] = 'ADD'     THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD]
		,SUM(CASE WHEN [Section] = 'ADD'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD]
		,SUM(CASE WHEN [Section] = 'ADD'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD]
		,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD_LGE]
		,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD_LGE]
		,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD_LGE]

		,SUM(CASE WHEN [Section] = 'MIS'     THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS]
		,SUM(CASE WHEN [Section] = 'MIS'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS]
		,SUM(CASE WHEN [Section] = 'MIS'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS]
		,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS_LGE]
		,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS_LGE]
		,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS_LGE]

		,SUM(CASE WHEN [Section] = 'CAT'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CAT]
		,SUM(CASE WHEN [Section] = 'CAT'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAT]
		,SUM(CASE WHEN [Section] = 'CAT'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAT]

		,SUM(CASE WHEN [Section] = 'COV'     THEN [SectionCount]                     ELSE 0 END) AS [Sections COV]
		,SUM(CASE WHEN [Section] = 'COV'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments COV]
		,SUM(CASE WHEN [Section] = 'COV'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred COV]

		,SUM(CASE WHEN [Section] = 'OTH'     THEN [SectionCount]                     ELSE 0 END) AS [Sections OTH]
		,SUM(CASE WHEN [Section] = 'OTH'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments OTH]
		,SUM(CASE WHEN [Section] = 'OTH'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred OTH]

    FROM [db-au-actuary].[cng].[Claim_Header_Table]
    GROUP BY [PolicyKey],[ProductCode]
  --GROUP BY [PolicyKey],[JVCode]
)

SELECT 
     ds.[BIRowID]
    ,ds.[Domain Country]
    ,ds.[Company]
    ,ds.[PolicyKey]
    ,ds.[Base Policy No]
    ,ds.[Policy Status]
    ,ds.[Issue Date]
    ,ds.[Posting Date]
    ,ds.[Last Transaction Issue Date]
    ,ds.[Last Transaction Posting Date]
    ,ds.[Transaction Type]
    --,ds.[Departure Date]
    --,ds.[Return Date]
    --,ds.[Lead Time]
    --,ds.[Trip Duration]
	,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ) AS [Departure Date]
    ,COALESCE(tr.[Return Date]   ,pp.[TripEnd]  ,ds.[Return Date]   ,DATEADD(year,1,ds.[Issue Date])) AS [Return Date]
    ,CASE WHEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date])) > 0
          THEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]))   
          ELSE 0
     END AS [Lead Time]
    ,CASE WHEN DATEDIFF(DAY,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]),COALESCE(tr.[Return Date],pp.[TripEnd],ds.[Return Date],DATEADD(year,1,ds.[Issue Date]))) + 1 > 0
          THEN DATEDIFF(DAY,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]),COALESCE(tr.[Return Date],pp.[TripEnd],ds.[Return Date],DATEADD(year,1,ds.[Issue Date]))) + 1
          ELSE 0
     END AS [Trip Duration]
    ,ds.[Trip Length]
    ,ds.[Maximum Trip Length]
    ,ds.[Area Name]
    ,ds.[Area Number]
    ,pp.[Area]
    ,pp.[AreaCode]
    ,ds.[Destination]
    ,pp.[MultiDestination] AS [Multi Destination]
    ,ds.[Excess]
    ,ds.[Group Policy]
    ,ds.[Has Rental Car]
    ,ds.[Has Motorcycle]
    ,ds.[Has Wintersport]
    ,ds.[Has Medical]
    ,ds.[Single/Family]
    ,ds.[Purchase Path]
    ,ds.[TRIPS Policy]
    ,ds.[Product Code]
    ,ds.[Plan Code]
    ,ds.[Product Name]
    ,ds.[Product Plan]
    ,ds.[Product Type]
    ,ds.[Product Group]
    --,IIF(ds.[Product Group] IN ('NULL'),'Travel',ds.[Product Group]) AS [Product Group]
    ,ds.[Policy Type]
    --,IIF(ds.[Policy Type] IN ('Leisure_CBA','NULL'),'Leisure',ds.[Policy Type]) AS [Policy Type]
    ,ds.[Plan Type]
    ,ds.[Trip Type]
    ,ds.[Product Classification]
    ,ds.[Finance Product Code]
    ,ds.[OutletKey]
    ,ds.[Alpha Code]
    ,ds.[Customer Post Code]
    ,ds.[Unique Traveller Count]
    ,ds.[Unique Charged Traveller Count]
    ,ds.[Traveller Count]
    ,ds.[Charged Traveller Count]
    ,ds.[Adult Traveller Count]
    ,ds.[EMC Traveller Count]
    ,ds.[Youngest Charged DOB]
    ,ds.[Oldest Charged DOB]
    ,ds.[Youngest Age]
    ,ds.[Oldest Age]
    ,ds.[Youngest Charged Age]
    ,ds.[Oldest Charged Age]
    ,ds.[Max EMC Score]
    ,ds.[Total EMC Score]
    ,ds.[Gender]
    ,ds.[Has EMC]
    ,ds.[Has Manual EMC]
    ,ds.[Charged Traveller 1 Gender]
    ,ds.[Charged Traveller 1 DOB]
    ,ds.[Charged Traveller 1 Has EMC]
    ,ds.[Charged Traveller 1 Has Manual EMC]
    ,ds.[Charged Traveller 1 EMC Score]
    ,ds.[Charged Traveller 1 EMC Reference]
    ,ds.[Charged Traveller 2 Gender]
    ,ds.[Charged Traveller 2 DOB]
    ,ds.[Charged Traveller 2 Has EMC]
    ,ds.[Charged Traveller 2 Has Manual EMC]
    ,ds.[Charged Traveller 2 EMC Score]
    ,ds.[Charged Traveller 2 EMC Reference]
    ,ds.[Charged Traveller 3 Gender]
    ,ds.[Charged Traveller 3 DOB]
    ,ds.[Charged Traveller 3 Has EMC]
    ,ds.[Charged Traveller 3 Has Manual EMC]
    ,ds.[Charged Traveller 3 EMC Score]
    ,ds.[Charged Traveller 3 EMC Reference]
    ,ds.[Charged Traveller 4 Gender]
    ,ds.[Charged Traveller 4 DOB]
    ,ds.[Charged Traveller 4 Has EMC]
    ,ds.[Charged Traveller 4 Has Manual EMC]
    ,ds.[Charged Traveller 4 EMC Score]
    ,ds.[Charged Traveller 4 EMC Reference]
    ,ds.[Charged Traveller 5 Gender]
    ,ds.[Charged Traveller 5 DOB]
    ,ds.[Charged Traveller 5 Has EMC]
    ,ds.[Charged Traveller 5 Has Manual EMC]
    ,ds.[Charged Traveller 5 EMC Score]
    ,ds.[Charged Traveller 5 EMC Reference]
    ,ds.[Charged Traveller 6 Gender]
    ,ds.[Charged Traveller 6 DOB]
    ,ds.[Charged Traveller 6 Has EMC]
    ,ds.[Charged Traveller 6 Has Manual EMC]
    ,ds.[Charged Traveller 6 EMC Score]
    ,ds.[Charged Traveller 6 EMC Reference]
    ,ds.[Charged Traveller 7 Gender]
    ,ds.[Charged Traveller 7 DOB]
    ,ds.[Charged Traveller 7 Has EMC]
    ,ds.[Charged Traveller 7 Has Manual EMC]
    ,ds.[Charged Traveller 7 EMC Score]
    ,ds.[Charged Traveller 7 EMC Reference]
    ,ds.[Charged Traveller 8 Gender]
    ,ds.[Charged Traveller 8 DOB]
    ,ds.[Charged Traveller 8 Has EMC]
    ,ds.[Charged Traveller 8 Has Manual EMC]
    ,ds.[Charged Traveller 8 EMC Score]
    ,ds.[Charged Traveller 8 EMC Reference]
    ,ds.[Charged Traveller 9 Gender]
    ,ds.[Charged Traveller 9 DOB]
    ,ds.[Charged Traveller 9 Has EMC]
    ,ds.[Charged Traveller 9 Has Manual EMC]
    ,ds.[Charged Traveller 9 EMC Score]
    ,ds.[Charged Traveller 9 EMC Reference]
    ,ds.[Charged Traveller 10 Gender]
    ,ds.[Charged Traveller 10 DOB]
    ,ds.[Charged Traveller 10 Has EMC]
    ,ds.[Charged Traveller 10 Has Manual EMC]
    ,ds.[Charged Traveller 10 EMC Score]
    ,ds.[Charged Traveller 10 EMC Reference]
    ,ds.[Commission Tier]
    ,ds.[Volume Commission]
    ,ds.[Discount]
    ,ds.[Base Base Premium]
    ,ds.[Base Premium]
    ,ds.[Canx Premium]
    ,ds.[Undiscounted Canx Premium]
    ,ds.[Rental Car Premium]
    ,ds.[Motorcycle Premium]
    ,ds.[Luggage Premium]
    ,ds.[Medical Premium]
    ,ds.[Winter Sport Premium]
    ,ds.[Luggage Increase]
    ,ds.[Trip Cost]
    ,ds.[Unadjusted Sell Price]
    ,ds.[Unadjusted GST on Sell Price]
    ,ds.[Unadjusted Stamp Duty on Sell Price]
    ,ds.[Unadjusted Agency Commission]
    ,ds.[Unadjusted GST on Agency Commission]
    ,ds.[Unadjusted Stamp Duty on Agency Commission]
    ,ds.[Unadjusted Admin Fee]
    --,ds.[Sell Price]
    --,ds.[GST on Sell Price]
    --,ds.[Stamp Duty on Sell Price]
    --,ds.[Premium]
    ,IIF(h.[Customer Policy Number] IS NOT NULL,h.[Gross Premium Inc Taxes],ds.[Sell Price]              ) AS [Sell Price]
    ,IIF(h.[Customer Policy Number] IS NOT NULL,h.[GST Cost]               ,ds.[GST on Sell Price]       ) AS [GST on Sell Price]
    ,IIF(h.[Customer Policy Number] IS NOT NULL,h.[Stamp Duty]             ,ds.[Stamp Duty on Sell Price]) AS [Stamp Duty on Sell Price]
    ,IIF(h.[Customer Policy Number] IS NOT NULL,h.[Gross Premium Exc Taxes],ds.[Premium]                 ) AS [Premium]
    ,ds.[Risk Nett]
    ,ds.[GUG]
    ,ds.[Agency Commission]
    ,ds.[GST on Agency Commission]
    ,ds.[Stamp Duty on Agency Commission]
    ,ds.[Admin Fee]
    ,ds.[NAP]
    ,ds.[NAP (incl Tax)]
    ,COALESCE(pt.[Policy Count],ds.[Policy Count]) AS [Policy Count]
    ,ds.[Price Beat Policy]
    ,ds.[Competitor Name]
    ,ds.[Competitor Price]
    ,ds.[Category]
    ,ds.[Rental Car Increase]
    ,ds.[ActuarialPolicyID]
    ,ds.[EMC Tier Oldest Charged]
    ,ds.[EMC Tier Youngest Charged]
    ,ds.[Has Cruise]
    ,ds.[Cruise Premium]
    ,ds.[Plan Name]

    ,CASE WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND COALESCE(do.[JV Description],po.[JV Description]) IN ('CBA NAC','CBA WL','BW NAC','BW WL')
          THEN 0
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND COALESCE(do.[Outlet Super Group],po.[Outlet Super Group]) IN ('Easy Travel Insurance')
          THEN 0
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Code] IN ('APB','APC','API','APP','CMY','CTD','CTI','HIF',/*'IAL','NRI',*/'RCP','STY','SYC','SYE','TTI','VAR')
          THEN 0
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Code] IN ('ABD','ABI','ABW','AHM','AIN','AIO','AIR','AIW','ANB','ANC','ANF','ATO','ATR','AWT','BCR','BJD',
                                                                                                                     'BJI','BJW','CBI','CCP','CCR','CHH','CMB','CMC','CMH','CMI','CMO','CMT','CMW','CPC','DII','DIT',
                                                                                                                     'DTP','DTS','FCC','FCI','FCO','FCT','FPG','FPP','FY2','FYE','FYI','FYP','GMC','GTS','HBC','HCC',
                                                                                                                     'HPC','ICC','IEC','MBC','MBM','MHA','MNC','MNM','NCC','NPG','NPP','OHT','PCR','TMT','VAI','VAS',
                                                                                                                     'VAW','VBC','VDC','VTC','VTI','WDI','WII','WJP','WJS','WTI')
          THEN 1
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2022-06-15' AND ds.[Product Code] IN ('IAL','NRI')
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-10-27' AND ds.[Product Plan] IN ('AND Domestic Dom-ST'
                                                                                                                    ,'IAG Travel Insurance Dom-ST'
                                                                                                                    ,'NZO Options Dom-ST'
                                                                                                                    ,'YTI YourCover Travel Insurance Dom-ST')
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-10-27' AND ds.[Product Plan] IN ('IAG Travel Insurance Inbound-ST'
                                                                                                                    ,'NZO Options Inbound-ST'
                                                                                                                    ,'YTI YourCover Travel Insurance Inbound-Plus')
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-10-27' AND ds.[Product Plan] IN ('AIA Australia Travel Insurance Int-ST'
                                                                                                                    ,'AIW Worldwide Travel Insurance Int-ST','ANB Business Int  ST'
                                                                                                                    ,'ANF Air NZ Staff Travel Insurance Int-ST'
                                                                                                                    ,'ANI International Int-ST'
                                                                                                                    ,'MHN MH Insure Int-ST'
                                                                                                                    ,'NZO Options Int-ST'
                                                                                                                    ,'YTI YourCover Travel Insurance Int-ST-Y') AND ds.[Destination] = 'Australia' 
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Plan] IN ('AIA Australia Travel Insurance Int-ST'
                                                                                                                    ,'AIW Worldwide Travel Insurance Int-ST'
                                                                                                                    ,'ANB Business Int  ST'
                                                                                                                    ,'ANF Air NZ Staff Travel Insurance Int-ST'
                                                                                                                    ,'ANI International Int-ST'
                                                                                                                    ,'MHN MH Insure Int-ST'
                                                                                                                    ,'NZO Options Int-ST'
                                                                                                                    ,'YTI YourCover Travel Insurance Int-ST-Y')
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-10-27' AND ds.[Product Plan] IN ('IAG Travel Insurance Int-ST'
                                                                                                                    ,'WTP Westpac TravelPlus Int-ST') AND ds.[Destination] = 'Australia' 
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2021-02-02' AND ds.[Product Plan] IN ('IAG Travel Insurance Int-ST'
                                                                                                                    ,'WTP Westpac TravelPlus Int-ST')
          THEN 1
          WHEN ds.[Domain Country] ='NZ' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Code] IN ('WDI','WII','WTI')
          THEN 1
          ELSE 0
     END AS [Has COVID19]

    ,COALESCE(dr.[Country or Area]         ,'Missing') AS [Country or Area]
    ,COALESCE(dr.[Intermediate Region Name],'Missing') AS [Intermediate Region Name]
    ,COALESCE(dr.[Region Name]             ,'Missing') AS [Region Name]

    ,pc.[State] AS [Customer State]

    ,COALESCE(pt.[Policy Count],ds.[Policy Count]) AS [Policy Count Fix]

	,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ) AS [TripStart]
    ,COALESCE(tr.[Return Date]   ,pp.[TripEnd]  ,ds.[Return Date]   ,DATEADD(year,1,ds.[Issue Date])) AS [TripEnd]
    ,CASE WHEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date])) > 0
          THEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]))   
          ELSE 0
     END AS [LeadTime]
    ,CASE WHEN DATEDIFF(DAY,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]),COALESCE(tr.[Return Date],pp.[TripEnd],ds.[Return Date],DATEADD(year,1,ds.[Issue Date]))) + 1 > 0
          THEN DATEDIFF(DAY,COALESCE(tr.[Departure Date],pp.[TripStart],ds.[Departure Date],ds.[Issue Date]),COALESCE(tr.[Return Date],pp.[TripEnd],ds.[Return Date],DATEADD(year,1,ds.[Issue Date]))) + 1
          ELSE 0
     END AS [TripDuration]

    ,uw.[UW_Policy_Status]         AS [UW Policy Status]
    ,uw.[UW_Premium]               AS [UW Premium]
    ,uw.[UW_Premium_Current]       AS [UW Premium Current]
  --,uw.[Previous_Policy_Status]   AS [Previous Policy Status]
  --,uw.[Previous_UW_Premium]      AS [Previous UW Premium]
  --,uw.[Movement]                 AS [UW Movement]
  --,uw.[Total_Movement]           AS [UW Premium]
    ,uw.[UW_Premium_COVID19]       AS [UW Premium COVID19]
    ,uw.[Domain_Country]           AS [UW Domain Country]
    ,uw.[Issue_Mth]                AS [UW Issue Month]
  --,uw.[Rating_Group]             AS [UW Rating Group]
    ,CASE 
        WHEN uw.[Rating_Group] IS NOT NULL THEN uw.[Rating_Group]

        WHEN ds.[Domain Country] IN ('AU','NZ') AND COALESCE(do.[JV Description],po.[JV Description]) = 'Ticketek'  THEN 'Ticketek'

        WHEN ds.[Domain Country] IN ('AU','NZ') AND ds.[Product Code] IN ('CMC')                    THEN 'Corporate'
        WHEN ds.[Domain Country] IN ('AU')      AND ds.[Product Code] IN ('FCI','BJD','ABD','CTD')  THEN 'FCI + Coles'
        WHEN ds.[Domain Country] IN ('AU')      AND ds.[Product Code] IN ('ATO','ATR','VAR')        THEN 'Virgin'
        WHEN ds.[Domain Country] IN ('AU')      AND ds.[Product Code] IN ('RCP')                    THEN 'Halo'
        WHEN ds.[Domain Country] IN ('AU','NZ') AND ds.[Product Code] IN ('WDI','WTI','WD2','WT2')  THEN 'Webjet'


        WHEN ds.[Domain Country] IN ('AU') AND ds.[Plan Type] = 'Domestic' AND ds.[Product Code] = 'FYE'        THEN 'Domestic Canx'
        WHEN ds.[Domain Country] IN ('AU') AND ds.[Plan Type] = 'Domestic' AND ds.[Trip Type] = 'Cancellation'  THEN 'Domestic Canx'

        WHEN ds.[Domain Country] IN ('NZ') AND ds.[Product Code] IN ('AID','ANR')                               THEN 'ANZ + Domestic Canx'
        WHEN ds.[Domain Country] IN ('NZ') AND ds.[Plan Type] = 'Domestic' AND ds.[Trip Type] = 'Cancellation'  THEN 'ANZ + Domestic Canx'

        WHEN COALESCE(do.[JV Description],po.[JV Description]) IN ('CBA NAC','BW NAC') THEN 'NAC'

        ELSE 'GLM'
     END AS [UW Rating Group]
    ,uw.[JV_Description_Orig]      AS [UW JV Description Orig]
    ,uw.[JV_Group]                 AS [UW JV Group]
    ,uw.[Product_Code]             AS [UW Product Code]

    ,COALESCE(do.[Outlet Name]              ,po.[Outlet Name])              AS [Outlet Name]
    ,COALESCE(do.[Outlet Sub Group Code]    ,po.[Outlet Sub Group Code])    AS [Outlet Sub Group Code]
    ,COALESCE(do.[Outlet Sub Group Name]    ,po.[Outlet Sub Group Name])    AS [Outlet Sub Group Name]
    ,COALESCE(do.[Outlet Group Code]        ,po.[Outlet Group Code])        AS [Outlet Group Code]
    ,COALESCE(do.[Outlet Group Name]        ,po.[Outlet Group Name])        AS [Outlet Group Name]
    ,COALESCE(do.[Outlet Super Group]       ,po.[Outlet Super Group])       AS [Outlet Super Group]
    ,COALESCE(do.[Outlet Channel]           ,po.[Outlet Channel])           AS [Outlet Channel]
    ,COALESCE(do.[Outlet BDM]               ,po.[Outlet BDM])               AS [Outlet BDM]
    ,COALESCE(do.[Outlet Post Code]         ,po.[Outlet Post Code])         AS [Outlet Post Code]
    ,COALESCE(do.[Outlet Sales State Area]  ,po.[Outlet Sales State Area])  AS [Outlet Sales State Area]
    ,COALESCE(do.[Outlet Trading Status]    ,po.[Outlet Trading Status])    AS [Outlet Trading Status]
    ,COALESCE(do.[Outlet Type]              ,po.[Outlet Type])              AS [Outlet Type]

    ,COALESCE(do.[JV Code]                  ,po.[JV Code])                  AS [JV Code]
    ,COALESCE(do.[JV Description]           ,po.[JV Description])           AS [JV Description]
    
    ,CASE 
        WHEN ds.[Company] = 'TIP' AND (ds.[Issue Date] >= '2017-06-01' OR (ds.[Alpha Code] IN ('APN0004', 'APN0005') AND ds.[Issue Date] >= '2017-07-01')) THEN 'TIP-ZURICH'
        WHEN ds.[Company] = 'TIP' AND (ds.[Issue Date] <  '2017-06-01' OR (ds.[Alpha Code] IN ('APN0004', 'APN0005') AND ds.[Issue Date] <  '2017-07-01')) THEN 'TIP-GLA'

        WHEN ds.[Domain Country] IN ('AU','NZ') AND ds.[Issue Date] >= '2017-06-01'                                    THEN 'ZURICH'
        WHEN ds.[Domain Country] IN ('AU','NZ') AND ds.[Issue Date] >= '2009-07-01' and ds.[Issue Date] < '2017-06-01' THEN 'GLA'
        WHEN ds.[Domain Country] IN ('AU','NZ') AND ds.[Issue Date] <  '2009-07-01'                                    THEN 'VERO'

        WHEN ds.[Domain Country] IN ('UK') AND ds.[Issue Date] >= '2009-09-01' THEN 'ETI'
        WHEN ds.[Domain Country] IN ('UK') AND ds.[Issue Date] <  '2009-09-01' THEN 'UKU'

        WHEN ds.[Domain Country] IN ('CN')      THEN 'CCIC'
        WHEN ds.[Domain Country] IN ('ID')      THEN 'Simas Net'
        WHEN ds.[Domain Country] IN ('MY','SG') THEN 'ETIQA'
        WHEN ds.[Domain Country] IN ('US')      THEN 'AON'

        ELSE 'OTHER' 
     END AS Underwriter

    ,cl.[ClaimCount]
    ,cl.[SectionCount]
    ,cl.[NetIncurredMovementIncRecoveries]
    ,cl.[NetPaymentMovementIncRecoveries]

	,cl.[Sections MED]
	,cl.[Payments MED]
	,cl.[Incurred MED]
	,cl.[Sections MED_LGE]
	,cl.[Payments MED_LGE]
	,cl.[Incurred MED_LGE]

	,cl.[Sections CAN]
	,cl.[Payments CAN]
	,cl.[Incurred CAN]
	,cl.[Sections CAN_LGE]
	,cl.[Payments CAN_LGE]
	,cl.[Incurred CAN_LGE]

	--,cl.[Sections CFR]
	--,cl.[Payments CFR]
	--,cl.[Incurred CFR]
    --,cl.[Sections CFR_LGE]
    --,cl.[Payments CFR_LGE]
    --,cl.[Incurred CFR_LGE]

	,cl.[Sections ADD]
	,cl.[Payments ADD]
	,cl.[Incurred ADD]
	,cl.[Sections ADD_LGE]
	,cl.[Payments ADD_LGE]
	,cl.[Incurred ADD_LGE]

	,cl.[Sections MIS]
	,cl.[Payments MIS]
	,cl.[Incurred MIS]
	,cl.[Sections MIS_LGE]
	,cl.[Payments MIS_LGE]
	,cl.[Incurred MIS_LGE]

	,cl.[Sections CAT]
	,cl.[Payments CAT]
	,cl.[Incurred CAT]

	,cl.[Sections COV]
	,cl.[Payments COV]
	,cl.[Incurred COV]

	,cl.[Sections OTH]
	,cl.[Payments OTH]
	,cl.[Incurred OTH]

FROM DWHDataSetSummary     ds
OUTER APPLY (
    SELECT *
    FROM Regions dr
    WHERE ds.[Destination] = dr.[Destination]
    ) dr
OUTER APPLY (
    SELECT * 
    FROM UWPremium uw 
    WHERE ds.[PolicyKey]    = uw.[PolicyKey] AND 
          ds.[Product Code] = uw.[Product_Code]
    ) uw
OUTER APPLY (
    SELECT TOP 1 *
    FROM postcodes pc
    WHERE ds.[Customer Post Code] = pc.[postcode]
    ORDER BY [Count] DESC
    ) pc
OUTER APPLY (
    SELECT *
    FROM penPolicyTransSummary pt
    WHERE ds.[PolicyKey]    = pt.[PolicyKey]   AND 
          ds.[Product Code] = pt.[Product Code]
    ) pt
OUTER APPLY (
    SELECT TOP 1 *
    FROM Policy_Transactions tr
    WHERE tr.[Transaction Status] = 'Active'    AND
          ds.[PolicyKey]    = tr.[PolicyKey]    AND 
          ds.[Product Code] = tr.[Product Code]
    ORDER BY [Transaction Issue Date] DESC, [BIRowID] DESC
    ) tr
OUTER APPLY (
    SELECT *
    FROM penPolicy pp 
    WHERE ds.[PolicyKey]    = pp.[PolicyKey]   AND 
          ds.[Product Code] = pp.[Product Code]
    ) pp
OUTER APPLY (
    SELECT TOP 1 *
    FROM dimOutlet do 
    WHERE ds.[OutletKey] = do.[Outlet Key]
    ORDER BY [LoadDate] DESC
    ) do
OUTER APPLY (
    SELECT TOP 1 *
    FROM penOutlet po 
    WHERE ds.[OutletKey] = po.[Outlet Key]
    ORDER BY [OutletStartDate] DESC
    ) po
OUTER APPLY (
    SELECT *
    FROM claims cl 
    WHERE ds.[PolicyKey]    = cl.[PolicyKey] AND 
          ds.[Product Code] = cl.[Product Code]
        --COALESCE(do.[JV Code],po.[JV Code]) = cl.[JV Code]
    ) cl
OUTER APPLY (
    SELECT TOP 1 
         [Customer Policy Number]
        ,SUM([Gross Premium Exc Taxes]) AS [Gross Premium Exc Taxes]
        ,SUM([GST Cost])                AS [GST Cost]
        ,SUM([Stamp Duty])              AS [Stamp Duty]
        ,SUM([Gross Premium Inc Taxes]) AS [Gross Premium Inc Taxes]
    FROM [db-au-actuary].[dbo].[UK_Halo_SuperGroup] AS h
    WHERE h.[Customer Policy Number] = ds.[Base Policy No]
    GROUP BY [Customer Policy Number]
    ) h

WHERE ds.[Rank] = 1

--LEFT JOIN claims                cl ON ds.[Product Code] = cl.[Product Code]   AND ds.[PolicyKey] = cl.[PolicyKey]
--LEFT JOIN penPolicy             pp ON ds.[Product Code] = pp.[Product Code]   AND ds.[PolicyKey] = pp.[PolicyKey]
--LEFT JOIN penPolicyTransSummary pt ON ds.[Product Code] = pt.[Product Code]   AND ds.[PolicyKey] = pt.[PolicyKey]
--LEFT JOIN UWPremium             uw ON ds.[Product Code] = uw.[Product_Code]   AND ds.[PolicyKey] = uw.[PolicyKey]
--LEFT JOIN dimOutlet             do ON ds.[OutletKey]    = do.[Outlet Key]     AND do.[Rank] = 1
--LEFT JOIN penOutlet             po ON ds.[OutletKey]    = po.[Outlet Key]     AND po.[Rank] = 1
--LEFT JOIN postcodes             pc ON ds.[Customer Post Code] = pc.[postcode] AND pc.[Rank] = 1
;
GO
