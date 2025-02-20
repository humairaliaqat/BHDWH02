USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spPolicyDatasetSummary_Test]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[spPolicyDatasetSummary_Test]
    @StartDate date,
    @EndDate date

as

--20180817 - LT - Changed Policy Status to use value at transaction level (as opposed to at policy level) for Penguin Leisure policies

begin

    set quoted_identifier on
    set nocount on

    if object_id('ws.DWHDataSetSummaryTest') is null
    begin

        create table ws.[DWHDataSetSummaryTest]
        (
            [BIRowID] bigint not null identity(1,1),
            [Domain Country] varchar(2) null,
            [Company] varchar(5) null,
            [PolicyKey] varchar(41) null,
            [Base Policy No] varchar(50) null,
            [Policy Status] varchar(50) null,
            [Issue Date] datetime null,
            [Posting Date] datetime null,
            [Last Transaction Issue Date] datetime null,
            [Last Transaction posting Date] datetime null,
            [Transaction Type] varchar(50) null,
            [Departure Date] datetime null,
            [Return Date] datetime null,
            [Lead Time] int null,
            [Maximum Trip Length] int null,
            [Trip Duration] int null,
            [Trip Length] int null,
            [Area Name] nvarchar(150) null,
            [Area Number] varchar(20) null,
            [Destination] nvarchar(max) null,
            [Excess] int null,
            [Group Policy] int null,
            [Has Rental Car] bit null,
            [Has Motorcycle] bit null,
            [Has Wintersport] bit null,
            [Has Medical] bit null,
            [Has Cruise] [bit] null,

            [Single/Family] nvarchar(1) null,
            [Purchase Path] nvarchar(50) null,
            [TRIPS Policy] bit null,
            [Product Code] nvarchar(50) null,
            [Plan Code] nvarchar(50) null,
            [Product Name] nvarchar(100) null,
            [Product Plan] nvarchar(100) null,
            [Product Type] nvarchar(100) null,
            [Product Group] nvarchar(100) null,
            [Policy Type] nvarchar(50) null,
            [Plan Type] nvarchar(50) null,
            [Trip Type] nvarchar(50) null,
            [Product Classification] nvarchar(100) null,
            [Finance Product Code] nvarchar(50) null,
            [OutletKey] varchar(33) null,
            [Alpha Code] nvarchar(20) null,
            [Customer Post Code] nvarchar(50) null,
            [Unique Traveller Count] int null,
            [Unique Charged Traveller Count] int null,
            [Traveller Count] int null,
            [Charged Traveller Count] int null,
            [Adult Traveller Count] int null,
            [EMC Traveller Count] int null,
            [Youngest Charged DOB] datetime null,
            [Oldest Charged DOB] datetime null,
            [Youngest Age] int null,
            [Oldest Age] int null,
            [Youngest Charged Age] int null,
            [Oldest Charged Age] int null,
            [Max EMC Score] numeric(18,2) null,
            [Total EMC Score] numeric(18,2) null,
            [Gender] varchar(2) null,
            [Has EMC] varchar(1) null,
            [Has Manual EMC] varchar(1) null,

            [EMC Tier Oldest Charged] [int] null,
            [EMC Tier Youngest Charged] [int] null,

            [Charged Traveller 1 Gender] nchar(2) null,
            [Charged Traveller 1 DOB] date null,
            [Charged Traveller 1 Has EMC] smallint null,
            [Charged Traveller 1 Has Manual EMC] bit null,
            [Charged Traveller 1 EMC Score] decimal(18,2) null,
            [Charged Traveller 1 EMC Reference] int null,
            [Charged Traveller 2 Gender] nchar(2) null,
            [Charged Traveller 2 DOB] date null,
            [Charged Traveller 2 Has EMC] smallint null,
            [Charged Traveller 2 Has Manual EMC] bit null,
            [Charged Traveller 2 EMC Score] decimal(18,2) null,
            [Charged Traveller 2 EMC Reference] int null,
            [Charged Traveller 3 Gender] nchar(2) null,
            [Charged Traveller 3 DOB] date null,
            [Charged Traveller 3 Has EMC] smallint null,
            [Charged Traveller 3 Has Manual EMC] bit null,
            [Charged Traveller 3 EMC Score] decimal(18,2) null,
            [Charged Traveller 3 EMC Reference] int null,
            [Charged Traveller 4 Gender] nchar(2) null,
            [Charged Traveller 4 DOB] date null,
            [Charged Traveller 4 Has EMC] smallint null,
            [Charged Traveller 4 Has Manual EMC] bit null,
            [Charged Traveller 4 EMC Score] decimal(18,2) null,
            [Charged Traveller 4 EMC Reference] int null,
            [Charged Traveller 5 Gender] nchar(2) null,
            [Charged Traveller 5 DOB] date null,
            [Charged Traveller 5 Has EMC] smallint null,
            [Charged Traveller 5 Has Manual EMC] bit null,
            [Charged Traveller 5 EMC Score] decimal(18,2) null,
            [Charged Traveller 5 EMC Reference] int null,
            [Charged Traveller 6 Gender] nchar(2) null,
            [Charged Traveller 6 DOB] date null,
            [Charged Traveller 6 Has EMC] smallint null,
            [Charged Traveller 6 Has Manual EMC] bit null,
            [Charged Traveller 6 EMC Score] decimal(18,2) null,
            [Charged Traveller 6 EMC Reference] int null,
            [Charged Traveller 7 Gender] nchar(2) null,
            [Charged Traveller 7 DOB] date null,
            [Charged Traveller 7 Has EMC] smallint null,
            [Charged Traveller 7 Has Manual EMC] bit null,
            [Charged Traveller 7 EMC Score] decimal(18,2) null,
            [Charged Traveller 7 EMC Reference] int null,
            [Charged Traveller 8 Gender] nchar(2) null,
            [Charged Traveller 8 DOB] date null,
            [Charged Traveller 8 Has EMC] smallint null,
            [Charged Traveller 8 Has Manual EMC] bit null,
            [Charged Traveller 8 EMC Score] decimal(18,2) null,
            [Charged Traveller 8 EMC Reference] int null,
            [Charged Traveller 9 Gender] nchar(2) null,
            [Charged Traveller 9 DOB] date null,
            [Charged Traveller 9 Has EMC] smallint null,
            [Charged Traveller 9 Has Manual EMC] bit null,
            [Charged Traveller 9 EMC Score] decimal(18,2) null,
            [Charged Traveller 9 EMC Reference] int null,
            [Charged Traveller 10 Gender] nchar(2) null,
            [Charged Traveller 10 DOB] date null,
            [Charged Traveller 10 Has EMC] smallint null,
            [Charged Traveller 10 Has Manual EMC] bit null,
            [Charged Traveller 10 EMC Score] decimal(18,2) null,
            [Charged Traveller 10 EMC Reference] int null,
            [Commission Tier] varchar(50) null,
            [Volume Commission] money null,
            [Discount] money null,
            [Base Base Premium] money null,
            [Base Premium] money null,
            [Canx Premium] money null,
            [Undiscounted Canx Premium] money null,
            [Rental Car Premium] money null,
            [Motorcycle Premium] money null,
            [Luggage Premium] money null,
            [Medical Premium] money null,
            [Winter Sport Premium] money null,
            [Cruise Premium] money null,

            [Luggage Increase] money null,
            [Trip Cost] int null,
            [Unadjusted Sell Price] money null,
            [Unadjusted GST on Sell Price] money null,
            [Unadjusted Stamp Duty on Sell Price] money null,
            [Unadjusted Agency Commission] money null,
            [Unadjusted GST on Agency Commission] money null,
            [Unadjusted Stamp Duty on Agency Commission] money null,
            [Unadjusted Admin Fee] money null,
            [Sell Price] money null,
            [GST on Sell Price] money null,
            [Stamp Duty on Sell Price] money null,
            [Premium] money null,
            [Risk Nett] money null,
            [GUG] money null,
            [Agency Commission] money null,
            [GST on Agency Commission] money null,
            [Stamp Duty on Agency Commission] money null,
            [Admin Fee] money null,
            [NAP] money null,
            [NAP (incl Tax)] money null,

            [Policy Count] [int] null,
            [Price Beat Policy] [bit] null,
            [Competitor Name] [nvarchar](50) null,
            [Competitor Price] [money] null,

            [Category] varchar(100) null,
            [Rental Car Increase] money null,
            constraint PK_DWHDataSetSummaryTest primary key clustered (BIRowID)
        )

        create clustered index DWHDataSetSummaryTest_idx on [db-au-actuary].ws.DWHDataSetSummaryTest(BIRowID)
        create nonclustered index DWHDataSetSummaryTest_ncidx on [db-au-actuary].ws.DWHDataSetSummaryTest([Base Policy No])
        create nonclustered index DWHDataSetSummaryTest_ncidxd on [db-au-actuary].ws.DWHDataSetSummaryTest([Issue Date])
        create nonclustered index DWHDataSetSummaryTest_PolicyKey on [db-au-actuary].ws.DWHDataSetSummaryTest(PolicyKey)

    end


    declare
        @start date,
        @end date,
        @err varchar(max)

    declare cMonth cursor local for
        select distinct
            convert(varchar(8), [Issue Date], 120) + '01'
        from
            [db-au-actuary].ws.DWHDataSetTest
        where
            [Posting Date] >= @StartDate and
            [Posting Date] <  dateadd(day, 1, @EndDate)
        order by 1

    open cMonth

    fetch next from cMonth into @start

    while @@fetch_status = 0 
    begin

        set @end = dateadd(day, -1, dateadd(month, 1, @start))

        delete 
        from
            ws.[DWHDataSetSummaryTest]
        where
            [Issue Date] >= @start and
            [Issue Date] <  dateadd(day, 1, @end)

	
		--get Penguin Leisure policies
        insert into ws.[DWHDataSetSummaryTest] with(tablockx)
        (
            [Domain Country],
            [Company],
            [PolicyKey],
            [Base Policy No],
            [Policy Status],
            [Issue Date],
            [Posting Date],
        
            [Last Transaction Issue Date],
            [Last Transaction posting Date],
        
            [Departure Date],
            [Return Date],
            [Lead Time],
            [Maximum Trip Length],
            [Trip Duration],
            [Trip Length],
            [Area Name],
            [Area Number],
            [Destination],
            [Excess],
            [Group Policy],
        
            [Has Rental Car],
            [Has Motorcycle],
            [Has Wintersport],
            [Has Medical],
            [Has Cruise],
        
            [Single/Family],
            [Purchase Path],
            [TRIPS Policy],

            [Product Code],
            [Plan Code],
            [Product Name],
            [Product Plan],
            [Product Type], 
            [Product Group],
            [Policy Type],
            [Plan Type],
            [Trip Type],
            [Product Classification],
            [Finance Product Code],
                                
            [OutletKey],
            [Alpha Code],
        
            [Customer Post Code],
            [Unique Traveller Count],
            [Unique Charged Traveller Count],
            [Traveller Count],
            [Charged Traveller Count],
            [Adult Traveller Count],
            [EMC Traveller Count],
            [Youngest Charged DOB],
            [Oldest Charged DOB],
            [Youngest Age],
            [Oldest Age],
            [Youngest Charged Age],
            [Oldest Charged Age],
            [Max EMC Score],
            [Total EMC Score],
        
            [Gender],
            [Has EMC],
            [Has Manual EMC],

            [EMC Tier Oldest Charged],
            [EMC Tier Youngest Charged],

            [Charged Traveller 1 Gender],
            [Charged Traveller 1 DOB],
            [Charged Traveller 1 Has EMC],
            [Charged Traveller 1 Has Manual EMC],
            [Charged Traveller 1 EMC Score],
            [Charged Traveller 1 EMC Reference],
            [Charged Traveller 2 Gender],
            [Charged Traveller 2 DOB],
            [Charged Traveller 2 Has EMC],
            [Charged Traveller 2 Has Manual EMC],
            [Charged Traveller 2 EMC Score],
            [Charged Traveller 2 EMC Reference],
            [Charged Traveller 3 Gender],
            [Charged Traveller 3 DOB],
            [Charged Traveller 3 Has EMC],
            [Charged Traveller 3 Has Manual EMC],
            [Charged Traveller 3 EMC Score],
            [Charged Traveller 3 EMC Reference],
            [Charged Traveller 4 Gender],
            [Charged Traveller 4 DOB],
            [Charged Traveller 4 Has EMC],
            [Charged Traveller 4 Has Manual EMC],
            [Charged Traveller 4 EMC Score],
            [Charged Traveller 4 EMC Reference],
            [Charged Traveller 5 Gender],
            [Charged Traveller 5 DOB],
            [Charged Traveller 5 Has EMC],
            [Charged Traveller 5 Has Manual EMC],
            [Charged Traveller 5 EMC Score],
            [Charged Traveller 5 EMC Reference],
            [Charged Traveller 6 Gender],
            [Charged Traveller 6 DOB],
            [Charged Traveller 6 Has EMC],
            [Charged Traveller 6 Has Manual EMC],
            [Charged Traveller 6 EMC Score],
            [Charged Traveller 6 EMC Reference],
            [Charged Traveller 7 Gender],
            [Charged Traveller 7 DOB],
            [Charged Traveller 7 Has EMC],
            [Charged Traveller 7 Has Manual EMC],
            [Charged Traveller 7 EMC Score],
            [Charged Traveller 7 EMC Reference],
            [Charged Traveller 8 Gender],
            [Charged Traveller 8 DOB],
            [Charged Traveller 8 Has EMC],
            [Charged Traveller 8 Has Manual EMC],
            [Charged Traveller 8 EMC Score],
            [Charged Traveller 8 EMC Reference],
            [Charged Traveller 9 Gender],
            [Charged Traveller 9 DOB],
            [Charged Traveller 9 Has EMC],
            [Charged Traveller 9 Has Manual EMC],
            [Charged Traveller 9 EMC Score],
            [Charged Traveller 9 EMC Reference],
            [Charged Traveller 10 Gender],
            [Charged Traveller 10 DOB],
            [Charged Traveller 10 Has EMC],
            [Charged Traveller 10 Has Manual EMC],
            [Charged Traveller 10 EMC Score],
            [Charged Traveller 10 EMC Reference],
        
            [Commission Tier],
            [Volume Commission],
            [Discount],
        
            [Base Base Premium],
            [Base Premium],
            [Canx Premium],
            [Undiscounted Canx Premium],
            [Rental Car Premium],
            [Motorcycle Premium],
            [Luggage Premium],
            [Medical Premium],
            [Winter Sport Premium],
            [Cruise Premium],

            [Luggage Increase],
            [Rental Car Increase],
            [Trip Cost],
            [Unadjusted Sell Price],
            [Unadjusted GST on Sell Price],
            [Unadjusted Stamp Duty on Sell Price],
            [Unadjusted Agency Commission],
            [Unadjusted GST on Agency Commission],
            [Unadjusted Stamp Duty on Agency Commission],
            [Unadjusted Admin Fee],
            [Sell Price],
            [GST on Sell Price],
            [Stamp Duty on Sell Price],
            [Premium],
            [Risk Nett],
            [GUG],
            [Agency Commission],
            [GST on Agency Commission],
            [Stamp Duty on Agency Commission],
            [Admin Fee],
            [NAP],
            [NAP (incl Tax)],

            [Policy Count],
            [Price Beat Policy],
            [Competitor Name],
            [Competitor Price],
        
            Category
        )
        select 
            h.[Domain Country],
            h.[Company],
            h.[PolicyKey],
            h.[Base Policy No],
            d.[Policy Status],

            [First Transaction Issue Date] [Issue Date],
            [First Transaction Posting Date] [Posting Date],
        
            d.[Last Transaction Issue Date],
            d.[Last Transaction posting Date],
        
            [Earliest Departure Date] [Departure Date],
            [Latest Return Date] [Return Date],
            datediff(day, [First Transaction Issue Date], [Earliest Departure Date]) [Lead Time],
            case when [TRIPS Policy] = 1 then r.[Maximum Trip Length] else h.[Maximum Trip Length] end [Maximum Trip Length],

            datediff(d, [Earliest Departure Date], [Latest Return Date]) + 1 [Trip Duration],
        
            datediff(d, [Earliest Departure Date], [Latest Return Date]) + 1 [Trip Length],

            case when [TRIPS Policy] = 1 then r.[Area Name] else h.[Area Name] end [Area Name],
            case 
                when [TRIPS Policy] = 1 then r.[Area Number]
                else h.[Area Number] 
            end [Area Number],
            case when [TRIPS Policy] = 1 then r.[Destination] else h.[Destination] end [Destination],
            case when [TRIPS Policy] = 1 then r.[Excess] else h.[Excess] end [Excess],
            case when [TRIPS Policy] = 1 then r.[Group Policy] else h.[Group Policy] end [Group Policy],
        
            --aggregate/--
            case 
                when d.[Has Rental Car] > 0 then 1
                else 0
            end [Has Rental Car],
            case 
                when d.[Has Motorcycle] > 0 then 1
                else 0
            end [Has Motorcycle],
            case 
                when d.[Has Wintersport] > 0 then 1
                else 0
            end [Has Wintersport],
            case 
                when d.[Has Medical] > 0 then 1
                else 0
            end [Has Medical],
            case 
                when d.[Has Cruise] > 0 then 1
                else 0
            end [Has Cruise],
            --/aggregate--
        
            case when [TRIPS Policy] = 1 then r.[Single/Family] else h.[Single/Family] end [Single/Family],
            case when [TRIPS Policy] = 1 then r.[Purchase Path] else h.[Purchase Path] end [Purchase Path],
            h.[TRIPS Policy],

            case when [TRIPS Policy] = 1 then r.[Product Code] else h.[Product Code] end [Product Code],
            case when [TRIPS Policy] = 1 then r.[Plan Code] else h.[Plan Code] end [Plan Code],
            case when [TRIPS Policy] = 1 then r.[Product Name] else h.[Product Name] end [Product Name],
            case when [TRIPS Policy] = 1 then r.[Product Plan] else h.[Product Plan] end [Product Plan],
            case when [TRIPS Policy] = 1 then r.[Product Type] else h.[Product Type] end [Product Type],
            case when [TRIPS Policy] = 1 then r.[Product Group] else h.[Product Group] end [Product Group],
            case when [TRIPS Policy] = 1 then r.[Policy Type] else h.[Policy Type] end [Policy Type],
            case when [TRIPS Policy] = 1 then r.[Plan Type] else h.[Plan Type] end [Plan Type],
            case when [TRIPS Policy] = 1 then r.[Trip Type] else h.[Trip Type] end [Trip Type],
            case when [TRIPS Policy] = 1 then r.[Product Classification] else h.[Product Classification] end [Product Classification],
            case when [TRIPS Policy] = 1 then r.[Finance Product Code] else h.[Finance Product Code] end [Finance Product Code],
                                
            h.[OutletKey],
            h.[Alpha Code],
        
            h.[Customer Post Code],
            h.[Unique Traveller Count],
            h.[Unique Charged Traveller Count],
            h.[Traveller Count],
            h.[Charged Traveller Count],
            h.[Adult Traveller Count],
            h.[EMC Traveller Count],
            h.[Youngest Charged DOB],
            h.[Oldest Charged DOB],
            h.[Youngest Age],
            h.[Oldest Age],
            h.[Youngest Charged Age],
            h.[Oldest Charged Age],
            h.[Max EMC Score],
            h.[Total EMC Score],

            case
                when gg.[Gender] in ('O', '') then 'O'
                when gg.[Gender] = 'F' and h.[Charged Traveller Count] > 1 then 'FF'
                when gg.[Gender] = 'M' and h.[Charged Traveller Count] > 1 then 'MM'
                else gg.[Gender]
            end [Gender],
            case
                when 
                    h.[Charged Traveller 1 Has EMC] >= 1 or
                    h.[Charged Traveller 2 Has EMC] >= 1 or
                    h.[Charged Traveller 3 Has EMC] >= 1 or
                    h.[Charged Traveller 4 Has EMC] >= 1 or
                    h.[Charged Traveller 5 Has EMC] >= 1 or
                    h.[Charged Traveller 6 Has EMC] >= 1 or
                    h.[Charged Traveller 7 Has EMC] >= 1 or
                    h.[Charged Traveller 8 Has EMC] >= 1 or
                    h.[Charged Traveller 9 Has EMC] >= 1 or
                    h.[Charged Traveller 10 Has EMC] >= 1 
                then 'Y'
                else 'N'
            end [Has EMC],
            case
                when d.[Has Medical] <= 0 then 'N'
                when 
                    h.[Charged Traveller 1 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 2 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 3 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 4 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 5 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 6 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 7 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 8 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 9 Has Manual EMC] >= 1 or
                    h.[Charged Traveller 10 Has Manual EMC] >= 1
                then 'Y'
                else 'N'
            end [Has Manual EMC],

            h.[EMC Tier Oldest Charged],
            h.[EMC Tier Youngest Charged],

            h.[Charged Traveller 1 Gender],
            h.[Charged Traveller 1 DOB],
            h.[Charged Traveller 1 Has EMC],
            h.[Charged Traveller 1 Has Manual EMC],
            h.[Charged Traveller 1 EMC Score],
            h.[Charged Traveller 1 EMC Reference],
            h.[Charged Traveller 2 Gender],
            h.[Charged Traveller 2 DOB],
            h.[Charged Traveller 2 Has EMC],
            h.[Charged Traveller 2 Has Manual EMC],
            h.[Charged Traveller 2 EMC Score],
            h.[Charged Traveller 2 EMC Reference],
            h.[Charged Traveller 3 Gender],
            h.[Charged Traveller 3 DOB],
            h.[Charged Traveller 3 Has EMC],
            h.[Charged Traveller 3 Has Manual EMC],
            h.[Charged Traveller 3 EMC Score],
            h.[Charged Traveller 3 EMC Reference],
            h.[Charged Traveller 4 Gender],
            h.[Charged Traveller 4 DOB],
            h.[Charged Traveller 4 Has EMC],
            h.[Charged Traveller 4 Has Manual EMC],
            h.[Charged Traveller 4 EMC Score],
            h.[Charged Traveller 4 EMC Reference],
            h.[Charged Traveller 5 Gender],
            h.[Charged Traveller 5 DOB],
            h.[Charged Traveller 5 Has EMC],
            h.[Charged Traveller 5 Has Manual EMC],
            h.[Charged Traveller 5 EMC Score],
            h.[Charged Traveller 5 EMC Reference],
            h.[Charged Traveller 6 Gender],
            h.[Charged Traveller 6 DOB],
            h.[Charged Traveller 6 Has EMC],
            h.[Charged Traveller 6 Has Manual EMC],
            h.[Charged Traveller 6 EMC Score],
            h.[Charged Traveller 6 EMC Reference],
            h.[Charged Traveller 7 Gender],
            h.[Charged Traveller 7 DOB],
            h.[Charged Traveller 7 Has EMC],
            h.[Charged Traveller 7 Has Manual EMC],
            h.[Charged Traveller 7 EMC Score],
            h.[Charged Traveller 7 EMC Reference],
            h.[Charged Traveller 8 Gender],
            h.[Charged Traveller 8 DOB],
            h.[Charged Traveller 8 Has EMC],
            h.[Charged Traveller 8 Has Manual EMC],
            h.[Charged Traveller 8 EMC Score],
            h.[Charged Traveller 8 EMC Reference],
            h.[Charged Traveller 9 Gender],
            h.[Charged Traveller 9 DOB],
            h.[Charged Traveller 9 Has EMC],
            h.[Charged Traveller 9 Has Manual EMC],
            h.[Charged Traveller 9 EMC Score],
            h.[Charged Traveller 9 EMC Reference],
            h.[Charged Traveller 10 Gender],
            h.[Charged Traveller 10 DOB],
            h.[Charged Traveller 10 Has EMC],
            h.[Charged Traveller 10 Has Manual EMC],
            h.[Charged Traveller 10 EMC Score],
            h.[Charged Traveller 10 EMC Reference],
        
            h.[Commission Tier],
            h.[Volume Commission],
            h.[Discount],
        
            --aggregate/--
            d.[Base Base Premium],
            d.[Base Premium],
            d.[Canx Premium],
            d.[Undiscounted Canx Premium],
            d.[Rental Car Premium],
            d.[Motorcycle Premium],
            d.[Luggage Premium],
            d.[Medical Premium],
            d.[Winter Sport Premium],
            d.[Cruise Premium],

            d.[Luggage Increase],
            d.[Rental Car Increase],

        
            case 
                when 
                    h.[Domain Country] = 'AU' and
                    case 
                        when [TRIPS Policy] = 1 then r.[Plan Type] 
                        else h.[Plan Type] 
                    end = 'Domestic' and 
                    [First Transaction Issue Date] < '2013-01-01' and
                    case 
                        when [TRIPS Policy] = 1 then r.[Trip Type] 
                        else h.[Trip Type]
                    end in ('AMT', 'Single Trip') and
                    d.[Trip Cost] > 0 
                then 10000
                else d.[Trip Cost]
            end [Trip Cost],
        
            d.[Unadjusted Sell Price],
            d.[Unadjusted GST on Sell Price],
            d.[Unadjusted Stamp Duty on Sell Price],
            d.[Unadjusted Agency Commission],
            d.[Unadjusted GST on Agency Commission],
            d.[Unadjusted Stamp Duty on Agency Commission],
            d.[Unadjusted Admin Fee],
            d.[Sell Price],
            d.[GST on Sell Price],
            d.[Stamp Duty on Sell Price],
            d.[Premium],
            d.[Risk Nett],
            d.[GUG],
            d.[Agency Commission],
            d.[GST on Agency Commission],
            d.[Stamp Duty on Agency Commission],
            d.[Admin Fee],
            d.[NAP],
            d.[NAP (incl Tax)],

            d.[Policy Count],
            d.[Price Beat Policy],
            d.[Competitor Name],
            d.[Competitor Price],
            --aggregate/--
        
            case
                when d.TestFlag > 0 then 'Test policy'
                when d.PartialFlag > 0 then 'Partial cancellation'
                when d.DummyFlag > 0 then 'Dummy policy'
                when d.CommissionFlag > 0 then 'Commission adjustment'
                when d.AdminFlag > 0 then 'Admin policy'
                else ''
            end Category
        
        from
            ws.DWHDataSetTest h with(nolock)
            cross apply
            (
                select 
                    min([Issue Date]) [First Transaction Issue Date],
                    min([Posting Date]) [First Transaction Posting Date],
                    max([Issue Date]) [Last Transaction Issue Date],
                    max([Posting Date]) [Last Transaction posting Date],
                    min([Departure Date]) [Earliest Departure Date],
                    max([Return Date]) [Latest Return Date],

                    sum(ReturnFlag * isnull([Has Rental Car], 0)) [Has Rental Car],
                    sum(ReturnFlag * isnull([Has Motorcycle], 0)) [Has Motorcycle],
                    sum(ReturnFlag * isnull([Has Wintersport], 0)) [Has Wintersport],
                    sum(ReturnFlag * isnull([Has Medical], 0)) [Has Medical],
                    sum(ReturnFlag * isnull([Has Cruise], 0)) [Has Cruise],

                    sum(isnull([Base Base Premium],0)) [Base Base Premium],
                    sum(isnull([Base Premium],0)) [Base Premium],
                    sum(isnull([Canx Premium],0)) [Canx Premium],
                    sum(isnull([Undiscounted Canx Premium],0)) [Undiscounted Canx Premium],
                    sum(isnull([Rental Car Premium],0)) [Rental Car Premium],
                    sum(isnull([Motorcycle Premium],0)) [Motorcycle Premium],
                    sum(isnull([Luggage Premium],0)) [Luggage Premium],
                    sum(isnull([Medical Premium],0)) [Medical Premium],
                    sum(isnull([Winter Sport Premium],0)) [Winter Sport Premium],
                    sum(isnull([Cruise Premium],0)) [Cruise Premium],

                    sum(isnull([Luggage Increase],0)) [Luggage Increase],
                    sum(isnull([Rental Car Increase],0)) [Rental Car Increase],
                    sum(isnull([Trip Cost],0)) [Trip Cost],
                    sum(isnull([Unadjusted Sell Price],0)) [Unadjusted Sell Price],
                    sum(isnull([Unadjusted GST on Sell Price],0)) [Unadjusted GST on Sell Price],
                    sum(isnull([Unadjusted Stamp Duty on Sell Price],0)) [Unadjusted Stamp Duty on Sell Price],
                    sum(isnull([Unadjusted Agency Commission],0)) [Unadjusted Agency Commission],
                    sum(isnull([Unadjusted GST on Agency Commission],0)) [Unadjusted GST on Agency Commission],
                    sum(isnull([Unadjusted Stamp Duty on Agency Commission],0)) [Unadjusted Stamp Duty on Agency Commission],
                    sum(isnull([Unadjusted Admin Fee],0)) [Unadjusted Admin Fee],
                    sum(isnull([Sell Price],0)) [Sell Price],
                    sum(isnull([GST on Sell Price],0)) [GST on Sell Price],
                    sum(isnull([Stamp Duty on Sell Price],0)) [Stamp Duty on Sell Price],
                    sum(isnull([Premium],0)) [Premium],
                    sum(isnull([Risk Nett],0)) [Risk Nett],
                    sum(isnull([GUG],0)) [GUG],
                    sum(isnull([Agency Commission],0)) [Agency Commission],
                    sum(isnull([GST on Agency Commission],0)) [GST on Agency Commission],
                    sum(isnull([Stamp Duty on Agency Commission],0)) [Stamp Duty on Agency Commission],
                    sum(isnull([Admin Fee],0)) [Admin Fee],
                    sum(isnull([NAP],0)) [NAP],
                    sum(isnull([NAP (incl Tax)],0)) [NAP (incl Tax)],
                    max(d.PolicyID) LastPolicyID,

                    sum(
                        case
                            when d.Category = 'Test policy' then 1
                            else 0
                        end
                    ) TestFlag,
                    sum(
                        case
                            when d.Category = 'Partial cancellation' then 1
                            else 0
                        end
                    ) PartialFlag,
                    sum(
                        case
                            when d.Category = 'Dummy policy' then 1
                            else 0
                        end
                    ) DummyFlag,
                    sum(
                        case
                            when d.Category = 'Commission adjustment' then 1
                            else 0
                        end
                    ) CommissionFlag,
                    sum(
                        case
                            when d.Category = 'Manual cancellation' then 1
                            when d.Category = 'Admin policy' then 1
                            else 0
                        end
                    ) AdminFlag,

                    sum([Policy Count]) [Policy Count],
                    max(convert(int, [Price Beat Policy])) [Price Beat Policy],
                    max([Competitor Name]) [Competitor Name],
                    sum([Competitor Price]) [Competitor Price],
					case when max(d.[Policy Status]) = 'Cancelled' then 'Cancelled' else 'Active' end as [Policy Status]

                from
                    ws.DWHDataSetTest d with(nolock)
                    cross apply
                    (
                        select
                            case
                                when [Transaction Type] = 'Price Beat' then 1
                                when [Sell Price] < 0 then -1
                                else 1
                            end ReturnFlag
                    ) f
                where
                    d.PolicyKey = h.PolicyKey
            ) d
            outer apply
            (
                select top 1
                    r.[Issue Date],
                    r.[Posting Date],
                    r.[Departure Date],
                    r.[Return Date],
                    r.[Lead Time],
                    r.[Maximum Trip Length],
                    r.[Trip Duration],
                    r.[Trip Length],
                    r.[Area Name],
                    r.[Area Number],
                    r.[Destination],
                    r.[Excess],
                    r.[Group Policy],
                    r.[Single/Family],
                    r.[Purchase Path],
                    r.[Product Code],
                    r.[Plan Code],
                    r.[Product Name],
                    r.[Product Plan],
                    r.[Product Type], 
                    r.[Product Group],
                    r.[Policy Type],
                    r.[Plan Type],
                    r.[Trip Type],
                    r.[Product Classification],
                    r.[Finance Product Code]
                from
                    ws.DWHDataSetTest r with(nolock)
                where
                    h.[TRIPS Policy] = 1 and
                    r.PolicyKey = h.PolicyKey and
                    r.PolicyID = d.LastPolicyID
            ) r
            cross apply
            (
                select
                    case
                        when 
                            h.[Charged Traveller 1 Gender] = 'U' or
                            h.[Charged Traveller 2 Gender] = 'U' or
                            h.[Charged Traveller 3 Gender] = 'U' or
                            h.[Charged Traveller 4 Gender] = 'U' or
                            h.[Charged Traveller 5 Gender] = 'U' or
                            h.[Charged Traveller 6 Gender] = 'U' or
                            h.[Charged Traveller 7 Gender] = 'U' or
                            h.[Charged Traveller 8 Gender] = 'U' or
                            h.[Charged Traveller 9 Gender] = 'U' or
                            h.[Charged Traveller 10 Gender] = 'U' 
                        then 'O'
                        else 
                        case
                            when 
                                h.[Charged Traveller 1 Gender] = 'F' or
                                h.[Charged Traveller 2 Gender] = 'F' or
                                h.[Charged Traveller 3 Gender] = 'F' or
                                h.[Charged Traveller 4 Gender] = 'F' or
                                h.[Charged Traveller 5 Gender] = 'F' or
                                h.[Charged Traveller 6 Gender] = 'F' or
                                h.[Charged Traveller 7 Gender] = 'F' or
                                h.[Charged Traveller 8 Gender] = 'F' or
                                h.[Charged Traveller 9 Gender] = 'F' or
                                h.[Charged Traveller 10 Gender] = 'F' 
                            then 'F'
                            else ''
                        end +
                        case
                            when 
                                h.[Charged Traveller 1 Gender] = 'M' or
                                h.[Charged Traveller 2 Gender] = 'M' or
                                h.[Charged Traveller 3 Gender] = 'M' or
                                h.[Charged Traveller 4 Gender] = 'M' or
                                h.[Charged Traveller 5 Gender] = 'M' or
                                h.[Charged Traveller 6 Gender] = 'M' or
                                h.[Charged Traveller 7 Gender] = 'M' or
                                h.[Charged Traveller 8 Gender] = 'M' or
                                h.[Charged Traveller 9 Gender] = 'M' or
                                h.[Charged Traveller 10 Gender] = 'M' 
                            then 'M'
                            else ''
                        end
                    end [Gender]
            ) gg
        where
            h.[Product Code] <> 'CMC' and
            h.isParent in (1, 2) and
            h.[Issue Date] >= @start and
            h.[Issue Date] <  dateadd(day, 1, @end)

        --get corporate policies
		insert into ws.[DWHDataSetSummaryTest] with(tablockx)
        (
            [Domain Country],
            [Company],
            [PolicyKey],
            [Base Policy No],
            [Policy Status],
            [Issue Date],
            [Posting Date],
        
            [Last Transaction Issue Date],
            [Last Transaction posting Date],
        
            [Departure Date],
            [Return Date],
            [Lead Time],
            [Maximum Trip Length],
            [Trip Duration],
            [Trip Length],
            [Area Name],
            [Area Number],
            [Destination],
            [Excess],
            [Group Policy],
        
            [Has Rental Car],
            [Has Motorcycle],
            [Has Wintersport],
            [Has Medical],
            [Has Cruise],
        
            [Single/Family],
            [Purchase Path],
            [TRIPS Policy],

            [Product Code],
            [Plan Code],
            [Product Name],
            [Product Plan],
            [Product Type], 
            [Product Group],
            [Policy Type],
            [Plan Type],
            [Trip Type],
            [Product Classification],
            [Finance Product Code],
                                
            [OutletKey],
            [Alpha Code],
        
            [Customer Post Code],
            [Unique Traveller Count],
            [Unique Charged Traveller Count],
            [Traveller Count],
            [Charged Traveller Count],
            [Adult Traveller Count],
            [EMC Traveller Count],
            [Youngest Charged DOB],
            [Oldest Charged DOB],
            [Youngest Age],
            [Oldest Age],
            [Youngest Charged Age],
            [Oldest Charged Age],
            [Max EMC Score],
            [Total EMC Score],
        
            [Gender],
            [Has EMC],
            [Has Manual EMC],

            [EMC Tier Oldest Charged],
            [EMC Tier Youngest Charged],

            [Charged Traveller 1 Gender],
            [Charged Traveller 1 DOB],
            [Charged Traveller 1 Has EMC],
            [Charged Traveller 1 Has Manual EMC],
            [Charged Traveller 1 EMC Score],
            [Charged Traveller 1 EMC Reference],
            [Charged Traveller 2 Gender],
            [Charged Traveller 2 DOB],
            [Charged Traveller 2 Has EMC],
            [Charged Traveller 2 Has Manual EMC],
            [Charged Traveller 2 EMC Score],
            [Charged Traveller 2 EMC Reference],
            [Charged Traveller 3 Gender],
            [Charged Traveller 3 DOB],
            [Charged Traveller 3 Has EMC],
            [Charged Traveller 3 Has Manual EMC],
            [Charged Traveller 3 EMC Score],
            [Charged Traveller 3 EMC Reference],
            [Charged Traveller 4 Gender],
            [Charged Traveller 4 DOB],
            [Charged Traveller 4 Has EMC],
            [Charged Traveller 4 Has Manual EMC],
            [Charged Traveller 4 EMC Score],
            [Charged Traveller 4 EMC Reference],
            [Charged Traveller 5 Gender],
            [Charged Traveller 5 DOB],
            [Charged Traveller 5 Has EMC],
            [Charged Traveller 5 Has Manual EMC],
            [Charged Traveller 5 EMC Score],
            [Charged Traveller 5 EMC Reference],
            [Charged Traveller 6 Gender],
            [Charged Traveller 6 DOB],
            [Charged Traveller 6 Has EMC],
            [Charged Traveller 6 Has Manual EMC],
            [Charged Traveller 6 EMC Score],
            [Charged Traveller 6 EMC Reference],
            [Charged Traveller 7 Gender],
            [Charged Traveller 7 DOB],
            [Charged Traveller 7 Has EMC],
            [Charged Traveller 7 Has Manual EMC],
            [Charged Traveller 7 EMC Score],
            [Charged Traveller 7 EMC Reference],
            [Charged Traveller 8 Gender],
            [Charged Traveller 8 DOB],
            [Charged Traveller 8 Has EMC],
            [Charged Traveller 8 Has Manual EMC],
            [Charged Traveller 8 EMC Score],
            [Charged Traveller 8 EMC Reference],
            [Charged Traveller 9 Gender],
            [Charged Traveller 9 DOB],
            [Charged Traveller 9 Has EMC],
            [Charged Traveller 9 Has Manual EMC],
            [Charged Traveller 9 EMC Score],
            [Charged Traveller 9 EMC Reference],
            [Charged Traveller 10 Gender],
            [Charged Traveller 10 DOB],
            [Charged Traveller 10 Has EMC],
            [Charged Traveller 10 Has Manual EMC],
            [Charged Traveller 10 EMC Score],
            [Charged Traveller 10 EMC Reference],
        
            [Commission Tier],
            [Volume Commission],
            [Discount],
        
            [Base Base Premium],
            [Base Premium],
            [Canx Premium],
            [Undiscounted Canx Premium],
            [Rental Car Premium],
            [Motorcycle Premium],
            [Luggage Premium],
            [Medical Premium],
            [Winter Sport Premium],
            [Cruise Premium],

            [Luggage Increase],
            [Rental Car Increase],
            [Trip Cost],
            [Unadjusted Sell Price],
            [Unadjusted GST on Sell Price],
            [Unadjusted Stamp Duty on Sell Price],
            [Unadjusted Agency Commission],
            [Unadjusted GST on Agency Commission],
            [Unadjusted Stamp Duty on Agency Commission],
            [Unadjusted Admin Fee],
            [Sell Price],
            [GST on Sell Price],
            [Stamp Duty on Sell Price],
            [Premium],
            [Risk Nett],
            [GUG],
            [Agency Commission],
            [GST on Agency Commission],
            [Stamp Duty on Agency Commission],
            [Admin Fee],
            [NAP],
            [NAP (incl Tax)],

            [Policy Count],
            [Price Beat Policy],
            [Competitor Name],
            [Competitor Price],
        
            Category
        )
        select 
            [Domain Country],
            [Company],
            [PolicyKey],
            [Base Policy No],
            [Policy Status],
            [Issue Date],
            [Posting Date],
        
            [Issue Date] [Last Transaction Issue Date],
            [Posting Date] [Last Transaction posting Date],
        
            [Departure Date],
            [Return Date],
            [Lead Time],
            [Maximum Trip Length],
            [Trip Duration],
            [Trip Length],
            [Area Name],
            [Area Number],
            [Destination],
            [Excess],
            [Group Policy],
        
            [Has Rental Car],
            [Has Motorcycle],
            [Has Wintersport],
            [Has Medical],
            [Has Cruise],
        
            [Single/Family],
            [Purchase Path],
            [TRIPS Policy],

            [Product Code],
            [Plan Code],
            [Product Name],
            [Product Plan],
            [Product Type], 
            [Product Group],
            [Policy Type],
            [Plan Type],
            [Trip Type],
            [Product Classification],
            [Finance Product Code],
                                
            [OutletKey],
            [Alpha Code],
        
            [Customer Post Code],
            [Unique Traveller Count],
            [Unique Charged Traveller Count],
            [Traveller Count],
            [Charged Traveller Count],
            [Adult Traveller Count],
            [EMC Traveller Count],
            [Youngest Charged DOB],
            [Oldest Charged DOB],
            [Youngest Age],
            [Oldest Age],
            [Youngest Charged Age],
            [Oldest Charged Age],
            [Max EMC Score],
            [Total EMC Score],
        
            'U' [Gender],
            '' [Has EMC],
            '' [Has Manual EMC],

            [EMC Tier Oldest Charged],
            [EMC Tier Youngest Charged],

            [Charged Traveller 1 Gender],
            [Charged Traveller 1 DOB],
            [Charged Traveller 1 Has EMC],
            [Charged Traveller 1 Has Manual EMC],
            [Charged Traveller 1 EMC Score],
            [Charged Traveller 1 EMC Reference],
            [Charged Traveller 2 Gender],
            [Charged Traveller 2 DOB],
            [Charged Traveller 2 Has EMC],
            [Charged Traveller 2 Has Manual EMC],
            [Charged Traveller 2 EMC Score],
            [Charged Traveller 2 EMC Reference],
            [Charged Traveller 3 Gender],
            [Charged Traveller 3 DOB],
            [Charged Traveller 3 Has EMC],
            [Charged Traveller 3 Has Manual EMC],
            [Charged Traveller 3 EMC Score],
            [Charged Traveller 3 EMC Reference],
            [Charged Traveller 4 Gender],
            [Charged Traveller 4 DOB],
            [Charged Traveller 4 Has EMC],
            [Charged Traveller 4 Has Manual EMC],
            [Charged Traveller 4 EMC Score],
            [Charged Traveller 4 EMC Reference],
            [Charged Traveller 5 Gender],
            [Charged Traveller 5 DOB],
            [Charged Traveller 5 Has EMC],
            [Charged Traveller 5 Has Manual EMC],
            [Charged Traveller 5 EMC Score],
            [Charged Traveller 5 EMC Reference],
            [Charged Traveller 6 Gender],
            [Charged Traveller 6 DOB],
            [Charged Traveller 6 Has EMC],
            [Charged Traveller 6 Has Manual EMC],
            [Charged Traveller 6 EMC Score],
            [Charged Traveller 6 EMC Reference],
            [Charged Traveller 7 Gender],
            [Charged Traveller 7 DOB],
            [Charged Traveller 7 Has EMC],
            [Charged Traveller 7 Has Manual EMC],
            [Charged Traveller 7 EMC Score],
            [Charged Traveller 7 EMC Reference],
            [Charged Traveller 8 Gender],
            [Charged Traveller 8 DOB],
            [Charged Traveller 8 Has EMC],
            [Charged Traveller 8 Has Manual EMC],
            [Charged Traveller 8 EMC Score],
            [Charged Traveller 8 EMC Reference],
            [Charged Traveller 9 Gender],
            [Charged Traveller 9 DOB],
            [Charged Traveller 9 Has EMC],
            [Charged Traveller 9 Has Manual EMC],
            [Charged Traveller 9 EMC Score],
            [Charged Traveller 9 EMC Reference],
            [Charged Traveller 10 Gender],
            [Charged Traveller 10 DOB],
            [Charged Traveller 10 Has EMC],
            [Charged Traveller 10 Has Manual EMC],
            [Charged Traveller 10 EMC Score],
            [Charged Traveller 10 EMC Reference],
        
            [Commission Tier],
            [Volume Commission],
            [Discount],
        
            d.[Base Base Premium],
            d.[Base Premium],
            d.[Canx Premium],
            d.[Undiscounted Canx Premium],
            d.[Rental Car Premium],
            d.[Motorcycle Premium],
            d.[Luggage Premium],
            d.[Medical Premium],
            d.[Winter Sport Premium],
            d.[Cruise Premium],

            d.[Luggage Increase],
            d.[Rental Car Increase],
            d.[Trip Cost],
            d.[Unadjusted Sell Price],
            d.[Unadjusted GST on Sell Price],
            d.[Unadjusted Stamp Duty on Sell Price],
            d.[Unadjusted Agency Commission],
            d.[Unadjusted GST on Agency Commission],
            d.[Unadjusted Stamp Duty on Agency Commission],
            d.[Unadjusted Admin Fee],
            d.[Sell Price],
            d.[GST on Sell Price],
            d.[Stamp Duty on Sell Price],
            d.[Premium],
            d.[Risk Nett],
            d.[GUG],
            d.[Agency Commission],
            d.[GST on Agency Commission],
            d.[Stamp Duty on Agency Commission],
            d.[Admin Fee],
            d.[NAP],
            d.[NAP (incl Tax)],
        
            1 [Policy Count],
            null [Price Beat Policy],
            null [Competitor Name],
            null [Competitor Price],

            '' Category
        
        from
            ws.DWHDataSetTest h with(nolock)
            cross apply
            (
                select 
                    sum(isnull([Base Base Premium],0)) [Base Base Premium],
                    sum(isnull([Base Premium],0)) [Base Premium],
                    sum(isnull([Canx Premium],0)) [Canx Premium],
                    sum(isnull([Undiscounted Canx Premium],0)) [Undiscounted Canx Premium],
                    sum(isnull([Rental Car Premium],0)) [Rental Car Premium],
                    sum(isnull([Motorcycle Premium],0)) [Motorcycle Premium],
                    sum(isnull([Luggage Premium],0)) [Luggage Premium],
                    sum(isnull([Medical Premium],0)) [Medical Premium],
                    sum(isnull([Winter Sport Premium],0)) [Winter Sport Premium],
                    sum(isnull([Cruise Premium],0)) [Cruise Premium],

                    sum(isnull([Luggage Increase],0)) [Luggage Increase],
                    sum(isnull([Rental Car Increase],0)) [Rental Car Increase],
                    sum(isnull([Trip Cost],0)) [Trip Cost],
                    sum(isnull([Unadjusted Sell Price],0)) [Unadjusted Sell Price],
                    sum(isnull([Unadjusted GST on Sell Price],0)) [Unadjusted GST on Sell Price],
                    sum(isnull([Unadjusted Stamp Duty on Sell Price],0)) [Unadjusted Stamp Duty on Sell Price],
                    sum(isnull([Unadjusted Agency Commission],0)) [Unadjusted Agency Commission],
                    sum(isnull([Unadjusted GST on Agency Commission],0)) [Unadjusted GST on Agency Commission],
                    sum(isnull([Unadjusted Stamp Duty on Agency Commission],0)) [Unadjusted Stamp Duty on Agency Commission],
                    sum(isnull([Unadjusted Admin Fee],0)) [Unadjusted Admin Fee],
                    sum(isnull([Sell Price],0)) [Sell Price],
                    sum(isnull([GST on Sell Price],0)) [GST on Sell Price],
                    sum(isnull([Stamp Duty on Sell Price],0)) [Stamp Duty on Sell Price],
                    sum(isnull([Premium],0)) [Premium],
                    sum(isnull([Risk Nett],0)) [Risk Nett],
                    sum(isnull([GUG],0)) [GUG],
                    sum(isnull([Agency Commission],0)) [Agency Commission],
                    sum(isnull([GST on Agency Commission],0)) [GST on Agency Commission],
                    sum(isnull([Stamp Duty on Agency Commission],0)) [Stamp Duty on Agency Commission],
                    sum(isnull([Admin Fee],0)) [Admin Fee],
                    sum(isnull([NAP],0)) [NAP],
                    sum(isnull([NAP (incl Tax)],0)) [NAP (incl Tax)],

                    min(d.BIRowID) Parent
                from
                    ws.DWHDataSetTest d with(nolock)
                where
                    d.PolicyKey = h.PolicyKey
            ) d
        where
            h.[Product Code] = 'CMC' and
            h.BIRowID = d.Parent and
            h.[Issue Date] >= @start and
            h.[Issue Date] <  dateadd(day, 1, @end)
        
        set @err = convert(varchar(10), @start, 120) + char(9) + convert(varchar, getdate(), 120)

        raiserror(@err, 1, 1) with nowait

        set @start = dateadd(month, 1, @start)

        fetch next from cMonth into @start

    end

    close cMonth
    deallocate cMonth

end

GO
