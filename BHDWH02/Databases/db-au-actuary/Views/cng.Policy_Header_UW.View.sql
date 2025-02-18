USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_UW]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_UW] AS 

WITH 
Policy_Header_01 AS (
    SELECT *
    FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]
    WHERE [Underwriter] IN ('Zurich','TIP-ZURICH') AND [JV Description] NOT IN ('CBA NAC','BW NAC','BW WL')
),

Policy_Header_02 AS (
    SELECT a.*
        --UW Region
        ,CASE
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('AUSTRALIA','AUSTRALIA INBOUND') THEN 'Australia'
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('NEW ZEALAND')                   THEN 'Domestic'
            WHEN a.[Destination] IS NULL                                                          THEN 'World Others'
            ELSE LEFT([UW_Destination_2017],COALESCE(NULLIF(CHARINDEX('-',[UW_Destination_2017])-1,-1),LEN([UW_Destination_2017]))) 
         END AS [UW Region]

         --UW Destination 2017
        ,CASE
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('AUSTRALIA','AUSTRALIA INBOUND') THEN 'Australia'
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('NEW ZEALAND')                   THEN 'Domestic-NEW ZEALAND'
            WHEN a.[Destination] IS NULL                                                          THEN 'World Others'
            ELSE [UW_Destination_2017] 
         END AS [UW Destination 2017]

         --UW Destination 2021
        ,CASE
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('AUSTRALIA','AUSTRALIA INBOUND') THEN 'Australia-AUSTRALIA'
            WHEN [Domain Country] = 'NZ' AND a.[Destination] IN ('NEW ZEALAND')                   THEN 'Domestic'
            WHEN a.[Destination] IS NULL                                                          THEN 'World Others'
            ELSE [UW_Destination_2021] 
         END AS [UW Destination 2021]

    FROM      Policy_Header_01 a
    LEFT JOIN [db-au-actuary].[cng].[UW_Destinations_2021] b ON a.[Destination] = b.[Destination]
),

Policy_Header_03 AS (
    SELECT *
        --UW Destination 2021 Scale Group
        ,CASE
            WHEN [UW Destination 2021] = 'Domestic'                 THEN 'Domestic'
            WHEN [UW Destination 2021] = 'Australia-AUSTRALIA'      THEN 'Trans-Tasman'
            WHEN [UW Destination 2021] = 'New Zealand-NEW ZEALAND'  THEN 'Trans-Tasman'
            WHEN [UW Destination 2021] = 'SEA-SINGAPORE'            THEN 'Singapore'
                                                                    ELSE 'World'
         END AS [UW Destination 2021 Scale]

        --UW Destination 2021 Flex Group
        ,CASE
            WHEN [Domain Country] = 'AU' AND [UW Destination 2021] = 'Domestic'                 THEN 'AU Domestic'
            WHEN [Domain Country] = 'AU' AND [UW Destination 2021] = 'New Zealand-NEW ZEALAND'  THEN 'AU Trans-Tasman'
            WHEN [Domain Country] = 'AU'                                                        THEN 'AU Rest of World'
            WHEN [Domain Country] = 'NZ' AND [UW Destination 2021] = 'Domestic'                 THEN 'NZ Domestic'
            WHEN [Domain Country] = 'NZ' AND [UW Destination 2021] = 'Australia-AUSTRALIA'      THEN 'NZ Trans-Tasman'
            WHEN [Domain Country] = 'NZ'                                                        THEN 'NZ Rest of World'
         END AS [UW Destination 2021 Flex]

        --,CASE
        --    WHEN [Domain Country] = 'AU' AND [UW Destination 2021] = 'Domestic'                 THEN 'AU Domestic'
        --    WHEN [Domain Country] = 'AU'                                                        THEN 'AU International'
        --    WHEN [Domain Country] = 'NZ' AND [UW Destination 2021] = 'Domestic'                 THEN 'NZ Domestic'
        --    WHEN [Domain Country] = 'NZ'                                                        THEN 'NZ International'
        -- END AS [UW Destination 2021 Group]

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

        --EMC Multiplier
        ,CASE
            WHEN [Destination] IN (
                 'INDONESIA'
                ,'INDONESIA (BALI)'
                )
            THEN 1.0

            WHEN [UW Region] IN (
                 'Domestic'
                ,'Australia'
                ,'New Zealand'
                ,'Pacific Region'
                )
            THEN 1.0

            WHEN [UW Region] IN (
                 'SEA'
                ,'South Asia'
                ,'East Asia'
                ,'Asia Others'
                ,'Africa'
                ,'Europe'
                )
            THEN 1.2

            WHEN [UW Region] IN (
                 'Mid East'
                ,'North America'
                ,'South America'
                ,'America Others'
                ,'World Others'
                )
            THEN 1.5

         END AS [UW EMC Multiplier]

    FROM Policy_Header_02
)

