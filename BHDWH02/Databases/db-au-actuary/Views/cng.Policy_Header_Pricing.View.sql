USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_Pricing]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_Pricing] AS 
WITH 
[DWHDataSetSummary_01] AS (
    SELECT
         ph.[BIRowID]
        ,ph.[Domain Country]
        ,ph.[Company]
        ,ph.[PolicyKey]
        ,ph.[Base Policy No]
        ,ph.[Policy Status]
        ,ph.[Issue Date]
        ,ph.[Posting Date]
        ,ph.[Last Transaction Issue Date]
        ,ph.[Last Transaction posting Date]
        ,ph.[Transaction Type]
      --,ph.[Departure Date]
	    ,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]) AS [Departure Date]
      --,ph.[Return Date]
        ,COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date])) AS [Return Date]
      --,ph.[Lead Time]
        ,DATEDIFF(day,ph.[Issue Date],COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date])) AS [Lead Time]
        ,ph.[Maximum Trip Length]
      --,ph.[Trip Duration]
        ,DATEDIFF(day,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]),COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date]))) + 1 AS [Trip Duration]
        ,IIF(ph.[Product Code]='CMC',ph.[Trip Length],DATEDIFF(day,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]),COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date]))) + 1) AS [Trip Length]
        ,ph.[Area Name]
        ,ph.[Area Number]
        ,ph.[Destination]
        ,pp.[MultiDestination]
        ,ph.[Excess]
        ,ph.[Group Policy]
        ,ph.[Has Rental Car]
        ,ph.[Has Motorcycle]
        ,ph.[Has Wintersport]
        ,ph.[Has Medical]
        ,ph.[Single/Family]
        ,ph.[Purchase Path]
        ,ph.[TRIPS Policy]
        ,ph.[Product Code]
        ,ph.[Plan Code]
        ,ph.[Product Name]
        ,ph.[Product Plan]
        ,ph.[Product Type]
        ,ph.[Product Group]
        ,ph.[Policy Type]
        ,ph.[Plan Type]
        ,ph.[Trip Type]
        ,ph.[Product Classification]
        ,ph.[Finance Product Code]
        ,ph.[OutletKey]
        ,ph.[Alpha Code]
        ,ph.[Customer Post Code] AS [Customer Postcode]
        ,pc.[State] AS [Customer Postcode State]
        ,pr.[State] AS [Customer State]
        ,ph.[Unique Traveller Count]
        ,ph.[Unique Charged Traveller Count]
        ,ph.[Traveller Count]
        ,ph.[Charged Traveller Count]
        ,ph.[Adult Traveller Count]
        ,ph.[EMC Traveller Count]
        ,ph.[Youngest Charged DOB]
        ,ph.[Oldest Charged DOB]
        ,ph.[Youngest Age]
        ,ph.[Oldest Age]
        ,ph.[Youngest Charged Age]
        ,ph.[Oldest Charged Age]
        ,CASE 
            WHEN CAST(ph.[Issue Date] as date) >= '2020-06-09'                THEN 1.0
            WHEN dr.[Country or Area] IN ('Indonesia')                        THEN 1.0
            WHEN dr.[Intermediate Region Name] IN ('West Asia (Middle East)') THEN 1.5
            WHEN dr.[Region Name] IN ('Oceania')                              THEN 1.0
            WHEN dr.[Region Name] IN ('Asia','Africa','Europe')               THEN 1.2
            WHEN dr.[Region Name] IN ('Americas','World','Antarctica')        THEN 1.5
            ELSE NULL
         END AS [EMC Multiplier]
        ,(SELECT MAX(v)
            FROM (VALUES 
                (ph.[Charged Traveller 1 EMC Score]), 
			    (ph.[Charged Traveller 2 EMC Score]), 
			    (ph.[Charged Traveller 3 EMC Score]), 
			    (ph.[Charged Traveller 4 EMC Score]), 
			    (ph.[Charged Traveller 5 EMC Score]), 
			    (ph.[Charged Traveller 6 EMC Score]), 
			    (ph.[Charged Traveller 7 EMC Score]), 
			    (ph.[Charged Traveller 8 EMC Score]), 
			    (ph.[Charged Traveller 9 EMC Score]), 
			    (ph.[Charged Traveller 10 EMC Score])
			    ) AS value(v)
		    ) AS [Highest EMC score]
        ,ph.[Max EMC Score]
        ,ph.[Total EMC Score]
        ,ph.[Gender]
        ,ph.[Has EMC]
        ,ph.[Has Manual EMC]
        ,ph.[Charged Traveller 1 Gender]
        ,ph.[Charged Traveller 1 DOB]
        ,ph.[Charged Traveller 1 Has EMC]
        ,ph.[Charged Traveller 1 Has Manual EMC]
        ,ph.[Charged Traveller 1 EMC Score]
        ,ph.[Charged Traveller 1 EMC Reference]
        ,ph.[Charged Traveller 2 Gender]
        ,ph.[Charged Traveller 2 DOB]
        ,ph.[Charged Traveller 2 Has EMC]
        ,ph.[Charged Traveller 2 Has Manual EMC]
        ,ph.[Charged Traveller 2 EMC Score]
        ,ph.[Charged Traveller 2 EMC Reference]
        ,ph.[Charged Traveller 3 Gender]
        ,ph.[Charged Traveller 3 DOB]
        ,ph.[Charged Traveller 3 Has EMC]
        ,ph.[Charged Traveller 3 Has Manual EMC]
        ,ph.[Charged Traveller 3 EMC Score]
        ,ph.[Charged Traveller 3 EMC Reference]
        ,ph.[Charged Traveller 4 Gender]
        ,ph.[Charged Traveller 4 DOB]
        ,ph.[Charged Traveller 4 Has EMC]
        ,ph.[Charged Traveller 4 Has Manual EMC]
        ,ph.[Charged Traveller 4 EMC Score]
        ,ph.[Charged Traveller 4 EMC Reference]
        ,ph.[Charged Traveller 5 Gender]
        ,ph.[Charged Traveller 5 DOB]
        ,ph.[Charged Traveller 5 Has EMC]
        ,ph.[Charged Traveller 5 Has Manual EMC]
        ,ph.[Charged Traveller 5 EMC Score]
        ,ph.[Charged Traveller 5 EMC Reference]
        ,ph.[Charged Traveller 6 Gender]
        ,ph.[Charged Traveller 6 DOB]
        ,ph.[Charged Traveller 6 Has EMC]
        ,ph.[Charged Traveller 6 Has Manual EMC]
        ,ph.[Charged Traveller 6 EMC Score]
        ,ph.[Charged Traveller 6 EMC Reference]
        ,ph.[Charged Traveller 7 Gender]
        ,ph.[Charged Traveller 7 DOB]
        ,ph.[Charged Traveller 7 Has EMC]
        ,ph.[Charged Traveller 7 Has Manual EMC]
        ,ph.[Charged Traveller 7 EMC Score]
        ,ph.[Charged Traveller 7 EMC Reference]
        ,ph.[Charged Traveller 8 Gender]
        ,ph.[Charged Traveller 8 DOB]
        ,ph.[Charged Traveller 8 Has EMC]
        ,ph.[Charged Traveller 8 Has Manual EMC]
        ,ph.[Charged Traveller 8 EMC Score]
        ,ph.[Charged Traveller 8 EMC Reference]
        ,ph.[Charged Traveller 9 Gender]
        ,ph.[Charged Traveller 9 DOB]
        ,ph.[Charged Traveller 9 Has EMC]
        ,ph.[Charged Traveller 9 Has Manual EMC]
        ,ph.[Charged Traveller 9 EMC Score]
        ,ph.[Charged Traveller 9 EMC Reference]
        ,ph.[Charged Traveller 10 Gender]         AS [Charged Traveller 0 Gender]
        ,ph.[Charged Traveller 10 DOB]            AS [Charged Traveller 0 DOB]
        ,ph.[Charged Traveller 10 Has EMC]        AS [Charged Traveller 0 Has EMC]
        ,ph.[Charged Traveller 10 Has Manual EMC] AS [Charged Traveller 0 Has Manual EMC]
        ,ph.[Charged Traveller 10 EMC Score]      AS [Charged Traveller 0 EMC Score]
        ,ph.[Charged Traveller 10 EMC Reference]  AS [Charged Traveller 0 EMC Reference]
        ,ph.[Commission Tier]
        ,ph.[Volume Commission]
        ,ph.[Discount]
        ,ph.[Base Base Premium]
        ,ph.[Base Premium]
        ,ph.[Canx Premium]
        ,ph.[Undiscounted Canx Premium]
        ,ph.[Rental Car Premium]
        ,ph.[Motorcycle Premium]
        ,ph.[Luggage Premium]
        ,ph.[Medical Premium]
        ,ph.[Winter Sport Premium]
        ,ph.[Luggage Increase]
        ,ph.[Trip Cost]
        ,CASE WHEN (ph.[Product Code] IN ('ICC','IEC') AND ph.[Issue Date] < '2022-04-20') OR (ph.[Product Code] IN ('DTP','DTS','WJP','WJS')) 
              THEN ph.[Trip Cost]/(SELECT MIN(v) FROM (VALUES(ph.[Adult Traveller Count]),(4)) AS value(v))
              ELSE ph.[Trip Cost]
	     END [Trip Cost Adj]
        ,ph.[Unadjusted Sell Price]
        ,ph.[Unadjusted GST on Sell Price]
        ,ph.[Unadjusted Stamp Duty on Sell Price]
        ,ph.[Unadjusted Agency Commission]
        ,ph.[Unadjusted GST on Agency Commission]
        ,ph.[Unadjusted Stamp Duty on Agency Commission]
        ,ph.[Unadjusted Admin Fee]
        ,ph.[Sell Price]
        ,ph.[GST on Sell Price]
        ,ph.[Stamp Duty on Sell Price]
        ,ph.[Premium]
        ,ph.[Risk Nett]
        ,ph.[GUG]
        ,ph.[Agency Commission]
        ,ph.[GST on Agency Commission]
        ,ph.[Stamp Duty on Agency Commission]
        ,ph.[Admin Fee]
        ,ph.[NAP]
        ,ph.[NAP (incl Tax)]
        ,ph.[Policy Count]
        ,ph.[Price Beat Policy]
        ,ph.[Competitor Name]
        ,ph.[Competitor Price]
        ,ph.[Category]
        ,ph.[Rental Car Increase]
        ,ph.[ActuarialPolicyID]
        ,ph.[EMC Tier Oldest Charged]
        ,ph.[EMC Tier Youngest Charged]
        ,ph.[Has Cruise]
        ,ph.[Cruise Premium]
        ,ph.[Plan Name]
        ,po.[OutletName]        AS [Outlet Name]
        ,po.[SubGroupCode]      AS [Sub Group Code]
        ,po.[SubGroupName]      AS [Sub Group Name]
        ,po.[GroupCode]         AS [Group Code]
        ,po.[GroupName]         AS [Group Name]
        ,po.[SuperGroupName]    AS [Super Group Name]
        ,po.[Channel]           AS [Channel]
        ,po.[BDMName]           AS [BDM Name]
        ,po.[ContactPostCode]   AS [Contact PostCode]
        ,po.[StateSalesArea]    AS [State Sales Area]
        ,po.[TradingStatus]     AS [Trading Status]
        ,po.[OutletType]        AS [Outlet Type]
        ,po.[JVCode]            AS [JV Code]
        ,po.[JV]                AS [JV]
        ,dr.[Country or Area]
        ,dr.[Intermediate Region Name]
        ,dr.[Sub-region Name]
        ,dr.[Region Name]
        ,dr.[Least Developed Countries (LDC)]
        ,dr.[Land Locked Developing Countries (LLDC)]
        ,dr.[Small Island Developing States (SIDS)]
        ,dr.[Developed / Developing Countries]
    FROM [db-au-actuary].[ws].[DWHDataSetSummary_Test] ph
    OUTER APPLY (
        SELECT TOP 1 *
        FROM [db-au-actuary].[ws].[DWHDataSet] pt
        WHERE pt.[PolicyKey]    = ph.[PolicyKey]    AND 
              pt.[Product Code] = ph.[Product Code] AND
              pt.[Transaction Status] = 'Active'
        ORDER BY [Transaction Issue Date] DESC, [BIRowID] DESC
        ) pt
    OUTER APPLY (
        SELECT TOP 1 *
        FROM [uldwh02].[db-au-cmdwh].[dbo].[penOutlet] po
        WHERE po.[OutletKey]    = ph.[OutletKey] AND
              po.[OutletStatus] = 'Current'
        ORDER BY [OutletStartDate]
        ) po
    OUTER APPLY (
        SELECT *
        FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicy] pp 
        WHERE pp.[PolicyKey]   = ph.[PolicyKey] AND 
              pp.[ProductCode] = ph.[Product Code]
        ) pp
    OUTER APPLY (
        SELECT *
        FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTraveller] pr 
        WHERE pr.[PolicyKey] = ph.[PolicyKey] AND 
              pr.[isPrimary] = 1
        ) pr
    OUTER APPLY (
        SELECT TOP 1 pc.[postcode],pc.[state]
        FROM [db-au-actuary].[cng].[Postcodes] pc
        WHERE pc.[postcode] = ph.[Customer Post Code]
        GROUP BY pc.[postcode],pc.[state]
        ORDER BY COUNT(*) DESC
        ) pc
    OUTER APPLY (
        SELECT *
        FROM [db-au-actuary].[cng].[Destination_Fix] df
        WHERE df.[Destination] = ph.[Destination]
        ) df
    OUTER APPLY (
        SELECT *
        FROM [db-au-actuary].[cng].[Destination_Regions] dr
        WHERE dr.[Country or Area] = df.[Fix]
        ) dr
    WHERE ph.[Domain Country] IN ('AU','NZ') AND ph.[Issue Date] >= '2023-01-01'

    UNION ALL

    SELECT
         ph.[BIRowID]
        ,ph.[Domain Country]
        ,ph.[Company]
        ,ph.[PolicyKey]
        ,ph.[Base Policy No]
        ,ph.[Policy Status]
        ,ph.[Issue Date]
        ,ph.[Posting Date]
        ,ph.[Last Transaction Issue Date]
        ,ph.[Last Transaction posting Date]
        ,ph.[Transaction Type]
      --,ph.[Departure Date]
	    ,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]) AS [Departure Date]
      --,ph.[Return Date]
        ,COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date])) AS [Return Date]
      --,ph.[Lead Time]
        ,DATEDIFF(day,ph.[Issue Date],COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date])) AS [Lead Time]
        ,ph.[Maximum Trip Length]
      --,ph.[Trip Duration]
        ,DATEDIFF(day,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]),COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date]))) + 1 AS [Trip Duration]
        ,IIF(ph.[Product Code]='CMC',ph.[Trip Length],DATEDIFF(day,COALESCE(pt.[Departure Date],ph.[Departure Date],ph.[Issue Date]),COALESCE(pt.[Return Date],ph.[Return Date],DATEADD(year,1,ph.[Issue Date]))) + 1) AS [Trip Length]
        ,ph.[Area Name]
        ,ph.[Area Number]
        ,ph.[Destination]
        ,pp.[MultiDestination]
        ,ph.[Excess]
        ,ph.[Group Policy]
        ,ph.[Has Rental Car]
        ,ph.[Has Motorcycle]
        ,ph.[Has Wintersport]
        ,ph.[Has Medical]
        ,ph.[Single/Family]
        ,ph.[Purchase Path]
        ,ph.[TRIPS Policy]
        ,ph.[Product Code]
        ,ph.[Plan Code]
        ,ph.[Product Name]
        ,ph.[Product Plan]
        ,ph.[Product Type]
        ,ph.[Product Group]
        ,ph.[Policy Type]
        ,ph.[Plan Type]
        ,ph.[Trip Type]
        ,ph.[Product Classification]
        ,ph.[Finance Product Code]
        ,ph.[OutletKey]
        ,ph.[Alpha Code]
        ,ph.[Customer Post Code] AS [Customer Postcode]
        ,pc.[State] AS [Customer Postcode State]
        ,pr.[State] AS [Customer State]
        ,ph.[Unique Traveller Count]
        ,ph.[Unique Charged Traveller Count]
        ,ph.[Traveller Count]
        ,ph.[Charged Traveller Count]
        ,ph.[Adult Traveller Count]
        ,ph.[EMC Traveller Count]
        ,ph.[Youngest Charged DOB]
        ,ph.[Oldest Charged DOB]
        ,ph.[Youngest Age]
        ,ph.[Oldest Age]
        ,ph.[Youngest Charged Age]
        ,ph.[Oldest Charged Age]
        ,CASE 
            WHEN CAST(ph.[Issue Date] as date) >= '2020-06-09'                THEN 1.0
            WHEN dr.[Country or Area] IN ('Indonesia')                        THEN 1.0
            WHEN dr.[Intermediate Region Name] IN ('West Asia (Middle East)') THEN 1.5
            WHEN dr.[Region Name] IN ('Oceania')                              THEN 1.0
            WHEN dr.[Region Name] IN ('Asia','Africa','Europe')               THEN 1.2
            WHEN dr.[Region Name] IN ('Americas','World','Antarctica')        THEN 1.5
            ELSE NULL
         END AS [EMC Multiplier]
        ,(SELECT MAX(v)
            FROM (VALUES 
                (ph.[Charged Traveller 1 EMC Score]), 
			    (ph.[Charged Traveller 2 EMC Score]), 
			    (ph.[Charged Traveller 3 EMC Score]), 
			    (ph.[Charged Traveller 4 EMC Score]), 
			    (ph.[Charged Traveller 5 EMC Score]), 
			    (ph.[Charged Traveller 6 EMC Score]), 
			    (ph.[Charged Traveller 7 EMC Score]), 
			    (ph.[Charged Traveller 8 EMC Score]), 
			    (ph.[Charged Traveller 9 EMC Score]), 
			    (ph.[Charged Traveller 10 EMC Score])
			    ) AS value(v)
		    ) AS [Highest EMC score]
        ,ph.[Max EMC Score]
        ,ph.[Total EMC Score]
        ,ph.[Gender]
        ,ph.[Has EMC]
        ,ph.[Has Manual EMC]
        ,ph.[Charged Traveller 1 Gender]
        ,ph.[Charged Traveller 1 DOB]
        ,ph.[Charged Traveller 1 Has EMC]
        ,ph.[Charged Traveller 1 Has Manual EMC]
        ,ph.[Charged Traveller 1 EMC Score]
        ,ph.[Charged Traveller 1 EMC Reference]
        ,ph.[Charged Traveller 2 Gender]
        ,ph.[Charged Traveller 2 DOB]
        ,ph.[Charged Traveller 2 Has EMC]
        ,ph.[Charged Traveller 2 Has Manual EMC]
        ,ph.[Charged Traveller 2 EMC Score]
        ,ph.[Charged Traveller 2 EMC Reference]
        ,ph.[Charged Traveller 3 Gender]
        ,ph.[Charged Traveller 3 DOB]
        ,ph.[Charged Traveller 3 Has EMC]
        ,ph.[Charged Traveller 3 Has Manual EMC]
        ,ph.[Charged Traveller 3 EMC Score]
        ,ph.[Charged Traveller 3 EMC Reference]
        ,ph.[Charged Traveller 4 Gender]
        ,ph.[Charged Traveller 4 DOB]
        ,ph.[Charged Traveller 4 Has EMC]
        ,ph.[Charged Traveller 4 Has Manual EMC]
        ,ph.[Charged Traveller 4 EMC Score]
        ,ph.[Charged Traveller 4 EMC Reference]
        ,ph.[Charged Traveller 5 Gender]
        ,ph.[Charged Traveller 5 DOB]
        ,ph.[Charged Traveller 5 Has EMC]
        ,ph.[Charged Traveller 5 Has Manual EMC]
        ,ph.[Charged Traveller 5 EMC Score]
        ,ph.[Charged Traveller 5 EMC Reference]
        ,ph.[Charged Traveller 6 Gender]
        ,ph.[Charged Traveller 6 DOB]
        ,ph.[Charged Traveller 6 Has EMC]
        ,ph.[Charged Traveller 6 Has Manual EMC]
        ,ph.[Charged Traveller 6 EMC Score]
        ,ph.[Charged Traveller 6 EMC Reference]
        ,ph.[Charged Traveller 7 Gender]
        ,ph.[Charged Traveller 7 DOB]
        ,ph.[Charged Traveller 7 Has EMC]
        ,ph.[Charged Traveller 7 Has Manual EMC]
        ,ph.[Charged Traveller 7 EMC Score]
        ,ph.[Charged Traveller 7 EMC Reference]
        ,ph.[Charged Traveller 8 Gender]
        ,ph.[Charged Traveller 8 DOB]
        ,ph.[Charged Traveller 8 Has EMC]
        ,ph.[Charged Traveller 8 Has Manual EMC]
        ,ph.[Charged Traveller 8 EMC Score]
        ,ph.[Charged Traveller 8 EMC Reference]
        ,ph.[Charged Traveller 9 Gender]
        ,ph.[Charged Traveller 9 DOB]
        ,ph.[Charged Traveller 9 Has EMC]
        ,ph.[Charged Traveller 9 Has Manual EMC]
        ,ph.[Charged Traveller 9 EMC Score]
        ,ph.[Charged Traveller 9 EMC Reference]
        ,ph.[Charged Traveller 10 Gender]         AS [Charged Traveller 0 Gender]
        ,ph.[Charged Traveller 10 DOB]            AS [Charged Traveller 0 DOB]
        ,ph.[Charged Traveller 10 Has EMC]        AS [Charged Traveller 0 Has EMC]
        ,ph.[Charged Traveller 10 Has Manual EMC] AS [Charged Traveller 0 Has Manual EMC]
        ,ph.[Charged Traveller 10 EMC Score]      AS [Charged Traveller 0 EMC Score]
        ,ph.[Charged Traveller 10 EMC Reference]  AS [Charged Traveller 0 EMC Reference]
        ,ph.[Commission Tier]
        ,ph.[Volume Commission]
        ,ph.[Discount]
        ,ph.[Base Base Premium]
        ,ph.[Base Premium]
        ,ph.[Canx Premium]
        ,ph.[Undiscounted Canx Premium]
        ,ph.[Rental Car Premium]
        ,ph.[Motorcycle Premium]
        ,ph.[Luggage Premium]
        ,ph.[Medical Premium]
        ,ph.[Winter Sport Premium]
        ,ph.[Luggage Increase]
        ,ph.[Trip Cost]
        ,CASE WHEN (ph.[Product Code] IN ('ICC','IEC') AND ph.[Issue Date] < '2022-04-20') OR (ph.[Product Code] IN ('DTP','DTS','WJP','WJS')) 
              THEN ph.[Trip Cost]/(SELECT MIN(v) FROM (VALUES(ph.[Adult Traveller Count]),(4)) AS value(v))
              ELSE ph.[Trip Cost]
	     END [Trip Cost Adj]
        ,ph.[Unadjusted Sell Price]
        ,ph.[Unadjusted GST on Sell Price]
        ,ph.[Unadjusted Stamp Duty on Sell Price]
        ,ph.[Unadjusted Agency Commission]
        ,ph.[Unadjusted GST on Agency Commission]
        ,ph.[Unadjusted Stamp Duty on Agency Commission]
        ,ph.[Unadjusted Admin Fee]
        ,ph.[Sell Price]
        ,ph.[GST on Sell Price]
        ,ph.[Stamp Duty on Sell Price]
        ,ph.[Premium]
        ,ph.[Risk Nett]
        ,ph.[GUG]
        ,ph.[Agency Commission]
        ,ph.[GST on Agency Commission]
        ,ph.[Stamp Duty on Agency Commission]
        ,ph.[Admin Fee]
        ,ph.[NAP]
        ,ph.[NAP (incl Tax)]
        ,ph.[Policy Count]
        ,ph.[Price Beat Policy]
        ,ph.[Competitor Name]
        ,ph.[Competitor Price]
        ,ph.[Category]
        ,ph.[Rental Car Increase]
        ,ph.[ActuarialPolicyID]
        ,ph.[EMC Tier Oldest Charged]
        ,ph.[EMC Tier Youngest Charged]
        ,ph.[Has Cruise]
        ,ph.[Cruise Premium]
        ,ph.[Plan Name]
        ,po.[OutletName]        AS [Outlet Name]
        ,po.[SubGroupCode]      AS [Sub Group Code]
        ,po.[SubGroupName]      AS [Sub Group Name]
        ,po.[GroupCode]         AS [Group Code]
        ,po.[GroupName]         AS [Group Name]
        ,po.[SuperGroupName]    AS [Super Group Name]
        ,po.[Channel]           AS [Channel]
        ,po.[BDMName]           AS [BDM Name]
        ,po.[ContactPostCode]   AS [Contact PostCode]
        ,po.[StateSalesArea]    AS [State Sales Area]
        ,po.[TradingStatus]     AS [Trading Status]
        ,po.[OutletType]        AS [Outlet Type]
        ,po.[JVCode]            AS [JV Code]
        ,po.[JV]                AS [JV]
        ,dr.[Country or Area]
        ,dr.[Intermediate Region Name]
        ,dr.[Sub-region Name]
        ,dr.[Region Name]
        ,dr.[Least Developed Countries (LDC)]
        ,dr.[Land Locked Developing Countries (LLDC)]
        ,dr.[Small Island Developing States (SIDS)]
        ,dr.[Developed / Developing Countries]
    FROM [db-au-actuary].[ws].[DWHDataSetSummary_CBA_Test] ph
    OUTER APPLY (
        SELECT TOP 1 *
        FROM [db-au-actuary].[ws].[DWHDataSet_CBA] pt
        WHERE pt.[PolicyKey]    = ph.[PolicyKey]    AND 
              pt.[Product Code] = ph.[Product Code] AND
              pt.[Transaction Status] = 'Active'
        ORDER BY [Transaction Issue Date] DESC, [BIRowID] DESC
        ) pt
    OUTER APPLY (
        SELECT TOP 1 *
        FROM [azsyddwh02].[db-au-cba].[dbo].[penOutlet] po
        WHERE po.[OutletKey]    = ph.[OutletKey] AND
              po.[OutletStatus] = 'Current'
        ORDER BY [OutletStartDate]
        ) po
    OUTER APPLY (
        SELECT *
        FROM [azsyddwh02].[db-au-cba].[dbo].[penPolicy] pp 
        WHERE pp.[PolicyKey]   = ph.[PolicyKey] AND 
              pp.[ProductCode] = ph.[Product Code]
        ) pp
    OUTER APPLY (
        SELECT *
        FROM [azsyddwh02].[db-au-cba].[dbo].[penPolicyTraveller] pr 
        WHERE pr.[PolicyKey] = ph.[PolicyKey] AND 
              pr.[isPrimary] = 1
        ) pr
    OUTER APPLY (
        SELECT TOP 1 pc.[postcode],pc.[state]
        FROM [db-au-actuary].[cng].[Postcodes] pc
        WHERE pc.[postcode] = ph.[Customer Post Code]
        GROUP BY pc.[postcode],pc.[state]
        ORDER BY COUNT(*) DESC
        ) pc
    OUTER APPLY (
        SELECT *
        FROM [db-au-actuary].[cng].[Destination_Fix] df
        WHERE df.[Destination] = ph.[Destination]
        ) df
    OUTER APPLY (
        SELECT *
        FROM [db-au-actuary].[cng].[Destination_Regions] dr
        WHERE dr.[Country or Area] = df.[Fix]
        ) dr
    WHERE ph.[Domain Country] IN ('AU','NZ') AND ph.[Issue Date] >= '2023-01-01'
    )

    --SELECT * FROM [DWHDataSetSummary];

