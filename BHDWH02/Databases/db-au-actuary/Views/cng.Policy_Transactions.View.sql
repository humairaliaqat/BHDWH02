USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Transactions]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Transactions] AS 

WITH 
DWHDataSet AS (
    SELECT 
         [BIRowID]
        ,[Domain Country]
        ,[Company]
        ,[PolicyKey]
        ,[PolicyTransactionKey]
        ,[isParent]
        ,[Base Policy No]
        ,[Policy No]
        ,[Issue Date]
        ,[Transaction Issue Date]
        ,[Posting Date]
        ,[Transaction Type]
        ,[Policy Status]
        ,[Transaction Status]
        ,[Departure Date]
        ,[Return Date]
        ,[Lead Time]
        ,[Maximum Trip Length]
        ,[Trip Duration]
        ,[Trip Length]
        ,[Area Name]
        ,[Area Number]
        ,[Destination]
        ,[Excess]
        ,[Group Policy]
        ,[Has Rental Car]
        ,[Has Motorcycle]
        ,[Has Wintersport]
        ,[Has Medical]
        ,[Single/Family]
        ,[Purchase Path]
        ,[TRIPS Policy]
        ,[Product Code]
        ,[Plan Code]
        ,[Product Name]
        ,[Product Plan]
        ,[Product Type]
        ,[Product Group]
        ,[Policy Type]
        ,[Plan Type]
        ,[Trip Type]
        ,[Product Classification]
        ,[Finance Product Code]
        ,[OutletKey]
        ,[Alpha Code]
        ,[Original Alpha Code]
        ,[Transaction Alpha Code]
        ,[Transaction OutletKey]
        ,[Customer Post Code]
        ,[Unique Traveller Count]
        ,[Unique Charged Traveller Count]
        ,[Traveller Count]
        ,[Charged Traveller Count]
        ,[Adult Traveller Count]
        ,[EMC Traveller Count]
        ,[Youngest Charged DOB]
        ,[Oldest Charged DOB]
        ,[Youngest Age]
        ,[Oldest Age]
        ,[Youngest Charged Age]
        ,[Oldest Charged Age]
        ,[Max EMC Score]
        ,[Total EMC Score]
        ,[Charged Traveller 1 Gender]
        ,[Charged Traveller 1 DOB]
        ,[Charged Traveller 1 Has EMC]
        ,[Charged Traveller 1 Has Manual EMC]
        ,[Charged Traveller 1 EMC Score]
        ,[Charged Traveller 1 EMC Reference]
        ,[Charged Traveller 2 Gender]
        ,[Charged Traveller 2 DOB]
        ,[Charged Traveller 2 Has EMC]
        ,[Charged Traveller 2 Has Manual EMC]
        ,[Charged Traveller 2 EMC Score]
        ,[Charged Traveller 2 EMC Reference]
        ,[Charged Traveller 3 Gender]
        ,[Charged Traveller 3 DOB]
        ,[Charged Traveller 3 Has EMC]
        ,[Charged Traveller 3 Has Manual EMC]
        ,[Charged Traveller 3 EMC Score]
        ,[Charged Traveller 3 EMC Reference]
        ,[Charged Traveller 4 Gender]
        ,[Charged Traveller 4 DOB]
        ,[Charged Traveller 4 Has EMC]
        ,[Charged Traveller 4 Has Manual EMC]
        ,[Charged Traveller 4 EMC Score]
        ,[Charged Traveller 4 EMC Reference]
        ,[Charged Traveller 5 Gender]
        ,[Charged Traveller 5 DOB]
        ,[Charged Traveller 5 Has EMC]
        ,[Charged Traveller 5 Has Manual EMC]
        ,[Charged Traveller 5 EMC Score]
        ,[Charged Traveller 5 EMC Reference]
        ,[Charged Traveller 6 Gender]
        ,[Charged Traveller 6 DOB]
        ,[Charged Traveller 6 Has EMC]
        ,[Charged Traveller 6 Has Manual EMC]
        ,[Charged Traveller 6 EMC Score]
        ,[Charged Traveller 6 EMC Reference]
        ,[Charged Traveller 7 Gender]
        ,[Charged Traveller 7 DOB]
        ,[Charged Traveller 7 Has EMC]
        ,[Charged Traveller 7 Has Manual EMC]
        ,[Charged Traveller 7 EMC Score]
        ,[Charged Traveller 7 EMC Reference]
        ,[Charged Traveller 8 Gender]
        ,[Charged Traveller 8 DOB]
        ,[Charged Traveller 8 Has EMC]
        ,[Charged Traveller 8 Has Manual EMC]
        ,[Charged Traveller 8 EMC Score]
        ,[Charged Traveller 8 EMC Reference]
        ,[Charged Traveller 9 Gender]
        ,[Charged Traveller 9 DOB]
        ,[Charged Traveller 9 Has EMC]
        ,[Charged Traveller 9 Has Manual EMC]
        ,[Charged Traveller 9 EMC Score]
        ,[Charged Traveller 9 EMC Reference]
        ,[Charged Traveller 10 Gender]
        ,[Charged Traveller 10 DOB]
        ,[Charged Traveller 10 Has EMC]
        ,[Charged Traveller 10 Has Manual EMC]
        ,[Charged Traveller 10 EMC Score]
        ,[Charged Traveller 10 EMC Reference]
        ,[Commission Tier]
        ,[Volume Commission]
        ,[Discount]
        ,[Base Base Premium]
        ,[Base Premium]
        ,[Canx Premium]
        ,[Undiscounted Canx Premium]
        ,[Rental Car Premium]
        ,[Motorcycle Premium]
        ,[Luggage Premium]
        ,[Medical Premium]
        ,[Winter Sport Premium]
        ,[Luggage Increase]
        ,[Rental Car Increase]
        ,[Trip Cost]
        ,[Unadjusted Sell Price]
        ,[Unadjusted GST on Sell Price]
        ,[Unadjusted Stamp Duty on Sell Price]
        ,[Unadjusted Agency Commission]
        ,[Unadjusted GST on Agency Commission]
        ,[Unadjusted Stamp Duty on Agency Commission]
        ,[Unadjusted Admin Fee]
        ,[Sell Price]
        ,[GST on Sell Price]
        ,[Stamp Duty on Sell Price]
        ,[Premium]
        ,[Risk Nett]
        ,[GUG]
        ,[Agency Commission]
        ,[GST on Agency Commission]
        ,[Stamp Duty on Agency Commission]
        ,[Admin Fee]
        ,[NAP]
        ,[NAP (incl Tax)]
        ,[Policy Count]
        ,[Price Beat Policy]
        ,[Competitor Name]
        ,[Competitor Price]
        ,[PolicyID]
        ,[Category]
        ,[EMC Tier Oldest Charged]
        ,[EMC Tier Youngest Charged]
        ,[Has Cruise]
        ,[Cruise Premium]
        ,[Plan Name]
    FROM [db-au-actuary].[ws].[DWHDataSet]     --WHERE [Domain Country] IN ('AU','NZ')
    UNION ALL
    SELECT 
         [BIRowID]
        ,[Domain Country]
        ,[Company]
        ,[PolicyKey]
        ,[PolicyTransactionKey]
        ,[isParent]
        ,[Base Policy No]
        ,[Policy No]
        ,[Issue Date]
        ,[Transaction Issue Date]
        ,[Posting Date]
        ,[Transaction Type]
        ,[Policy Status]
        ,[Transaction Status]
        ,[Departure Date]
        ,[Return Date]
        ,[Lead Time]
        ,[Maximum Trip Length]
        ,[Trip Duration]
        ,[Trip Length]
        ,[Area Name]
        ,[Area Number]
        ,[Destination]
        ,[Excess]
        ,[Group Policy]
        ,[Has Rental Car]
        ,[Has Motorcycle]
        ,[Has Wintersport]
        ,[Has Medical]
        ,[Single/Family]
        ,[Purchase Path]
        ,[TRIPS Policy]
        ,[Product Code]
        ,[Plan Code]
        ,[Product Name]
        ,[Product Plan]
        ,[Product Type]
        ,[Product Group]
        ,[Policy Type]
        ,[Plan Type]
        ,[Trip Type]
        ,[Product Classification]
        ,[Finance Product Code]
        ,[OutletKey]
        ,[Alpha Code]
        ,[Original Alpha Code]
        ,[Transaction Alpha Code]
        ,[Transaction OutletKey]
        ,[Customer Post Code]
        ,[Unique Traveller Count]
        ,[Unique Charged Traveller Count]
        ,[Traveller Count]
        ,[Charged Traveller Count]
        ,[Adult Traveller Count]
        ,[EMC Traveller Count]
        ,[Youngest Charged DOB]
        ,[Oldest Charged DOB]
        ,[Youngest Age]
        ,[Oldest Age]
        ,[Youngest Charged Age]
        ,[Oldest Charged Age]
        ,[Max EMC Score]
        ,[Total EMC Score]
        ,[Charged Traveller 1 Gender]
        ,[Charged Traveller 1 DOB]
        ,[Charged Traveller 1 Has EMC]
        ,[Charged Traveller 1 Has Manual EMC]
        ,[Charged Traveller 1 EMC Score]
        ,[Charged Traveller 1 EMC Reference]
        ,[Charged Traveller 2 Gender]
        ,[Charged Traveller 2 DOB]
        ,[Charged Traveller 2 Has EMC]
        ,[Charged Traveller 2 Has Manual EMC]
        ,[Charged Traveller 2 EMC Score]
        ,[Charged Traveller 2 EMC Reference]
        ,[Charged Traveller 3 Gender]
        ,[Charged Traveller 3 DOB]
        ,[Charged Traveller 3 Has EMC]
        ,[Charged Traveller 3 Has Manual EMC]
        ,[Charged Traveller 3 EMC Score]
        ,[Charged Traveller 3 EMC Reference]
        ,[Charged Traveller 4 Gender]
        ,[Charged Traveller 4 DOB]
        ,[Charged Traveller 4 Has EMC]
        ,[Charged Traveller 4 Has Manual EMC]
        ,[Charged Traveller 4 EMC Score]
        ,[Charged Traveller 4 EMC Reference]
        ,[Charged Traveller 5 Gender]
        ,[Charged Traveller 5 DOB]
        ,[Charged Traveller 5 Has EMC]
        ,[Charged Traveller 5 Has Manual EMC]
        ,[Charged Traveller 5 EMC Score]
        ,[Charged Traveller 5 EMC Reference]
        ,[Charged Traveller 6 Gender]
        ,[Charged Traveller 6 DOB]
        ,[Charged Traveller 6 Has EMC]
        ,[Charged Traveller 6 Has Manual EMC]
        ,[Charged Traveller 6 EMC Score]
        ,[Charged Traveller 6 EMC Reference]
        ,[Charged Traveller 7 Gender]
        ,[Charged Traveller 7 DOB]
        ,[Charged Traveller 7 Has EMC]
        ,[Charged Traveller 7 Has Manual EMC]
        ,[Charged Traveller 7 EMC Score]
        ,[Charged Traveller 7 EMC Reference]
        ,[Charged Traveller 8 Gender]
        ,[Charged Traveller 8 DOB]
        ,[Charged Traveller 8 Has EMC]
        ,[Charged Traveller 8 Has Manual EMC]
        ,[Charged Traveller 8 EMC Score]
        ,[Charged Traveller 8 EMC Reference]
        ,[Charged Traveller 9 Gender]
        ,[Charged Traveller 9 DOB]
        ,[Charged Traveller 9 Has EMC]
        ,[Charged Traveller 9 Has Manual EMC]
        ,[Charged Traveller 9 EMC Score]
        ,[Charged Traveller 9 EMC Reference]
        ,[Charged Traveller 10 Gender]
        ,[Charged Traveller 10 DOB]
        ,[Charged Traveller 10 Has EMC]
        ,[Charged Traveller 10 Has Manual EMC]
        ,[Charged Traveller 10 EMC Score]
        ,[Charged Traveller 10 EMC Reference]
        ,[Commission Tier]
        ,[Volume Commission]
        ,[Discount]
        ,[Base Base Premium]
        ,[Base Premium]
        ,[Canx Premium]
        ,[Undiscounted Canx Premium]
        ,[Rental Car Premium]
        ,[Motorcycle Premium]
        ,[Luggage Premium]
        ,[Medical Premium]
        ,[Winter Sport Premium]
        ,[Luggage Increase]
        ,[Rental Car Increase]
        ,[Trip Cost]
        ,[Unadjusted Sell Price]
        ,[Unadjusted GST on Sell Price]
        ,[Unadjusted Stamp Duty on Sell Price]
        ,[Unadjusted Agency Commission]
        ,[Unadjusted GST on Agency Commission]
        ,[Unadjusted Stamp Duty on Agency Commission]
        ,[Unadjusted Admin Fee]
        ,[Sell Price]
        ,[GST on Sell Price]
        ,[Stamp Duty on Sell Price]
        ,[Premium]
        ,[Risk Nett]
        ,[GUG]
        ,[Agency Commission]
        ,[GST on Agency Commission]
        ,[Stamp Duty on Agency Commission]
        ,[Admin Fee]
        ,[NAP]
        ,[NAP (incl Tax)]
        ,[Policy Count]
        ,[Price Beat Policy]
        ,[Competitor Name]
        ,[Competitor Price]
        ,[PolicyID]
        ,[Category]
        ,[EMC Tier Oldest Charged]
        ,[EMC Tier Youngest Charged]
        ,[Has Cruise]
        ,[Cruise Premium]
        ,[Plan Name]
    FROM [db-au-actuary].[ws].[DWHDataSet_CBA] --WHERE [Domain Country] IN ('AU','NZ')
),