SELECT
     [Domain Country]
    ,[Company]
    ,[PolicyKey]
    ,[Base Policy No]

    ,[Policy Status]
    ,[Policy Status] AS [UW Policy Status]

    ,[Sell Price]
    ,[Premium]
    ,[NAP]
    ,[UW Premium]                   AS [UW Premium Actual]
    ,[UW Premium COVID19]           AS [UW Premium COVID19 Actual]
    ,[UW Premium COVID19 Estimate]  AS [UW Premium COVID19 Score]

    ,[Issue Date]
    ,DATEPART(mm,[Issue Date])  AS [UW Issue Month]
    ,DATEPART(qq,[Issue Date])  AS [UW Issue Quarter]
    ,DATEPART(yy,[Issue Date])  AS [UW Issue Year]

    ,[Departure Date]
    ,MONTH([Departure Date])    AS [UW Departure Month]

    ,[Return Date]
    --,DATEADD(mm,DATEDIFF(mm,0,[Return Date]),0) AS [UW Return Month]
    ,CONVERT(nvarchar(6),[Return Date],112) AS [UW Return Month]
    ,YEAR([Return Date])                    AS [UW Return Year]

    ,[Product Code]
    ,[Finance Product Code]
    ,[Product Plan]
    ,[Policy Type]
    ,[Plan Type]
    ,[Trip Type]
    ,[Product Classification]
    ,[Outlet Channel]
    ,[Outlet Super Group]

    --Rating Group
    ,CASE 
        WHEN [Domain Country] IN ('AU','NZ') AND [JV Description] = 'Ticketek'                  THEN 'Ticketek'

        WHEN [Domain Country] IN ('AU','NZ') AND [Product Code] IN ('CMC')                      THEN 'Corporate'
        WHEN [Domain Country] IN ('AU')      AND [Product Code] IN ('FCI','BJD','ABD','CTD')    THEN 'FCI + Coles'
        WHEN [Domain Country] IN ('AU')      AND [Product Code] IN ('ATO','ATR','VAR')          THEN 'Virgin'
        WHEN [Domain Country] IN ('AU')      AND [Product Code] IN ('RCP')                      THEN 'Halo'
        WHEN [Domain Country] IN ('AU','NZ') AND [Product Code] IN ('WDI','WTI','WD2','WT2')    THEN 'Webjet'
        
        WHEN [Domain Country] IN ('AU') AND [Plan Type] = 'Domestic' AND [Product Code] = 'FYE' AND CAST([Issue Date] as date) >='2018-06-01'  THEN 'Domestic Canx'
        WHEN [Domain Country] IN ('AU') AND [Plan Type] = 'Domestic' AND [Trip Type] = 'Cancellation'                                          THEN 'Domestic Canx'

        WHEN [Domain Country] IN ('NZ') AND [Product Code] IN ('AID','ANR')                            THEN 'ANZ + Domestic Canx'
        WHEN [Domain Country] IN ('NZ') AND [Plan Type] = 'Domestic' AND [Trip Type] = 'Cancellation'  THEN 'ANZ + Domestic Canx'

        ELSE 'GLM'
     END AS [UW Rating Group]

    --Product Indicator
    ,CASE
        WHEN [Policy Type] = 'Business'     THEN 'International AMT'
        WHEN [Policy Type] = 'Corporate'    THEN 'Corporate'
        WHEN [Policy Type] = 'Event'        THEN 'Event'
        WHEN [Policy Type] = 'Car Hire'     THEN 'Car Hire'
        WHEN [Trip Type]   = 'Car Hire'     THEN 'Car Hire'

        WHEN [Product Code] = 'FYE' AND [Plan Type] = 'Domestic' AND CAST([Issue Date] as date) >='2018-06-01'              THEN 'Domestic Cancellation'
        WHEN [Product Code] = 'PNO' AND [Domain Country] = 'NZ'                                                             THEN 'Domestic Single Trip'

        WHEN [Plan Type] = 'Domestic Inbound'                                                                               THEN 'Domestic Inbound'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'AMT'                                                          THEN 'Domestic AMT'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Cancellation'                                                 THEN 'Domestic Cancellation'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Single Trip' AND [Outlet Channel] = 'Integrated'              THEN 'Domestic Single Trip Integrated'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Single Trip'                                                  THEN 'Domestic Single Trip'

        WHEN [Plan Type] = 'International' AND [Trip Type] = 'AMT'                                                          THEN 'International AMT'
        WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Outlet Channel] = 'Integrated'              THEN 'International Single Trip Integrated'
        WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Comprehensive'   THEN 'International Single Trip Comprehensive'
        WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip'                                                  THEN 'International Single Trip Standard'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Standard'        THEN 'International Single Trip Standard'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Value'           THEN 'International Single Trip Standard'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Business'        THEN 'International Single Trip Standard'
        
        ELSE 'Others'
     END AS [UW Product Indicator 2017]

    ,CASE
        WHEN [Policy Type] = 'Business'     THEN 'International AMT'
        WHEN [Policy Type] = 'Corporate'    THEN 'Corporate'
        WHEN [Policy Type] = 'Event'        THEN 'Event'
        WHEN [Policy Type] = 'Car Hire'     THEN 'Car Hire'
        WHEN [Trip Type]   = 'Car Hire'     THEN 'Car Hire'

        WHEN [Product Code] = 'FYE' AND [Plan Type] = 'Domestic' AND CAST([Issue Date] as date) >='2018-06-01'              THEN 'Domestic Cancellation'
        WHEN [Product Code] = 'PNO' AND [Domain Country] = 'NZ'                                                             THEN 'Domestic Single Trip'

        WHEN [Plan Type] = 'Domestic Inbound'                                                                               THEN 'Domestic Inbound'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'AMT'                                                          THEN 'Domestic AMT'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Cancellation'                                                 THEN 'Domestic Cancellation'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Single Trip' AND [Outlet Channel] = 'Integrated'              THEN 'Domestic Single Trip Integrated'
        WHEN [Plan Type] = 'Domestic'      AND [Trip Type] = 'Single Trip'                                                  THEN 'Domestic Single Trip'

        WHEN [Plan Type] = 'International' AND [Trip Type] = 'AMT'                                                          THEN 'International AMT'
        WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Outlet Channel] = 'Integrated'              THEN 'International Single Trip Integrated'
        WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip'                                                  THEN 'International Single Trip'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Comprehensive'   THEN 'International Single Trip Comprehensive'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Standard'        THEN 'International Single Trip Standard'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Value'           THEN 'International Single Trip Standard'
      --WHEN [Plan Type] = 'International' AND [Trip Type] = 'Single Trip' AND [Product Classification] = 'Business'        THEN 'International Single Trip Standard'

        ELSE 'Others'
     END AS [UW Product Indicator 2021]

    --JV Description
    ,[JV Description]

    ,CASE
        WHEN [JV Description] = 'Webjet' AND [Product Code] IN ('WII','WI2','WJP','WJS')    THEN 'Websales'
        WHEN [JV Description] = 'Integration'       AND [Domain Country] = 'NZ'             THEN 'Indep + Others'
        WHEN [JV Description] = 'Malaysia Airlines' AND [Domain Country] = 'NZ'             THEN 'Virgin'
        WHEN [JV Description] = 'AHM - Medibank'                                            THEN 'Medibank'
        WHEN [JV Description] = 'BW WL'                                                     THEN 'Flight Centre'
        WHEN [JV Description] = 'CBA WL'                                                    THEN 'Flight Centre'
        WHEN [JV Description] = 'Gold Coast Suns'                                           THEN 'Non Travel Agency - Dist'
        WHEN [JV Description] = 'HelloWorld'                                                THEN 'Helloworld'
        WHEN [JV Description] = 'Helloworld Integrated'                                     THEN 'Helloworld'
        WHEN [JV Description] = 'White Label Platform'                                      THEN 'Helloworld'
        WHEN [JV Description] = 'Independents'                                              THEN 'Indep + Others'
        WHEN [JV Description] = 'Integration'                                               THEN 'Malaysia Airlines'
        ELSE [JV Description]
     END AS [UW JV Description 2017]

    ,CASE
        WHEN [JV Description] = 'Webjet' AND [Product Code] IN ('WII','WI2','WJP','WJS')    THEN 'Websales'
        WHEN [JV Description] = 'Integration'       AND [Domain Country] = 'NZ'             THEN 'Indep + Others'
      --WHEN [JV Description] = 'Malaysia Airlines' AND [Domain Country] = 'NZ'             THEN 'Virgin'
      --WHEN [JV Description] = 'AHM - Medibank'                                            THEN 'Medibank'
        WHEN [JV Description] = 'BW WL'                                                     THEN 'CBA White Label'
        WHEN [JV Description] = 'CBA WL'                                                    THEN 'CBA White Label'
      --WHEN [JV Description] = 'Gold Coast Suns'                                           THEN 'Non Travel Agency - Dist'
        WHEN [JV Description] = 'HelloWorld'                                                THEN 'Helloworld'
        WHEN [JV Description] = 'Helloworld Integrated'                                     THEN 'Helloworld'
        WHEN [JV Description] = 'White Label Platform'                                      THEN 'Helloworld'
        WHEN [JV Description] = 'Independents'                                              THEN 'Indep + Others'
      --WHEN [JV Description] = 'Integration'                                               THEN 'Malaysia Airlines'
        ELSE [JV Description]
     END AS [UW JV Description 2021]

    --Latest Product
    ,IIF([Product Code] IN ('FCO','FCT','NCC'),[Product Code],'Y') AS [UW Latest Product]
    ,IIF([Product Code] IN ('FYP','FYE','ICC'),[Product Code],'Y') AS [UW Old Product]

    --Lead time
    ,[Lead Time]
    ,CASE
        WHEN                       [Lead Time] <=   0   THEN 0
        WHEN [Lead Time] >   0 AND [Lead Time] <= 181   THEN [Lead Time]
        WHEN [Lead Time] > 181 AND [Lead Time] <= 545   THEN (FLOOR([Lead Time]/7.00)+1)*7-1
        WHEN [Lead Time] > 545                          THEN 552
        ELSE NULL
    END AS [UW Lead Time]

    --Trip Length
    --,[Trip Length]
    --,CASE
    --    WHEN                         [Trip Length] <=   0   THEN 1
    --    WHEN [Trip Length] >   0 AND [Trip Length] <=  90   THEN [Trip Length]
    --    WHEN [Trip Length] >  90 AND [Trip Length] <= 363   THEN (FLOOR([Trip Length]/7.00)+1)*7-1
    --    WHEN [Trip Length] > 363 AND [Trip Length] <= 366   THEN 365
    --    WHEN [Trip Length] > 366                            THEN 370
    --    ELSE NULL
    --END AS [UW Trip Length]

    --Trip Length
    ,[Trip Length]
    ,[Trip Duration]
    ,CASE 
        WHEN [Last Transaction Posting Date] <= '2020-02-28' THEN CASE
            WHEN                         [Trip Length] <=   0   THEN 1
            WHEN [Trip Length] >   0 AND [Trip Length] <=  90   THEN [Trip Length]
            WHEN [Trip Length] >  90 AND [Trip Length] <= 363   THEN (FLOOR([Trip Length]/7.00)+1)*7-1
            WHEN [Trip Length] > 363 AND [Trip Length] <= 366   THEN 365
            WHEN [Trip Length] > 366                            THEN 370
            ELSE NULL END
        WHEN [Last Transaction Posting Date] >  '2020-02-28' THEN CASE
            WHEN                           [Trip Duration] <=   0   THEN 1
            WHEN [Trip Duration] >   0 AND [Trip Duration] <=  90   THEN [Trip Duration]
            WHEN [Trip Duration] >  90 AND [Trip Duration] <= 363   THEN (FLOOR([Trip Duration]/7.00)+1)*7-1
            WHEN [Trip Duration] > 363 AND [Trip Duration] <= 366   THEN 365
            WHEN [Trip Duration] > 366                              THEN 370
            ELSE NULL END
    END AS [UW Trip Length]

    --Destination
    ,[Destination]
    ,[UW Region]
    ,[UW Destination 2017]
    ,[UW Destination 2021]
    ,[UW Destination 2021 Scale]
    ,[UW Destination 2021 Flex]

    --Traveller Count
    ,[Traveller Count]
    ,CASE
        WHEN [Traveller Count] <  1 THEN  1
        WHEN [Traveller Count] > 10 THEN 10
        ELSE [Traveller Count]
     END AS [UW Traveller Count]

    --Oldest Age
    ,[Oldest Charged DOB]
    ,[Oldest Charged Age]
    ,CASE 
        WHEN [JV Description] = 'Air New Zealand' AND [Oldest Charged Age] =  0 AND CAST([Oldest Charged DOB] as date) IN ('2018-01-01','2019-01-01','2020-01-01','2021-01-01')                                         THEN -1
        WHEN [JV Description] = 'Air New Zealand' AND [Oldest Charged Age] = 17 AND CAST([Oldest Charged DOB] as date) IN ('1998-01-01','1999-01-01','2000-01-01','2001-01-01','2002-01-01','2003-01-01','2004-01-01')  THEN -1
        WHEN [JV Description] = 'Virgin'                                        AND CAST([Oldest Charged DOB] as date) IN ('1901-01-01','1989-01-01','2016-01-01','2017-01-01','2018-01-01','2019-01-01')               THEN -1
        WHEN [Oldest Charged Age] = -1                                  THEN -1
        WHEN [Oldest Charged Age] >= 0 AND [Oldest Charged Age] <= 12   THEN 12
        WHEN [Oldest Charged Age] > 90                                  THEN 90
        ELSE COALESCE([Oldest Charged Age],-1)
     END AS [UW Oldest Charged Age]

    --Gender
    ,[Gender]
    ,[Gender] AS [UW Gender]
    
    --EMC band
    ,[Highest EMC Score]
    ,[UW EMC Multiplier]
    ,CASE WHEN CAST([Issue Date] as date) >='2020-06-09' 
          THEN IIF(ROUND([Highest EMC Score]                    ,0)>8, 8, CAST(ROUND([Highest EMC Score]                    ,0) as int))
          ELSE IIF(ROUND([Highest EMC Score]/[UW EMC Multiplier],0)>8, 8, CAST(ROUND([Highest EMC Score]/[UW EMC Multiplier],0) as int))
     END AS [UW EMC Normalised]
    ,[EMC Traveller Count]
    ,[Charged Traveller Count]
    ,CAST(
     CASE WHEN CAST([Issue Date] as date) >='2020-06-09' 
          THEN IIF(ROUND([Highest EMC Score]                    ,0)>8, 8, CAST(ROUND([Highest EMC Score]                    ,0) as int))
          ELSE IIF(ROUND([Highest EMC Score]/[UW EMC Multiplier],0)>8, 8, CAST(ROUND([Highest EMC Score]/[UW EMC Multiplier],0) as int))
     END as varchar) 
     +
     IIF([EMC Traveller Count]*1.00/IIF([Charged Traveller Count]=0,[Traveller Count],[Charged Traveller Count])>0.5,'_>50%','_<50%') AS [UW EMC Band]

    --Excess
    ,[Excess]
    ,[Excess] AS [UW Excess]

    --Cruise
    ,[Has Cruise]

    --Ticketek Band
    ,[Sell Price]/[Charged Traveller Count] AS [Sell Price Per Traveller]
    ,CASE 
        WHEN [Domain Country] = 'AU' AND [JV Description] = 'Ticketek' THEN
        CASE 
            WHEN [Sell Price]/[Charged Traveller Count] =  0.00 THEN '$0'
            WHEN [Sell Price]/[Charged Traveller Count] <  5.00 THEN '$30'
            WHEN [Sell Price]/[Charged Traveller Count] <  7.00 THEN '$70'
            WHEN [Sell Price]/[Charged Traveller Count] <  9.00 THEN '$150'
            WHEN [Sell Price]/[Charged Traveller Count] = 11.99 THEN '$220'
            WHEN [Sell Price]/[Charged Traveller Count] = 17.45 THEN '$220'
            WHEN [Sell Price]/[Charged Traveller Count] = 15.99 THEN '$320'
            WHEN [Sell Price]/[Charged Traveller Count] = 21.45 THEN '$320'
            WHEN [Sell Price]/[Charged Traveller Count] = 19.99 THEN '$500'
            WHEN [Sell Price]/[Charged Traveller Count] = 24.99 THEN '$1500'
            WHEN [Sell Price]/[Charged Traveller Count] = 34.99 THEN '$Unlimited'
        END
     END AS [UW Ticket Band]

FROM Policy_Header_03
;
GO