,[DWHDataSetSummary] AS (
    SELECT
         ph.[PolicyKey]
        ,ph.[Base Policy No]
        ,ph.[Policy Status]

        ,CASE 
            WHEN ph.[JV] IN ('CBA NAC','BW NAC')          THEN 'CBA NAC'
            WHEN ph.[JV] IN ('Ticketek')                  THEN 'Integrated Ticketek'
            WHEN ph.[Product Code] IN ('CMC')             THEN 'Corporate'
            WHEN ph.[Product Code] IN ('CTD')             THEN 'Integrated Coles'
            WHEN ph.[Product Code] IN ('FCI','ABD','BJD') THEN 'Integrated Flight Centre'
            WHEN ph.[Product Code] IN ('RCP')             THEN 'Integrated Halo'
            WHEN ph.[Product Code] IN ('ATO','ATR','VAR') THEN 'Integrated Virgin'
            WHEN ph.[Product Code] IN ('WDI','WTI')       THEN 'Integrated Webjet'
            WHEN ph.[Domain Country] IN ('AU') AND ph.[Plan Type] = 'Domestic' AND ph.[Product Code] IN ('FYE')         THEN 'Dom-Canx Australia'
            WHEN ph.[Domain Country] IN ('NZ') AND ph.[Plan Type] = 'Domestic' AND ph.[Product Code] IN ('AID','ANR')   THEN 'Dom-Canx New Zealand'
            WHEN ph.[Domain Country] IN ('AU') AND ph.[Plan Type] = 'Domestic' AND ph.[Trip Type] = 'Cancellation'      THEN 'Dom-Canx Australia'
            WHEN ph.[Domain Country] IN ('NZ') AND ph.[Plan Type] = 'Domestic' AND ph.[Trip Type] = 'Cancellation'      THEN 'Dom-Canx New Zealand'
            ELSE 'GLM'
         END AS [UW Rating Group]

        ,ph.[Domain Country]
        ,ph.[Company]
        ,CONCAT(ph.[Domain Country],' ',ph.[JV]) AS [JV]
        ,ph.[Super Group Name]
        ,ph.[Group Name]
        ,ph.[Sub Group Name]
        ,ph.[Outlet Name]
        ,COALESCE(ph.[Channel],'Unknown') AS [Channel]
        ,ph.[Purchase Path]

        ,ph.[Customer Postcode]
        ,CASE WHEN ph.[Domain Country] = 'AU' AND ph.[Customer State]          IN ('NSW','VIC','QLD','WA','SA','ACT','TAS','NT') THEN ph.[Customer State]
              WHEN ph.[Domain Country] = 'AU' AND ph.[Customer Postcode State] IN ('NSW','VIC','QLD','WA','SA','ACT','TAS','NT') THEN ph.[Customer Postcode State]
              WHEN ph.[Domain Country] = 'AU' THEN 'AU'
              WHEN ph.[Domain Country] = 'NZ' THEN 'NZ'
              ELSE 'Unknown'
         END AS [Customer State] 

        ,ph.[Product Group]
        ,ph.[Policy Type]
        ,ph.[Product Classification]
        ,ph.[Plan Type]
        ,ph.[Trip Type]
        ,ph.[Product Plan]
        ,ph.[Product Code]

        ,ph.[Issue Date]
        ,DATEPART(mm,ph.[Issue Date])      AS [Issue Month]
        ,DATEPART(qq,ph.[Issue Date])      AS [Issue Quarter]
        ,DATEPART(yy,ph.[Issue Date])      AS [Issue Year]
        ,DATEPART(yy,ph.[Issue Date])+(DATEPART(mm,ph.[Issue Date])-0.50)/12.00 AS [Issue Year-Month]

	    ,ph.[Departure Date]
        ,DATEPART(mm,ph.[Departure Date])  AS [Departure Month]
        ,DATEPART(qq,ph.[Departure Date])  AS [Departure Quarter]
        ,DATEPART(yy,ph.[Departure Date])  AS [Departure Year]
        ,DATEPART(yy,ph.[Departure Date])+(DATEPART(mm,ph.[Departure Date])-0.50)/12.00 AS [Departure Year-Month]

	    ,ph.[Return Date]
        ,DATEPART(mm,ph.[Return Date])  AS [Return Month]
        ,DATEPART(qq,ph.[Return Date])  AS [Return Quarter]
        ,DATEPART(yy,ph.[Return Date])  AS [Return Year]
        ,DATEPART(yy,ph.[Return Date])+(DATEPART(mm,ph.[Return Date])-0.50)/12.00 AS [Return Year-Month]

        ,CONCAT(DATEPART(mm,ph.[Departure Date]),'-',DATEPART(mm,ph.[Return Date])) AS [Departure-Return Month]

        ,IIF(ph.[Lead Time]    <0,0,ph.[Lead Time]    ) AS [Lead Time]
        ,IIF(ph.[Trip Duration]<0,0,ph.[Trip Duration]) AS [Trip Duration]
        ,CASE WHEN ph.[Trip Type] = 'AMT' THEN ph.[Maximum Trip Length]
              WHEN ph.[Trip Duration]<0   THEN 0
                                          ELSE ph.[Trip Duration]
         END AS [Single Trip Length]
        ,ph.[Maximum Trip Length] AS [AMT Trip Length]

        ,ph.[Excess]
        ,ph.[Trip Cost]
        ,ph.[Trip Cost Adj]

        ,ph.[Area Name]
        ,ph.[Destination]
        ,ph.[MultiDestination]
        ,IIF(CHARINDEX(';',ph.[MultiDestination])>0,'Y','N') AS [MultiDestinationFlag]
        ,COALESCE(ph.[Country or Area]         ,'Unknown') AS [Country or Area]
        ,COALESCE(ph.[Intermediate Region Name],'Unknown') AS [Intermediate Region Name]
        ,COALESCE(ph.[Region Name]             ,'Unknown') AS [Region Name]
        ,CASE
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Destination] IN ('AUSTRALIA','AUSTRALIA INBOUND') THEN 'Australia-AUSTRALIA'
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Destination] IN ('NEW ZEALAND')                   THEN 'Domestic-NEW ZEALAND'
            WHEN ph.[Destination] IS NULL                                                             THEN 'World Others'
            ELSE du.[GLM_Region_2017] 
         END AS [GLM_Region_2017]
        ,CASE
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Destination] IN ('AUSTRALIA','AUSTRALIA INBOUND') THEN 'Australia-AUSTRALIA'
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Destination] IN ('NEW ZEALAND')                   THEN 'Domestic-NEW ZEALAND'
            WHEN ph.[Destination] IS NULL                                                             THEN 'World Others'
            ELSE du.[GLM_Region_2021] 
         END AS [GLM_Region_2021]
        ,CASE
            WHEN ph.[Domain Country] = 'AU' AND ph.[Plan Type]   = 'Domestic'                                         THEN 'Oceania - Australia - Domestic'
            WHEN ph.[Domain Country] = 'AU' AND ph.[Plan Type]   = 'Domestic Inbound'                                 THEN 'Oceania - Australia - Inbound'
            WHEN ph.[Domain Country] = 'AU' AND ph.[Policy Type] = 'Car Hire'                                         THEN 'Oceania - Australia - Rental Car'

            WHEN ph.[Domain Country] = 'NZ' AND ph.[Plan Type]   = 'Domestic'                                         THEN 'Oceania - New Zealand - Domestic'
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Plan Type]   = 'Domestic Inbound'                                 THEN 'Oceania - New Zealand - Inbound'
            
            ELSE COALESCE(ph.[Region Name],'Unknown')+' - '+du.[GLM_Region_2024]
         END AS [GLM_Region_2024]

        ,COALESCE(ph.[Single/Family],'S') AS [Single/Family]
        ,ph.[Traveller Count]
        ,ph.[Adult Traveller Count]
        ,ph.[Traveller Count] - ph.[Adult Traveller Count] AS [Child Traveller Count]
        ,ph.[Charged Traveller Count]

        ,ph.[Gender]
        ,ph.[Youngest Age]
        ,ph.[Oldest Age]
        ,ph.[Youngest Charged Age]
        ,ph.[Oldest Charged Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 1 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 1 DOB],ph.[Issue Date]), ph.[Charged Traveller 1 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 1 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 2 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 2 DOB],ph.[Issue Date]), ph.[Charged Traveller 2 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 2 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 3 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 3 DOB],ph.[Issue Date]), ph.[Charged Traveller 3 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 3 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 4 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 4 DOB],ph.[Issue Date]), ph.[Charged Traveller 4 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 4 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 5 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 5 DOB],ph.[Issue Date]), ph.[Charged Traveller 5 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 5 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 6 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 6 DOB],ph.[Issue Date]), ph.[Charged Traveller 6 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 6 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 7 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 7 DOB],ph.[Issue Date]), ph.[Charged Traveller 7 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 7 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 8 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 8 DOB],ph.[Issue Date]), ph.[Charged Traveller 8 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 8 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 9 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 9 DOB],ph.[Issue Date]), ph.[Charged Traveller 9 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 9 Age]
        ,DATEDIFF(YEAR,ph.[Charged Traveller 0 DOB],ph.[Issue Date]) - CASE WHEN DATEADD(YY, DATEDIFF(YEAR,ph.[Charged Traveller 0 DOB],ph.[Issue Date]), ph.[Charged Traveller 0 DOB]) > ph.[Issue Date] THEN 1 ELSE 0 END AS [Charged Traveller 0 Age]

        ,ph.[Has EMC]
        ,ph.[Has Manual EMC]
        ,ph.[Highest EMC score]/ph.[EMC Multiplier] AS [Highest EMC score]
        ,ph.[Max EMC Score]    /ph.[EMC Multiplier] AS [Max EMC Score]
        ,ph.[Total EMC Score]  /ph.[EMC Multiplier] AS [Total EMC Score]
        ,ph.[EMC Multiplier]

    FROM [DWHDataSetSummary_01] ph
    OUTER APPLY (
        SELECT *
        FROM [db-au-actuary].[cng].[UW_Destinations] du
        WHERE du.[Destination] = ph.[Destination]
        ) du
    )

SELECT * FROM [DWHDataSetSummary]
;
GO