penPolicyTransSummary AS (
    SELECT 
         [PolicyTransactionKey]
        ,[PolicyKey]
        ,[ProductCode]
        ,[BasePolicyCount]
        ,[AutoComments]
        ,[UserComments]
        ,[TopUp]
        ,[RefundToCustomer]
        ,[CNStatus]
        ,[PromoCode]
        ,[PromoName]
        ,[PromoType]
        ,[PromoDiscount]
        ,CASE WHEN [TopUp] = 1 AND [BasePolicyCount] = -1 THEN 0 ELSE [BasePolicyCount] END AS [Policy Count Fix]
    FROM [db-au-actuary].[cng].[penPolicyTransSummary] --[ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]
),

penPolicy AS (
    SELECT 
         [PolicyKey]
        ,[PolicyNumber]
        ,[ProductCode]
        ,[TripStart]
        ,[TripEnd]
    FROM [db-au-actuary].[cng].[penPolicy]
),

dimOutlet AS (
    SELECT 
         --ROW_NUMBER() OVER (PARTITION BY [OutletKey] ORDER BY [LoadDate] DESC) AS [Rank]
         [LoadDate]
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
         --ROW_NUMBER() OVER (PARTITION BY [OutletKey] ORDER BY [OutletStartDate] DESC) AS [Rank]
         [OutletStartDate]
        ,[OutletKey]        AS [Outlet Key]
        ,[OutletName]       AS [Outlet Name]
        ,[SubGroupCode]     AS [Outlet Sub Group Code]
        ,[SubGroupName]     AS [Outlet Sub Group Name]
        ,[GroupCode]        AS [Outlet Group Code]
        ,[GroupName]        AS [Outlet Group Name]
        ,[SuperGroupName]   AS [Outlet Super Group]
        ,''                 AS [Outlet Channel]
        ,[BDMName]          AS [Outlet BDM]
        ,[ContactPostCode]  AS [Outlet Post Code]
        ,[StateSalesArea]   AS [Outlet Sales State Area]
        ,[TradingStatus]    AS [Outlet Trading Status]
        ,[OutletType]       AS [Outlet Type]
        ,[JVCode]           AS [JV Code]
        ,[JV]               AS [JV Description]
    FROM  [db-au-actuary].[cng].[penOutlet]
    WHERE [OutletStatus] = 'Current'
)

SELECT 
     ds.*

    ,CASE WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND COALESCE(do.[JV Description],po.[JV Description]) IN ('CBA NAC','CBA WL','BW NAC','BW WL')
          THEN 0
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND COALESCE(do.[Outlet Super Group],po.[Outlet Super Group]) IN ('Easy Travel Insurance')
          THEN 0
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Code] IN ('APB','APC','API','APP','CMY','CTD','CTI','HIF','IAL','NRI','RCP','STY','SYC','SYE','TTI','VAR')
          THEN 0          
          WHEN ds.[Domain Country] ='AU' AND CAST(ds.[Issue Date] as date) >= '2020-12-09' AND ds.[Product Code] IN ('ABD','ABI','ABW','AHM','AIN','AIO','AIR','AIW','ANB','ANC','ANF','ATO','ATR','AWT','BCR','BJD',
                                                                                                                     'BJI','BJW','CBI','CCP','CCR','CHH','CMB','CMC','CMH','CMI','CMO','CMT','CMW','CPC','DII','DIT',
                                                                                                                     'DTP','DTS','FCC','FCI','FCO','FCT','FPG','FPP','FY2','FYE','FYI','FYP','GMC','GTS','HBC','HCC',
                                                                                                                     'HPC','ICC','IEC','MBC','MBM','MHA','MNC','MNM','NCC','NPG','NPP','OHT','PCR','TMT','VAI','VAS',
                                                                                                                     'VAW','VBC','VDC','VTC','VTI','WDI','WII','WJP','WJS','WTI')
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

    ,pt.[AutoComments]
    ,pt.[UserComments]
    ,pt.[TopUp]
    ,pt.[RefundToCustomer]
    ,pt.[CNStatus]
    ,pt.[Policy Count Fix]

	,COALESCE(pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ) AS [TripStart]
    ,COALESCE(pp.[TripEnd]  ,ds.[Return Date]   ,DATEADD(year,1,ds.[Issue Date])) AS [TripEnd]
    ,CASE WHEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                )) > 0
          THEN DATEDIFF(DAY,ds.[Issue Date],COALESCE(pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ))   
          ELSE 0
     END AS [LeadTime]
    ,CASE WHEN DATEDIFF(DAY,COALESCE(pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ),COALESCE(pp.[TripEnd]  ,ds.[Return Date]   ,DATEADD(year,1,ds.[Issue Date]))) + 1 > 0
          THEN DATEDIFF(DAY,COALESCE(pp.[TripStart],ds.[Departure Date],ds.[Issue Date]                ),COALESCE(pp.[TripEnd]  ,ds.[Return Date]   ,DATEADD(year,1,ds.[Issue Date]))) + 1
          ELSE 0
     END AS [TripDuration]

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

    ,[Sell Price] AS [Sell Price - Total]

    ,CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Sell Price] ELSE 0 END AS [Sell Price - Active]
    ,CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END AS [Sell Price - Active Base]
    ,CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END AS [Sell Price - Active Extension]

    ,CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Sell Price] ELSE 0 END AS [Sell Price - Cancelled]
    ,CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END AS [Sell Price - Cancelled Base]
    ,CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END AS [Sell Price - Cancelled Extension]

    ,[Premium] AS [Premium - Total]

    ,CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Premium] ELSE 0 END AS [Premium - Active]
    ,CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END AS [Premium - Active Base]
    ,CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END AS [Premium - Active Extension]

    ,CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Premium] ELSE 0 END AS [Premium - Cancelled]
    ,CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END AS [Premium - Cancelled Base]
    ,CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END AS [Premium - Cancelled Extension]

    ,pt.[PromoCode]        AS [Promo Code]
    ,pt.[PromoName]        AS [Promo Name]
    ,pt.[PromoType]        AS [Promo Type]
    ,pt.[PromoDiscount]    AS [Promo Discount]

FROM DWHDataSet ds
OUTER APPLY (
    SELECT * 
    FROM penPolicyTransSummary pt 
    WHERE ds.[PolicyTransactionKey] = pt.[PolicyTransactionKey] AND 
          ds.[Product Code]         = pt.[ProductCode]) pt
OUTER APPLY (
    SELECT * 
    FROM penPolicy pp 
    WHERE ds.[PolicyKey]    = pp.[PolicyKey] AND 
          ds.[Product Code] = pp.[ProductCode]) pp
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
;
GO
