USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spPolicyDatasetTransform]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPolicyDatasetTransform]  
    @StartDate date,  
    @EndDate date  
      
as  
begin  
  
  
--20160725, LL, pe.EMCScore always 0, use e.MedicalRisk instead  
--20181206, LT, change plancode to use penPolicy if not null, else use penProductPlan  
--20190430, LT, added [Plan Name] column to data set  
  
/*  
declare @StartDate date  
declare @EndDate date  
select @StartDate = '2019-05-01', @EndDate = '2019-05-03'  
*/  
  
    if object_id('ws.DWHDataSet') is null  
    begin  
  
        create table ws.[DWHDataSet]  
        (  
            [BIRowID] bigint not null identity(1,1),  
            [Domain Country] [varchar](2) null,  
            [Company] [varchar](5) null,  
              
            [PolicyKey] [varchar](41) null,  
            [PolicyTransactionKey] [varchar](41) null,  
            [isParent] [int] null,  
         [Base Policy No] [varchar](50) null,  
         [Policy No] [varchar](50) null,  
         [Issue Date] [datetime] null,  
         [Transaction Issue Date] [datetime] null,  
         [Posting Date] [datetime] null,  
         [Transaction Type] [varchar](50) null,  
         [Policy Status] [varchar](50) null,  
         [Transaction Status] [varchar](50) null,  
  
         [Departure Date] [datetime] null,  
         [Return Date] [datetime] null,  
         [Lead Time] [int] null,  
         [Maximum Trip Length] [int] null,  
         [Trip Duration] [int] null,  
         [Trip Length] [int] null,  
         [Area Name] [nvarchar](150) null,  
         [Area Number] [varchar](100) null,  
         [Destination] [nvarchar](max) null,  
         [Excess] [int] null,  
         [Group Policy] [int] null,  
         [Has Rental Car] [bit] null,  
         [Has Motorcycle] [bit] null,  
         [Has Wintersport] [bit] null,  
         [Has Medical] [bit] null,  
            [Has Cruise] [bit] null,  
  
         [Single/Family] [nvarchar](1) null,  
         [Purchase Path] [nvarchar](50) null,  
         [TRIPS Policy] [bit] null,  
  
         [Product Code] [nvarchar](50) null,  
         [Plan Code] [nvarchar](50) null,  
   [Plan Name] [nvarchar](100) null,  
         [Product Name] [nvarchar](100) null,  
         [Product Plan] [nvarchar](100) null,  
         [Product Type] [nvarchar](100) null,           
         [Product Group] [nvarchar](100) null,  
         [Policy Type] [nvarchar](50) null,  
         [Plan Type] [nvarchar](50) null,  
         [Trip Type] [nvarchar](50) null,  
           
         [Product Classification] [nvarchar](100) null,  
         [Finance Product Code] [nvarchar](50) null,  
                             
         [OutletKey] [varchar](33) null,  
         [Alpha Code] [nvarchar](20) null,  
         [Original Alpha Code] [nvarchar](20) null,  
         [Transaction Alpha Code] [nvarchar](20) null,  
         [Transaction OutletKey] [varchar](33) null,  
           
         [Customer Post Code] [nvarchar](50) null,  
         [Unique Traveller Count] [int] null,  
         [Unique Charged Traveller Count] [int] null,  
         [Traveller Count] [int] null,  
         [Charged Traveller Count] [int] null,  
         [Adult Traveller Count] [int] null,  
         [EMC Traveller Count] [int] null,  
         [Youngest Charged DOB] [datetime] null,  
         [Oldest Charged DOB] [datetime] null,  
         [Youngest Age] [int] null,  
         [Oldest Age] [int] null,  
         [Youngest Charged Age] [int] null,  
         [Oldest Charged Age] [int] null,  
            [Max EMC Score] [numeric](18,2) null,  
            [Total EMC Score] [numeric](18,2) null,  
  
            [EMC Tier Oldest Charged] [int] null,  
            [EMC Tier Youngest Charged] [int] null,  
  
         [Charged Traveller 1 Gender] [nchar](2) null,  
         [Charged Traveller 1 DOB] [date] null,  
         [Charged Traveller 1 Has EMC] [smallint] null,  
         [Charged Traveller 1 Has Manual EMC] [bit] null,  
         [Charged Traveller 1 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 1 EMC Reference] [int] null,  
     [Charged Traveller 2 Gender] [nchar](2) null,  
         [Charged Traveller 2 DOB] [date] null,  
         [Charged Traveller 2 Has EMC] [smallint] null,  
         [Charged Traveller 2 Has Manual EMC] [bit] null,  
         [Charged Traveller 2 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 2 EMC Reference] [int] null,  
         [Charged Traveller 3 Gender] [nchar](2) null,  
         [Charged Traveller 3 DOB] [date] null,  
         [Charged Traveller 3 Has EMC] [smallint] null,  
         [Charged Traveller 3 Has Manual EMC] [bit] null,  
         [Charged Traveller 3 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 3 EMC Reference] [int] null,  
         [Charged Traveller 4 Gender] [nchar](2) null,  
         [Charged Traveller 4 DOB] [date] null,  
         [Charged Traveller 4 Has EMC] [smallint] null,  
         [Charged Traveller 4 Has Manual EMC] [bit] null,  
         [Charged Traveller 4 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 4 EMC Reference] [int] null,  
         [Charged Traveller 5 Gender] [nchar](2) null,  
         [Charged Traveller 5 DOB] [date] null,  
         [Charged Traveller 5 Has EMC] [smallint] null,  
         [Charged Traveller 5 Has Manual EMC] [bit] null,  
         [Charged Traveller 5 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 5 EMC Reference] [int] null,  
         [Charged Traveller 6 Gender] [nchar](2) null,  
         [Charged Traveller 6 DOB] [date] null,  
         [Charged Traveller 6 Has EMC] [smallint] null,  
         [Charged Traveller 6 Has Manual EMC] [bit] null,  
         [Charged Traveller 6 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 6 EMC Reference] [int] null,  
         [Charged Traveller 7 Gender] [nchar](2) null,  
         [Charged Traveller 7 DOB] [date] null,  
         [Charged Traveller 7 Has EMC] [smallint] null,  
         [Charged Traveller 7 Has Manual EMC] [bit] null,  
         [Charged Traveller 7 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 7 EMC Reference] [int] null,  
         [Charged Traveller 8 Gender] [nchar](2) null,  
         [Charged Traveller 8 DOB] [date] null,  
         [Charged Traveller 8 Has EMC] [smallint] null,  
         [Charged Traveller 8 Has Manual EMC] [bit] null,  
         [Charged Traveller 8 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 8 EMC Reference] [int] null,  
         [Charged Traveller 9 Gender] [nchar](2) null,  
         [Charged Traveller 9 DOB] [date] null,  
         [Charged Traveller 9 Has EMC] [smallint] null,  
         [Charged Traveller 9 Has Manual EMC] [bit] null,  
         [Charged Traveller 9 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 9 EMC Reference] [int] null,  
         [Charged Traveller 10 Gender] [nchar](2) null,  
         [Charged Traveller 10 DOB] [date] null,  
         [Charged Traveller 10 Has EMC] [smallint] null,  
         [Charged Traveller 10 Has Manual EMC] [bit] null,  
         [Charged Traveller 10 EMC Score] [decimal](18,2) null,  
         [Charged Traveller 10 EMC Reference] [int] null,  
  
         [Commission Tier] [varchar](50) null,  
         [Volume Commission] [money] null,  
         [Discount] [money] null,  
  
         [Base Base Premium] [money] null,  
         [Base Premium] [money] null,  
         [Canx Premium] [money] null,  
         [Undiscounted Canx Premium] [money] null,  
         [Rental Car Premium] [money] null,  
         [Motorcycle Premium] [money] null,  
         [Luggage Premium] [money] null,  
         [Medical Premium] [money] null,  
         [Winter Sport Premium] [money] null,  
            [Cruise Premium] [money] null,  
  
         [Luggage Increase] [money] null,  
            [Rental Car Increase] [money] null,  
         [Trip Cost] [int] null,  
  
            [Unadjusted Sell Price] [money] null,  
            [Unadjusted GST on Sell Price] [money] null,  
            [Unadjusted Stamp Duty on Sell Price] [money] null,  
            [Unadjusted Agency Commission] [money] null,  
            [Unadjusted GST on Agency Commission] [money] null,  
            [Unadjusted Stamp Duty on Agency Commission] [money] null,  
            [Unadjusted Admin Fee] [money] null,  
            [Sell Price] [money] null,  
            [GST on Sell Price] [money] null,  
            [Stamp Duty on Sell Price] [money] null,  
            [Premium] [money] null,  
            [Risk Nett] [money] null,  
            [GUG] [money] null,  
            [Agency Commission] [money] null,  
            [GST on Agency Commission] [money] null,  
            [Stamp Duty on Agency Commission] [money] null,  
            [Admin Fee] [money] null,  
            [NAP] [money] null,  
            [NAP (incl Tax)] [money] null,  
  
            [Policy Count] [int] null,  
            [Price Beat Policy] [bit] null,  
            [Competitor Name] [nvarchar](50) null,  
            [Competitor Price] [money] null,  
           
         PolicyID int,  
            Category varchar(100) not null default '',  
            constraint PK_DWHDataSet primary key nonclustered (BIRowID)  
        )  
          
        create clustered index idx_DWHDataSet_BIRowID on ws.DWHDataSet(BIRowID)  
        create nonclustered index idx_DWHDataSet_IssueDate on ws.DWHDataSet([Issue Date])  
        create nonclustered index idx_DWHDataSet_PostingDate on ws.DWHDataSet([Posting Date]) include   
            (  
                [Domain Country],  
                [Company],  
                [PolicyKey],  
                [PolicyTransactionKey],  
             [Policy No],  
             [Issue Date],  
             [Finance Product Code],  
             [OutletKey],  
             [Alpha Code],  
                [Policy Count],  
                [Sell Price],  
                [Agency Commission],  
                [Premium]  
            )  
        create nonclustered index idx_DWHDataSet_PolicyNo on ws.DWHDataSet([Policy No])  
        create nonclustered index idx_DWHDataSet_BasePolicyNo on ws.DWHDataSet([Base Policy No])  
  
        create nonclustered index idx_DWHDataSet_PolicyKey on ws.DWHDataSet(PolicyKey) include   
            (  
                [TRIPS Policy],  
                [Transaction Type],  
                [Transaction Status],  
                [Issue Date],  
                [Posting Date],  
                [Departure Date],  
                [Return Date],  
                [Has Rental Car],  
                [Has Motorcycle],  
                [Has Wintersport],  
                [Has Medical],  
                [Has Cruise],  
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
                PolicyID,  
                PolicyTransactionKey,  
Category  
         )  
  
    end  
  
    delete   
    from  
        ws.DWHDataSet  
    where  
        [Posting Date] >= @StartDate and  
        [Posting Date] <  dateadd(day, 1, @EndDate)  
  
    insert into ws.DWHDataSet with(tablock)  
    (  
        [Domain Country],  
        [Company],  
          
        [PolicyKey],  
        [PolicyTransactionKey],  
        [isParent],  
        [Base Policy No],  
        [Policy No],  
        [Issue Date],  
        [Transaction Issue Date],  
        [Posting Date],  
        [Transaction Type],  
        [Policy Status],  
        [Transaction Status],  
  
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
  [Plan Name],  
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
        [Original Alpha Code],  
        [Transaction Alpha Code],  
        [Transaction OutletKey],  
          
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
          
        PolicyID,  
        Category  
    )  
  
    /* penguin policies */  
    select   
        p.CountryKey [Domain Country],  
        p.CompanyKey [Company],  
  
        p.[PolicyKey],  
        pt.[PolicyTransactionKey],  
        case  
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then 1  
            when pt.PolicyNumber = p.PolicyNumber then 2  
            else 0  
        end [isParent],  
        p.PolicyNumber [Base Policy No],  
        pt.PolicyNumber [Policy No],  
        p.IssueDate [Issue Date],  
        pt.IssueDate [Transaction Issue Date],  
        pt.PostingDate [Posting Date],  
        pt.TransactionType [Transaction Type],  
        p.StatusDescription [Policy Status],  
        pt.TransactionStatus [Transaction Status],  
        p.TripStart [Departure Date],  
        p.TripEnd [Return Date],  
        datediff(day, p.IssueDate, p.TripStart) [Lead Time],  
        isnull(p.MaxDuration, 0) [Maximum Trip Length],  
        p.MaxDuration [Trip Duration],  
        datediff(d, p.TripStart, p.TripEnd) + 1 [Trip Length],  
        isnull(p.AreaName, p.Area) [Area Name],  
        pp.AreaNumber [Area Number],  
        p.PrimaryCountry [Destination],  
        p.[Excess],  
        case   
            when p.GroupName like '%@%.%' and [Charged Traveller Count] < 5 then 0  
            when isnull(p.GroupName, '') <> '' then 1  
            else 0  
        end [Group Policy],  
        case   
            when isnull([Rental Car Premium], 0) <> 0 then 1  
            else 0  
        end [Has Rental Car],  
        case   
            when isnull([Motorcycle Premium], 0) <> 0 then 1  
            else 0  
        end [Has Motorcycle],  
        case   
            when isnull([Winter Sport Premium], 0) <> 0 then 1  
            else 0  
        end [Has Wintersport],  
        case   
            when isnull([Medical Premium], 0) <> 0 then 1  
            else 0  
        end [Has Medical],  
        case   
            when isnull([Cruise Premium], 0) <> 0 then 1  
            else 0  
        end [Has Cruise],  
  
        pp.[Single/Family],  
        isnull(p.PurchasePath, '') [Purchase Path],  
        0 [TRIPS Policy],  
  
        p.ProductCode [Product Code],  
  case when p.isTripsPolicy = 0 and p.PlanCode is not null then p.PlanCode  
        else pp.[Plan Code]  
  end as [Plan Code],  
          
  case when p.isTripsPolicy = 0 and p.PlanCode is not null then p.PlanName  
    else pp.[Plan Name]  
  end as [Plan Name],  
        dp.[Product Name],  
        dp.[Product Plan],  
        dp.[Product Type],   
        dp.[Product Group],  
        dp.[Policy Type],  
        dp.[Plan Type],  
        dp.[Trip Type],  
        dp.[Product Classification],  
        dp.[Finance Product Code],  
  
        o.[OutletKey],  
        upper(o.AlphaCode) [Alpha Code],  
        upper(o.AlphaCode) [Original Alpha Code],  
        upper(pto.AlphaCode) [Transaction Alpha Code],  
        pto.OutletKey [Transaction OutletKey],  
          
        [Customer Post Code],  
        [Unique Traveller Count],  
        [Unique Charged Traveller Count],  
        [Traveller Count],  
        [Charged Traveller Count],  
        [Adult Traveller Count],  
        petc.[EMC Traveller Count],  
        [Youngest Charged DOB],  
        [Oldest Charged DOB],  
  
        --follow SAS calculation  
        --datediff(year, [Youngest DOB], p.IssueDate) [Youngest Age],  
        --datediff(year, [Oldest DOB], p.IssueDate) [Oldest Age],  
  
        --SAS calculation  
        --floor((intck('month', Oldest_Ch_DoB, d_PPDiss) - (day(d_PPDiss) < day(Oldest_Ch_DoB))) / 12)  
        case  
            when p.IssueDate is null or [Youngest DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Youngest DOB], p.IssueDate) -  
                        case  
                            when datepart(day, p.IssueDate) < datepart(day, [Youngest DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Youngest Age],  
        case  
            when p.IssueDate is null or [Oldest DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Oldest DOB], p.IssueDate) -  
                        case  
                            when datepart(day, p.IssueDate) < datepart(day, [Oldest DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Oldest Age],  
        case  
            when p.IssueDate is null or [Youngest Charged DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Youngest Charged DOB], p.IssueDate) -  
                        case  
                            when datepart(day, p.IssueDate) < datepart(day, [Youngest Charged DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Youngest Charged Age],  
        case  
            when p.IssueDate is null or [Oldest Charged DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Oldest Charged DOB], p.IssueDate) -  
                        case  
                            when datepart(day, p.IssueDate) < datepart(day, [Oldest Charged DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Oldest Charged Age],  
  
        isnull(es.[Max EMC Score], 0) [Max EMC Score],  
        isnull(es.[Total EMC Score], 0) [Total EMC Score],  
  
        null [EMC Tier Oldest Charged],  
        null [EMC Tier Youngest Charged],  
  
        pptvl.[Charged Traveller 1 Gender],  
        pptvl.[Charged Traveller 1 DOB],  
        pptvl.[Charged Traveller 1 Has EMC],  
        pptvl.[Charged Traveller 1 Has Manual EMC],  
        pptvl.[Charged Traveller 1 EMC Score],  
        pptvl.[Charged Traveller 1 EMC Reference],  
pptvl.[Charged Traveller 2 Gender],  
        pptvl.[Charged Traveller 2 DOB],  
        pptvl.[Charged Traveller 2 Has EMC],  
        pptvl.[Charged Traveller 2 Has Manual EMC],  
        pptvl.[Charged Traveller 2 EMC Score],  
        pptvl.[Charged Traveller 2 EMC Reference],  
        pptvl.[Charged Traveller 3 Gender],  
        pptvl.[Charged Traveller 3 DOB],  
        pptvl.[Charged Traveller 3 Has EMC],  
        pptvl.[Charged Traveller 3 Has Manual EMC],  
        pptvl.[Charged Traveller 3 EMC Score],  
        pptvl.[Charged Traveller 3 EMC Reference],  
        pptvl.[Charged Traveller 4 Gender],  
        pptvl.[Charged Traveller 4 DOB],  
        pptvl.[Charged Traveller 4 Has EMC],  
        pptvl.[Charged Traveller 4 Has Manual EMC],  
        pptvl.[Charged Traveller 4 EMC Score],  
        pptvl.[Charged Traveller 4 EMC Reference],  
        pptvl.[Charged Traveller 5 Gender],  
        pptvl.[Charged Traveller 5 DOB],  
        pptvl.[Charged Traveller 5 Has EMC],  
        pptvl.[Charged Traveller 5 Has Manual EMC],  
        pptvl.[Charged Traveller 5 EMC Score],  
        pptvl.[Charged Traveller 5 EMC Reference],  
        pptvl.[Charged Traveller 6 Gender],  
        pptvl.[Charged Traveller 6 DOB],  
        pptvl.[Charged Traveller 6 Has EMC],  
        pptvl.[Charged Traveller 6 Has Manual EMC],  
        pptvl.[Charged Traveller 6 EMC Score],  
        pptvl.[Charged Traveller 6 EMC Reference],  
        pptvl.[Charged Traveller 7 Gender],  
        pptvl.[Charged Traveller 7 DOB],  
        pptvl.[Charged Traveller 7 Has EMC],  
        pptvl.[Charged Traveller 7 Has Manual EMC],  
        pptvl.[Charged Traveller 7 EMC Score],  
        pptvl.[Charged Traveller 7 EMC Reference],  
        pptvl.[Charged Traveller 8 Gender],  
        pptvl.[Charged Traveller 8 DOB],  
        pptvl.[Charged Traveller 8 Has EMC],  
        pptvl.[Charged Traveller 8 Has Manual EMC],  
        pptvl.[Charged Traveller 8 EMC Score],  
        pptvl.[Charged Traveller 8 EMC Reference],  
        pptvl.[Charged Traveller 9 Gender],  
        pptvl.[Charged Traveller 9 DOB],  
        pptvl.[Charged Traveller 9 Has EMC],  
        pptvl.[Charged Traveller 9 Has Manual EMC],  
        pptvl.[Charged Traveller 9 EMC Score],  
        pptvl.[Charged Traveller 9 EMC Reference],  
        pptvl.[Charged Traveller 10 Gender],  
        pptvl.[Charged Traveller 10 DOB],  
        pptvl.[Charged Traveller 10 Has EMC],  
        pptvl.[Charged Traveller 10 Has Manual EMC],  
        pptvl.[Charged Traveller 10 EMC Score],  
        pptvl.[Charged Traveller 10 EMC Reference],  
  
        pt.CommissionTier [Commission Tier],  
        pt.VolumeCommission [Volume Commission],  
        pt.[Discount],  
  
        bbp.[Base Base Premium],  
        pt.BasePremium [Base Premium],  
        pap.[Canx Premium],  
        pap.[Undiscounted Canx Premium],  
        pap.[Rental Car Premium],  
        pap.[Motorcycle Premium],  
        pap.[Luggage Premium],  
        pap.[Medical Premium],  
        pap.[Winter Sport Premium],  
        pap.[Cruise Premium],  
  
        ll.[Luggage Increase],  
        ll.[Rental Car Increase],  
        pt.CanxCover [Trip Cost],  
  
        ppp.[Unadjusted Sell Price],  
        ppp.[Unadjusted GST on Sell Price],  
        ppp.[Unadjusted Stamp Duty on Sell Price],  
        ppp.[Unadjusted Agency Commission],  
        ppp.[Unadjusted GST on Agency Commission],  
        ppp.[Unadjusted Stamp Duty on Agency Commission],  
        pt.UnAdjGrossAdminFee [Unadjusted Admin Fee],  
        ppp.[Sell Price],  
        ppp.[GST on Sell Price],  
        ppp.[Stamp Duty on Sell Price],  
        ppp.Premium,  
        ppp.[Risk Nett],  
        gug.GUG,  
        ppp.[Agency Commission],  
        ppp.[GST on Agency Commission],  
        ppp.[Stamp Duty on Agency Commission],  
        pt.GrossAdminFee [Admin Fee],  
        ppp.NAP,  
        ppp.[NAP (incl Tax)],  
  
        pt.BasePolicyCount [Policy Count],  
        pt.isPriceBeat [Price Beat Policy],  
        pcmp.CompetitorName [Competitor Name],  
        pcmp.CompetitorPrice [Competitor Price],  
          
        pt.PolicyTransactionID PolicyID,  
          
        case  
            when o.OutletName like '%test %' then 'Test policy'  
            when o.OutletName like '% test%' then 'Test policy'  
            when o.OutletName = 'test' then 'Test policy'  
            when pt.UserComments like '%partial%' then 'Partial cancellation'  
            when pt.UserComments like '%override%' then 'Partial cancellation'  
            when pt.UserComments like '%overide%' then 'Partial cancellation'  
            when pt.TransactionType like '%partial%' then 'Partial cancellation'  
            when pt.TransactionStatus like '%with%' then 'Partial cancellation'  
            --20170623, Kobe's question  
            when pt.PostingDate >= '2013-07-01' then   
                case  
                    when pt.UserComments like '%DP%' then 'Dummy policy'  
                    when pt.UserComments like '%D/P%' then 'Dummy policy'  
                    when pt.UserComments like '%top up%' then 'Dummy policy'  
                    when pt.UserComments like '%write off%' then 'Dummy policy'  
                    when pt.UserComments like '%offset%' then 'Dummy policy'  
                    when pt.UserComments like '%dummy%' then 'Dummy policy'  
                    when pt.UserComments like '%staff%' then 'Dummy policy'  
                    when pac.CallComment like '%dummy%' then 'Dummy policy'  
                    when pac.CallComment like '%comm%' then 'Commission adjustment'  
                    when p.PolicyNumber like '94%' then 'Manual cancellation'  
                    when p.PolicyNumber like '4%' and len(p.PolicyNumber) <= 8 then 'Admin policy'  
     else ''  
                end  
            else ''  
        end Category  
    from  
        [db-au-cba]..penPolicyTransSummary pt with(nolock)  
        inner join [db-au-cba]..penPolicy p with(nolock) on  
            p.PolicyKey = pt.PolicyKey  
        outer apply  
        (  
            select top 1   
                pcmp.CompetitorName,  
                pcmp.CompetitorPrice  
            from  
                [db-au-cba]..penPolicyCompetitor pcmp  
            where  
                pcmp.PolicyKey = p.PolicyKey  
        ) pcmp  
        cross apply  
        (  
            select top 1   
                o.[OutletKey],  
                o.AlphaCode,  
                o.OutletName  
            from  
                [db-au-cba]..penOutlet o with(nolock)  
            where  
                o.OutletAlphaKey = p.OutletAlphaKey and  
                o.OutletStatus = 'Current'  
        ) o  
        outer apply  
        (  
            select top 1   
                o.[OutletKey],  
                o.AlphaCode  
            from  
                [db-au-cba]..penOutlet o with(nolock)  
            where  
                o.OutletAlphaKey = pt.OutletAlphaKey and  
                o.OutletStatus = 'Current'  
        ) pto  
        outer apply  
        (  
            select  
                sum(pap.Cancellation) [Canx Premium],  
                sum(pap.RentalCar) [Rental Car Premium],  
                sum(pap.Motorcycle) [Motorcycle Premium],  
                sum(pap.Luggage) [Luggage Premium],  
                sum(pap.Medical) [Medical Premium],  
                sum(pap.CancellationUnadj) [Undiscounted Canx Premium],  
                sum(pap.WinterSport) [Winter Sport Premium],  
                sum(pap.Cruise) [Cruise Premium]  
            from  
                [db-au-cba]..vPenPolicyAddonPremium pap with(nolock)  
            where  
                pap.PolicyTransactionKey = pt.PolicyTransactionKey  
        ) pap  
        outer apply  
        (  
            select top 1  
                pp.PlanCode [Plan Code],  
    pp.PlanName [Plan Name],  
                case  
                    when pp.PlanName like '%Single%' then 'S'  
                    when pp.PlanName like '%Family%' then 'F'  
                    when pp.PlanName like '%-S-%' then 'S'  
               when pp.PlanName like '%-F-%' then 'F'  
                    when pp.PlanName like '%-S' then 'S'  
                    when pp.PlanName like '%-F' then 'F'  
                    when pp.PlanName like '%-D' then 'D'  
                    when pp.PlanName like '%-Single' then 'S'  
                    when pp.PlanName like '%-Family' then 'F'  
                    when pp.PlanName like '%-Double' then 'D'  
                    when pp.TravellerSetName like '%Single%' then 'S'  
                    when pp.TravellerSetName like '%Duo%' then 'D'  
                    when pp.TravellerSetName like '%Family%' then 'F'  
                    else 'S'  
                end [Single/Family],  
                a.AreaNumber  
            from  
    [db-au-cba].dbo.penProductPlan pp with(nolock)  
                inner join [db-au-cba].dbo.penArea a with(nolock) on  
                    a.AreaID = pp.AreaID and  
                    a.CountryKey = pp.CountryKey  
            where  
                pp.OutletKey = o.OutletKey and  
                pp.ProductId = p.ProductID and  
                pp.UniquePlanId = p.UniquePlanID and  
                (  
                    a.AreaName = isnull(p.AreaName, p.Area) or  
                    pp.AMTUpsellDisplayName = isnull(p.AreaName, p.Area)  
                )  
        ) pp  
        outer apply  
        (  
            select top 1   
                ProductSK  
            from  
                [db-au-star]..factPolicyTransaction fpt with(nolock)  
            where  
                fpt.PolicyTransactionKey = pt.PolicyTransactionKey  
        ) fpt  
        outer apply  
        (  
            select top 1   
                dp.ProductName [Product Name],  
                dp.ProductPlan [Product Plan],  
                dp.ProductType [Product Type],   
                dp.ProductGroup [Product Group],  
                dp.PolicyType [Policy Type],  
                dp.PlanType [Plan Type],  
                dp.TripType [Trip Type],  
                dp.ProductClassification [Product Classification],  
                dp.FinanceProductCode [Finance Product Code]  
            from  
                [db-au-star]..dimProduct dp  
            where  
                (  
                    --penguin in star  
                    dp.ProductSK = fpt.ProductSK  
                ) or  
                (  
                    --penguin not in star  
                    pt.PostingDate < '2011-07-01' and  
                    ProductCode = p.ProductCode and  
                    ProductPlan like '%' + pp.[Plan Code]  
                ) or  
                (  
                    pt.PostingDate < '2011-07-01' and  
                    ProductCode = p.ProductCode and  
                    pp.[Plan Code] = 'DA' and  
                    dp.ProductPlan like '% ' + pp.[Plan Code] + '%'  
                )  
        ) dp  
        outer apply  
        (  
            select top 1  
                [Pricing Exposure Measure] GUG  
            from  
                [db-au-cba]..vPenguinPolicyUWPremiums gug with(nolock)  
            where  
                gug.PolicyTransactionKey = pt.PolicyTransactionKey  
        ) gug  
        outer apply  
        (  
            select top 1  
                ppp.[Unadjusted Sell Price],  
                ppp.[Unadjusted GST on Sell Price],  
                ppp.[Unadjusted Stamp Duty on Sell Price],  
                ppp.[Unadjusted Agency Commission],  
                ppp.[Unadjusted GST on Agency Commission],  
                ppp.[Unadjusted Stamp Duty on Agency Commission],  
                ppp.[Sell Price],  
                ppp.[GST on Sell Price],  
                ppp.[Stamp Duty on Sell Price],  
                ppp.Premium,  
                ppp.[Risk Nett],  
                ppp.[Agency Commission],  
                ppp.[GST on Agency Commission],  
                ppp.[Stamp Duty on Agency Commission],  
                ppp.NAP,  
                ppp.[NAP (incl Tax)]  
            from  
      [db-au-cba]..vPenguinPolicyPremiums ppp with(nolock)  
            where  
                ppp.PolicyTransactionKey = pt.PolicyTransactionKey  
        ) ppp  
        outer apply  
        (  
            select   
                max(  
                    case  
                        when ptv.isPrimary = 1 then ptv.PostCode  
                        else null  
                    end  
                ) [Customer Post Code],  
                count(distinct ltrim(rtrim(isnull(ptv.FirstName, ''))) + ltrim(rtrim(isnull(ptv.LastName, ''))) + isnull(convert(varchar(10), ptv.DOB, 120), '')) [Unique Traveller Count],  
                count(ptv.PolicyTravellerKey) [Traveller Count],  
                sum(  
                    case  
                        --Zem's email on 20170828, AP issue  
                        --when ptv.AdultCharge > 0 then 1  
                        when ptv.AdultCharge = 1 then 1  
                        else 0  
                    end  
                ) [Charged Traveller Count],  
                count(  
                    distinct   
                    case  
                        --Zem's email on 20170828, AP issue  
                        --when ptv.AdultCharge > 0 then ltrim(rtrim(isnull(ptv.FirstName, ''))) + ltrim(rtrim(isnull(ptv.LastName, ''))) + isnull(convert(varchar(10), ptv.DOB, 120), '')  
                        when ptv.AdultCharge = 1 then ltrim(rtrim(isnull(ptv.FirstName, ''))) + ltrim(rtrim(isnull(ptv.LastName, ''))) + isnull(convert(varchar(10), ptv.DOB, 120), '')  
                        else null  
                    end  
                ) [Unique Charged Traveller Count],  
                sum(  
                    case  
                        when ptv.isAdult = 1 then 1  
                        else 0  
                    end  
                ) [Adult Traveller Count],  
                min(  
                    case  
                        when ptv.DOB = '1900-01-01' then null  
                        else ptv.DOB  
                    end  
                ) [Oldest DOB],  
                max(  
                    case  
                        when ptv.DOB = '1900-01-01' then null  
                        else ptv.DOB  
                    end  
                ) [Youngest DOB],  
                min(  
                    case   
                        when ptv.DOB = '1900-01-01' then null  
                        --Zem's email on 20170828, AP issue  
                        --when ptv.AdultCharge > 0 then ptv.DOB  
                        when ptv.AdultCharge = 1 then ptv.DOB  
                        else null  
                    end  
                ) [Oldest Charged DOB],  
                max(  
                    case   
                        when ptv.DOB = '1900-01-01' then null  
                        --Zem's email on 20170828, AP issue  
                        --when ptv.AdultCharge > 0 then ptv.DOB  
                        when ptv.AdultCharge = 1 then ptv.DOB  
                        else null  
                    end  
                ) [Youngest Charged DOB]  
            from  
                [db-au-cba]..penPolicyTraveller ptv with(nolock)  
            where  
                ptv.PolicyKey = p.PolicyKey  
        ) ptv  
        outer apply  
        (  
            select   
                count(  
                    distinct   
                    case  
                        when isnull(petc.EMCPremium, 0) <> 0 then petc.PolicyTravellerKey  
                        else null  
                    end  
                ) [EMC Traveller Count]  
            from  
                (  
                    select   
                        ltrim(rtrim(isnull(ptv.FirstName, ''))) + ltrim(rtrim(isnull(ptv.LastName, ''))) + isnull(convert(varchar(10), ptv.DOB, 120), '') PolicyTravellerKey,  
                        sum(isnull(pp.GrossPremiumAfterDiscount, 0)) EMCPremium  
                    from  
                        [db-au-cba]..penPolicyTraveller ptv with(nolock)  
                        inner join [db-au-cba]..penPolicyTravellerTransaction ptt with(nolock) on  
                            ptt.PolicyTravellerKey = ptv.PolicyTravellerKey  
                        inner join [db-au-cba]..penPolicyEMC pe with(nolock) on  
                            pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey  
                        inner join [db-au-cba]..vpenPolicyPrice pp with(nolock) on  
                            pp.CountryKey = ptt.CountryKey and  
                            pp.CompanyKey = ptt.CompanyKey and  
                            pp.ComponentID = pe.PolicyEMCID and  
                            pp.GroupID = 5  
                    where  
                        ptv.PolicyKey = p.PolicyKey  
                    group by  
                        ltrim(rtrim(isnull(ptv.FirstName, ''))) + ltrim(rtrim(isnull(ptv.LastName, ''))) + isnull(convert(varchar(10), ptv.DOB, 120), '')  
                ) petc  
        ) petc  
        outer apply  
        (  
            select top 1  
                [Max EMC Score],  
                [Total EMC Score]  
            from  
                [db-au-actuary].ws.EMCGroupScore es  
            where  
                es.SourceSystem = 'Penguin' and  
                es.SourceKey = p.PolicyKey  
        ) es  
        outer apply  
        (  
            select   
                sum(  
                    case  
                        when pta.AddOnGroup = 'Luggage' then CoverIncrease  
                        else 0  
                    end  
                ) * (BasePolicyCount + AddonPolicyCount) [Luggage Increase],  
                sum(  
                    case  
                        when pta.AddOnGroup = 'Rental Car' then CoverIncrease  
                        else 0  
                    end  
                ) * (BasePolicyCount + AddonPolicyCount) [Rental Car Increase]  
            from  
                [db-au-cba]..penPolicyTransAddOn pta with(nolock)   
            where  
                pta.PolicyTransactionKey = pt.PolicyTransactionKey and  
                pta.AddOnGroup in ('Luggage', 'Rental Car')  
        ) ll  
        outer apply  
        (  
            select  
                isnull(max([Charged Traveller 1 Gender]), '') [Charged Traveller 1 Gender],  
                max([Charged Traveller 1 DOB]) [Charged Traveller 1 DOB],  
                isnull(max([Charged Traveller 1 Has EMC]), 0) [Charged Traveller 1 Has EMC],  
                isnull(max([Charged Traveller 1 Has Manual EMC]), 0) [Charged Traveller 1 Has Manual EMC],  
                isnull(max([Charged Traveller 1 EMC Score]), 0) [Charged Traveller 1 EMC Score],  
                isnull(max([Charged Traveller 1 EMC Reference]), -1) [Charged Traveller 1 EMC Reference],  
                isnull(max([Charged Traveller 2 Gender]), '') [Charged Traveller 2 Gender],  
                max([Charged Traveller 2 DOB]) [Charged Traveller 2 DOB],  
                isnull(max([Charged Traveller 2 Has EMC]), 0) [Charged Traveller 2 Has EMC],  
                isnull(max([Charged Traveller 2 Has Manual EMC]), 0) [Charged Traveller 2 Has Manual EMC],  
                isnull(max([Charged Traveller 2 EMC Score]), 0) [Charged Traveller 2 EMC Score],  
                isnull(max([Charged Traveller 2 EMC Reference]), -1) [Charged Traveller 2 EMC Reference],  
                isnull(max([Charged Traveller 3 Gender]), '') [Charged Traveller 3 Gender],  
                max([Charged Traveller 3 DOB]) [Charged Traveller 3 DOB],  
                isnull(max([Charged Traveller 3 Has EMC]), 0) [Charged Traveller 3 Has EMC],  
                isnull(max([Charged Traveller 3 Has Manual EMC]), 0) [Charged Traveller 3 Has Manual EMC],  
                isnull(max([Charged Traveller 3 EMC Score]), 0) [Charged Traveller 3 EMC Score],  
                isnull(max([Charged Traveller 3 EMC Reference]), -1) [Charged Traveller 3 EMC Reference],  
                isnull(max([Charged Traveller 4 Gender]), '') [Charged Traveller 4 Gender],  
                max([Charged Traveller 4 DOB]) [Charged Traveller 4 DOB],  
                isnull(max([Charged Traveller 4 Has EMC]), 0) [Charged Traveller 4 Has EMC],  
                isnull(max([Charged Traveller 4 Has Manual EMC]), 0) [Charged Traveller 4 Has Manual EMC],  
                isnull(max([Charged Traveller 4 EMC Score]), 0) [Charged Traveller 4 EMC Score],  
                isnull(max([Charged Traveller 4 EMC Reference]), -1) [Charged Traveller 4 EMC Reference],  
                isnull(max([Charged Traveller 5 Gender]), '') [Charged Traveller 5 Gender],  
                max([Charged Traveller 5 DOB]) [Charged Traveller 5 DOB],  
                isnull(max([Charged Traveller 5 Has EMC]), 0) [Charged Traveller 5 Has EMC],  
                isnull(max([Charged Traveller 5 Has Manual EMC]), 0) [Charged Traveller 5 Has Manual EMC],  
                isnull(max([Charged Traveller 5 EMC Score]), 0) [Charged Traveller 5 EMC Score],  
                isnull(max([Charged Traveller 5 EMC Reference]), -1) [Charged Traveller 5 EMC Reference],  
                isnull(max([Charged Traveller 6 Gender]), '') [Charged Traveller 6 Gender],  
                max([Charged Traveller 6 DOB]) [Charged Traveller 6 DOB],  
                isnull(max([Charged Traveller 6 Has EMC]), 0) [Charged Traveller 6 Has EMC],  
                isnull(max([Charged Traveller 6 Has Manual EMC]), 0) [Charged Traveller 6 Has Manual EMC],  
                isnull(max([Charged Traveller 6 EMC Score]), 0) [Charged Traveller 6 EMC Score],  
                isnull(max([Charged Traveller 6 EMC Reference]), -1) [Charged Traveller 6 EMC Reference],  
                isnull(max([Charged Traveller 7 Gender]), '') [Charged Traveller 7 Gender],  
                max([Charged Traveller 7 DOB]) [Charged Traveller 7 DOB],  
                isnull(max([Charged Traveller 7 Has EMC]), 0) [Charged Traveller 7 Has EMC],  
                isnull(max([Charged Traveller 7 Has Manual EMC]), 0) [Charged Traveller 7 Has Manual EMC],  
                isnull(max([Charged Traveller 7 EMC Score]), 0) [Charged Traveller 7 EMC Score],  
                isnull(max([Charged Traveller 7 EMC Reference]), -1) [Charged Traveller 7 EMC Reference],  
                isnull(max([Charged Traveller 8 Gender]), '') [Charged Traveller 8 Gender],  
                max([Charged Traveller 8 DOB]) [Charged Traveller 8 DOB],  
                isnull(max([Charged Traveller 8 Has EMC]), 0) [Charged Traveller 8 Has EMC],  
                isnull(max([Charged Traveller 8 Has Manual EMC]), 0) [Charged Traveller 8 Has Manual EMC],  
                isnull(max([Charged Traveller 8 EMC Score]), 0) [Charged Traveller 8 EMC Score],  
                isnull(max([Charged Traveller 8 EMC Reference]), -1) [Charged Traveller 8 EMC Reference],  
                isnull(max([Charged Traveller 9 Gender]), '') [Charged Traveller 9 Gender],  
                max([Charged Traveller 9 DOB]) [Charged Traveller 9 DOB],  
                isnull(max([Charged Traveller 9 Has EMC]), 0) [Charged Traveller 9 Has EMC],  
                isnull(max([Charged Traveller 9 Has Manual EMC]), 0) [Charged Traveller 9 Has Manual EMC],  
                isnull(max([Charged Traveller 9 EMC Score]), 0) [Charged Traveller 9 EMC Score],  
                isnull(max([Charged Traveller 9 EMC Reference]), -1) [Charged Traveller 9 EMC Reference],  
                isnull(max([Charged Traveller 10 Gender]), '') [Charged Traveller 10 Gender],  
                max([Charged Traveller 10 DOB]) [Charged Traveller 10 DOB],  
                isnull(max([Charged Traveller 10 Has EMC]), 0) [Charged Traveller 10 Has EMC],  
                isnull(max([Charged Traveller 10 Has Manual EMC]), 0) [Charged Traveller 10 Has Manual EMC],  
                isnull(max([Charged Traveller 10 EMC Score]), 0) [Charged Traveller 10 EMC Score],  
                isnull(max([Charged Traveller 10 EMC Reference]), -1) [Charged Traveller 10 EMC Reference]  
            from  
                (  
                    select top 10   
                 case when row_number() over (order by PolicyTravellerID) = 1 then g.Gender end [Charged Traveller 1 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then DOB end [Charged Traveller 1 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then hef.HasEMCFlag end [Charged Traveller 1 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then hmef.HasManualEMCFlag end [Charged Traveller 1 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then e.EMCScore end [Charged Traveller 1 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then e.ApplicationID end [Charged Traveller 1 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then g.Gender end [Charged Traveller 2 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then DOB end [Charged Traveller 2 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then hef.HasEMCFlag end [Charged Traveller 2 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then hmef.HasManualEMCFlag end [Charged Traveller 2 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then e.EMCScore end [Charged Traveller 2 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then e.ApplicationID end [Charged Traveller 2 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then g.Gender end [Charged Traveller 3 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then DOB end [Charged Traveller 3 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then hef.HasEMCFlag end [Charged Traveller 3 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then hmef.HasManualEMCFlag end [Charged Traveller 3 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then e.EMCScore end [Charged Traveller 3 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then e.ApplicationID end [Charged Traveller 3 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then g.Gender end [Charged Traveller 4 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then DOB end [Charged Traveller 4 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then hef.HasEMCFlag end [Charged Traveller 4 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then hmef.HasManualEMCFlag end [Charged Traveller 4 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then e.EMCScore end [Charged Traveller 4 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then e.ApplicationID end [Charged Traveller 4 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then g.Gender end [Charged Traveller 5 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then DOB end [Charged Traveller 5 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then hef.HasEMCFlag end [Charged Traveller 5 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then hmef.HasManualEMCFlag end [Charged Traveller 5 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then e.EMCScore end [Charged Traveller 5 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then e.ApplicationID end [Charged Traveller 5 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then g.Gender end [Charged Traveller 6 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then DOB end [Charged Traveller 6 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then hef.HasEMCFlag end [Charged Traveller 6 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then hmef.HasManualEMCFlag end [Charged Traveller 6 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then e.EMCScore end [Charged Traveller 6 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then e.ApplicationID end [Charged Traveller 6 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then g.Gender end [Charged Traveller 7 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then DOB end [Charged Traveller 7 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then hef.HasEMCFlag end [Charged Traveller 7 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then hmef.HasManualEMCFlag end [Charged Traveller 7 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then e.EMCScore end [Charged Traveller 7 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then e.ApplicationID end [Charged Traveller 7 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then g.Gender end [Charged Traveller 8 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then DOB end [Charged Traveller 8 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then hef.HasEMCFlag end [Charged Traveller 8 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then hmef.HasManualEMCFlag end [Charged Traveller 8 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then e.EMCScore end [Charged Traveller 8 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then e.ApplicationID end [Charged Traveller 8 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then g.Gender end [Charged Traveller 9 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then DOB end [Charged Traveller 9 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then hef.HasEMCFlag end [Charged Traveller 9 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then hmef.HasManualEMCFlag end [Charged Traveller 9 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then e.EMCScore end [Charged Traveller 9 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then e.ApplicationID end [Charged Traveller 9 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then g.Gender end [Charged Traveller 10 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then DOB end [Charged Traveller 10 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then hef.HasEMCFlag end [Charged Traveller 10 Has EMC],  
           case when row_number() over (order by PolicyTravellerID) = 10 then hmef.HasManualEMCFlag end [Charged Traveller 10 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then e.EMCScore end [Charged Traveller 10 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then e.ApplicationID end [Charged Traveller 10 EMC Reference]  
                    from  
                        [db-au-cba]..penPolicyTraveller ptv with(nolock)  
                        cross apply  
                        (  
                            select  
                                case  
                                    when ptv.Gender is not null then ptv.Gender  
                                    when rtrim(ltrim(lower(ptv.Title))) in ('mr', 'mstr') then 'M'  
                                    when rtrim(ltrim(lower(ptv.Title))) in ('mrs', 'ms', 'miss') then 'F'  
                                    else 'U'  
                                end Gender  
                        ) g  
                        outer apply  
                        (  
                            select top 1  
                                e.ApplicationID,  
                                e.ApplicationType,  
                                e.MedicalRisk EMCScore,  
                                pp.GrossPremiumAfterDiscount PremiumIncrease,  
                                ac.AddOnCode  
                            from  
                                [db-au-cba]..penPolicyTravellerTransaction ptt with(nolock)  
                                inner join [db-au-cba]..penPolicyEMC pe with(nolock) on  
                                    pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey  
                                inner join [db-au-cba]..vpenPolicyPrice pp with(nolock) on  
                                    pp.CountryKey = ptt.CountryKey and  
                                    pp.CompanyKey = ptt.CompanyKey and  
                                    pp.ComponentID = pe.PolicyEMCID and  
                                    pp.GroupID = 5  
                                left join [db-au-cba]..emcApplications e with(nolock) on  
                                    e.ApplicationKey = pe.EMCApplicationKey  
                                outer apply  
                                (  
                                    select top 1  
                                        a.AddOnCode  
                                    from  
                                        [db-au-cba]..penAddOn a with(nolock)  
                                    where  
                                        a.CountryKey = pe.CountryKey and  
                                        a.CompanyKey = pe.CompanyKey and  
                                        a.AddOnID = pe.AddOnID  
                                ) ac  
                            where  
                                ptt.PolicyTravellerKey = ptv.PolicyTravellerKey  
                        ) e  
                        outer apply  
                        (  
                            select  
                                case  
                                    when e.AddOnCode = 'EMCT3' then 3  
                                    when e.AddOnCode = 'EMCT4' then 4  
                                    when isnull(e.PremiumIncrease, 0) <> 0 then 1  
                                    else 0  
                                end HasEMCFlag  
                        ) hef  
                        outer apply  
                        (  
                            select  
                                case  
                                    when hef.HasEMCFlag = 0 then 0  
                                    when ApplicationType is null then 0  
                                    when ApplicationType = 'Healix' then 0  
                                    else 1  
                                end HasManualEMCFlag  
                       ) hmef  
       where  
            ptv.PolicyKey = p.PolicyKey and  
                        --Zem's email on 20170828, AP issue  
                        --ptv.AdultCharge > 0  
                        ptv.AdultCharge = 1  
                    order by  
                        PolicyTravellerID  
                ) otv  
        ) pptvl  
        outer apply  
        (  
            select   
                sum(GrossPremiumAfterDiscount) [Base Base Premium]  
            from  
                [db-au-cba]..vpenPolicyPriceComponentOptimise ppc with(nolock)   
            where  
                ppc.PolicyTransactionKey = pt.PolicyTransactionKey and  
                ppc.PriceCategory = 'Base Rate'  
        ) bbp  
        outer apply  
        (  
            select top 1   
                pac.CallComment  
            from  
                [db-au-cba]..penPolicyAdminCallComment pac with(nolock)  
            where  
                pac.PolicyKey = p.PolicyKey  
        ) pac  
    where  
        isnull(p.isTripsPolicy, 0) = 0 and  
        pt.PostingDate >= @StartDate and  
        pt.PostingDate <  dateadd(day,1 , @EndDate)  
          
          
        /* delete these policies later on */  
        and  
        pt.PolicyTransactionKey not in  
        (  
            'AU-TIP7-809723',  
            'AU-TIP7-809745',  
            'AU-TIP7-812471',  
            'AU-TIP7-813572',  
            'AU-TIP7-813596',  
            'AU-TIP7-813917',  
            'AU-TIP7-814032',  
            'AU-TIP7-814120',  
            'NZ-CM8-1886119'  
        )  
          
    union all  
      
    /* trips policies */  
    select   
        pl.AncestorCountryKey [Domain Country],  
        pl.AncestorCompanyKey [Company],  
  
        pl.AncestorPolicyKey [PolicyKey],  
        p.PolicyKey [PolicyTransactionKey],  
        case  
            when p.PolicyKey = pl.AncestorPolicyKey then 1  
            else 0  
        end [isParent],  
        convert(varchar(50), pl.AncestorPolicyNo) [Base Policy No],  
        convert(varchar(50), p.PolicyNo) [Policy No],  
        p.IssuedDate [Issue Date],  
        p.IssuedDate [Transaction Issue Date],  
        p.CreateDate [Posting Date],  
  
        case  
            when p.PolicyType = 'N' then 'Base'  
            when p.PolicyType = 'E' then 'Extend'  
            when p.PolicyType = 'A' then 'Variation'  
            when p.PolicyType = 'R' and p.OldPolicyType = 'N' then 'Base'  
            when p.PolicyType = 'R' and p.OldPolicyType = 'E' then 'Extend'  
            when p.PolicyType = 'R' and p.OldPolicyType = 'A' then 'Variation'  
            when p.PolicyType = 'R' then 'Refund'  
            else p.PolicyType  
        end [Transaction Type],  
  
        case  
            when exists  
            (  
                select  
                    null  
                from  
                    [db-au-cba]..Policy r  
                where  
                    r.PolicyType = 'R' and  
                    r.OldPolicyNo = p.PolicyNo and  
                    r.CountryKey = p.CountryKey  
            ) then 'Cancelled'  
            else 'Active'  
        end [Policy Status],  
        case  
            when p.PolicyType = 'N' then 'Active'  
            when p.PolicyType = 'E' then 'Active'  
            when p.PolicyType = 'A' then 'Active'  
            when p.PolicyType = 'R' then 'Cancelled'  
            else p.PolicyType  
        end [Transaction Status],  
  
        isnull(tp.DepartureDate, p.DepartureDate) [Departure Date],  
        isnull(tp.ReturnDate, p.ReturnDate) [Return Date],  
        datediff(day, p.IssuedDate, p.DepartureDate) [Lead Time],  
        case  
            when   
                p.IssuedDate <= '2009-01-01' and  
                p.ProductCode = 'CMB' and   
                (  
                    --CMB AMT  
                    pp.[Plan Code] in ('G', 'A', 'PGR1', 'PGR2') or  
                    pp.[Plan Code] like 'PGA%'  
                ) and  
                p.NumberOfDays >= 350   
  then 90  
            when p.NumberOfDays in (15, 30, 45, 60, 90) then p.NumberOfDays  
            else 0  
        end [Maximum Trip Length],  
        p.NumberOfDays [Trip Duration],  
        datediff(d, p.DepartureDate, p.ReturnDate) + 1 [Trip Length],  
          
        '' [Area Name],  
        pp.[Area Number],  
        isnull(tp.Destination, p.Destination) [Destination],  
        p.[Excess],  
        case   
            when tp.GroupPolicy = 1 then 1  
            when [Unique Charged Traveller Count] > 10 then 1  
            else 0  
        end [Group Policy],  
        case   
            when isnull([Rental Car Premium], 0) <> 0 then 1  
            else 0  
        end [Has Rental Car],  
        case   
            when isnull([Motorcycle Premium], 0) <> 0 then 1  
            else 0  
        end [Has Motorcycle],  
        case   
            when isnull([Winter Sport Premium], 0) <> 0 then 1  
            else 0  
        end [Has Wintersport],  
        case   
            when isnull([Medical Premium], 0) <> 0 then 1  
            else 0  
        end [Has Medical],  
        case   
            when isnull([Cruise Premium], 0) <> 0 then 1  
            else 0  
        end [Has Cruise],  
  
        pp.[Single/Family],  
        '' [Purchase Path],  
        1 [TRIPS Policy],  
  
        p.ProductCode [Product Code],  
        pp.[Plan Code],  
  pp.[Plan Name],  
  
        dp.[Product Name],  
        dp.[Product Plan],  
        dp.[Product Type],   
        dp.[Product Group],  
        dp.[Policy Type],  
        dp.[Plan Type],  
        dp.[Trip Type],  
        dp.[Product Classification],  
        dp.[Finance Product Code],  
  
        o.[OutletKey],  
        upper(o.AlphaCode) [Alpha Code],  
        upper(p.AgencyCode) [Original Alpha Code],  
        upper(p.AgencyCode) [Transaction Alpha Code],  
        o.[OutletKey] [Transaction OutletKey],  
          
        [Customer Post Code],  
        [Unique Traveller Count],  
        [Unique Charged Traveller Count],  
        [Traveller Count],  
        [Charged Traveller Count],  
        [Adult Traveller Count],  
        tetc.[EMC Traveller Count],  
        [Youngest Charged DOB],  
        [Oldest Charged DOB],  
  
        --follow SAS calculation  
        --datediff(year, [Youngest DOB], p.IssuedDate) [Youngest Age],  
        --datediff(year, [Oldest DOB], p.IssuedDate) [Oldest Age],  
  
        --SAS calculation  
        --floor((intck('month', Oldest_Ch_DoB, d_PPDiss) - (day(d_PPDiss) < day(Oldest_Ch_DoB))) / 12)  
        case  
            when p.IssuedDate is null or [Youngest DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Youngest DOB], p.IssuedDate) -  
                        case  
                            when datepart(day, p.IssuedDate) < datepart(day, [Youngest DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Youngest Age],  
        case  
            when p.IssuedDate is null or [Oldest DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Oldest DOB], p.IssuedDate) -  
                        case  
                            when datepart(day, p.IssuedDate) < datepart(day, [Oldest DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Oldest Age],  
        case  
            when p.IssuedDate is null or [Youngest Charged DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Youngest Charged DOB], p.IssuedDate) -  
                        case  
                            when datepart(day, p.IssuedDate) < datepart(day, [Youngest Charged DOB]) then 1  
                            else 0  
                        end  
                    ) /  
        12  
                )  
        end [Youngest Charged Age],  
        case  
  when p.IssuedDate is null or [Oldest Charged DOB] is null then -1  
            else  
                floor(  
                    (  
                        datediff(month, [Oldest Charged DOB], p.IssuedDate) -  
                        case  
                            when datepart(day, p.IssuedDate) < datepart(day, [Oldest Charged DOB]) then 1  
                            else 0  
                        end  
                    ) /  
                    12  
                )  
        end [Oldest Charged Age],  
  
        isnull(es.[Max EMC Score], 0) [Max EMC Score],  
        isnull(es.[Total EMC Score], 0) [Total EMC Score],  
  
        null [EMC Tier Oldest Charged],  
        null [EMC Tier Youngest Charged],  
  
        tptvl.[Charged Traveller 1 Gender],  
        tptvl.[Charged Traveller 1 DOB],  
        tptvl.[Charged Traveller 1 Has EMC],  
        tptvl.[Charged Traveller 1 Has Manual EMC],  
        tptvl.[Charged Traveller 1 EMC Score],  
        tptvl.[Charged Traveller 1 EMC Reference],  
        tptvl.[Charged Traveller 2 Gender],  
        tptvl.[Charged Traveller 2 DOB],  
        tptvl.[Charged Traveller 2 Has EMC],  
        tptvl.[Charged Traveller 2 Has Manual EMC],  
        tptvl.[Charged Traveller 2 EMC Score],  
        tptvl.[Charged Traveller 2 EMC Reference],  
        tptvl.[Charged Traveller 3 Gender],  
        tptvl.[Charged Traveller 3 DOB],  
        tptvl.[Charged Traveller 3 Has EMC],  
        tptvl.[Charged Traveller 3 Has Manual EMC],  
        tptvl.[Charged Traveller 3 EMC Score],  
        tptvl.[Charged Traveller 3 EMC Reference],  
        tptvl.[Charged Traveller 4 Gender],  
        tptvl.[Charged Traveller 4 DOB],  
        tptvl.[Charged Traveller 4 Has EMC],  
        tptvl.[Charged Traveller 4 Has Manual EMC],  
        tptvl.[Charged Traveller 4 EMC Score],  
        tptvl.[Charged Traveller 4 EMC Reference],  
        tptvl.[Charged Traveller 5 Gender],  
        tptvl.[Charged Traveller 5 DOB],  
        tptvl.[Charged Traveller 5 Has EMC],  
        tptvl.[Charged Traveller 5 Has Manual EMC],  
        tptvl.[Charged Traveller 5 EMC Score],  
        tptvl.[Charged Traveller 5 EMC Reference],  
        tptvl.[Charged Traveller 6 Gender],  
        tptvl.[Charged Traveller 6 DOB],  
        tptvl.[Charged Traveller 6 Has EMC],  
        tptvl.[Charged Traveller 6 Has Manual EMC],  
        tptvl.[Charged Traveller 6 EMC Score],  
        tptvl.[Charged Traveller 6 EMC Reference],  
        tptvl.[Charged Traveller 7 Gender],  
        tptvl.[Charged Traveller 7 DOB],  
        tptvl.[Charged Traveller 7 Has EMC],  
        tptvl.[Charged Traveller 7 Has Manual EMC],  
        tptvl.[Charged Traveller 7 EMC Score],  
        tptvl.[Charged Traveller 7 EMC Reference],  
        tptvl.[Charged Traveller 8 Gender],  
        tptvl.[Charged Traveller 8 DOB],  
        tptvl.[Charged Traveller 8 Has EMC],  
        tptvl.[Charged Traveller 8 Has Manual EMC],  
        tptvl.[Charged Traveller 8 EMC Score],  
        tptvl.[Charged Traveller 8 EMC Reference],  
        tptvl.[Charged Traveller 9 Gender],  
        tptvl.[Charged Traveller 9 DOB],  
        tptvl.[Charged Traveller 9 Has EMC],  
        tptvl.[Charged Traveller 9 Has Manual EMC],  
        tptvl.[Charged Traveller 9 EMC Score],  
        tptvl.[Charged Traveller 9 EMC Reference],  
        tptvl.[Charged Traveller 10 Gender],  
        tptvl.[Charged Traveller 10 DOB],  
        tptvl.[Charged Traveller 10 Has EMC],  
        tptvl.[Charged Traveller 10 Has Manual EMC],  
        tptvl.[Charged Traveller 10 EMC Score],  
        tptvl.[Charged Traveller 10 EMC Reference],  
  
        p.CommissionTierID [Commission Tier],  
        p.VolumePercentage [Volume Commission],  
        0 [Discount],  
  
        p.BasePremium [Base Base Premium],  
        p.BasePremium [Base Premium],  
        pap.[Canx Premium],  
        pap.[Undiscounted Canx Premium],  
        pap.[Rental Car Premium],  
  pap.[Motorcycle Premium],  
        pap.[Luggage Premium],  
        pap.[Medical Premium],  
   pap.[Winter Sport Premium],  
        pap.[Cruise Premium],  
  
        ll.[Luggage Increase],  
        ll.[Rental Car Increase],  
        [db-au-cba].dbo.fn_StrToInt(replace(isnull(convert(varchar(20), p.CancellationCoverValue),''),'.00','')) [Trip Cost],  
  
        isnull(p.GrossPremiumExGSTBeforeDiscount, 0) + isnull(p.GSTonGrossPremium, 0) [Unadjusted Sell Price],  
        isnull(p.GSTonGrossPremium, 0) [Unadjusted GST on Sell Price],  
        isnull(p.StampDuty, 0) [Unadjusted Stamp Duty on Sell Price],  
        isnull(p.CommissionAmount, 0) + isnull(p.ActualAdminFee, 0) + isnull(p.GSTOnCommission, 0) [Unadjusted Agency Commission],  
        isnull(p.GSTOnCommission, 0) [Unadjusted GST on Agency Commission],  
        0 [Unadjusted Stamp Duty on Agency Commission],  
        isnull(p.ActualAdminFee, 0) [Unadjusted Admin Fee],  
        isnull(p.ActualGrossPremiumAfterDiscount, isnull(p.GrossPremiumExGSTBeforeDiscount, 0)) + isnull(p.GSTonGrossPremium, 0) [Sell Price],  
        isnull(p.GSTonGrossPremium, 0) [GST on Sell Price],  
        isnull(p.StampDuty, 0) [Stamp Duty on Sell Price],  
        isnull(p.ActualGrossPremiumAfterDiscount, isnull(p.GrossPremiumExGSTBeforeDiscount, 0)) - isnull(p.StampDuty, 0) [Premium],  
        isnull(p.RiskNet, 0) [Risk Nett],  
        isnull(pt.GUG, 0) GUG,  
        isnull(p.ActualCommissionAfterDiscount, isnull(p.CommissionAmount, 0)) + isnull(p.ActualAdminFeeAfterDiscount, isnull(p.ActualAdminFee, 0)) + isnull(p.GSTOnCommission, 0) [Agency Commission],  
        isnull(p.GSTOnCommission, 0) [GST on Agency Commission],  
        0 [Stamp Duty on Agency Commission],  
        isnull(p.ActualAdminFeeAfterDiscount, isnull(p.ActualAdminFee, 0)) [Admin Fee],  
        isnull(p.ActualGrossPremiumAfterDiscount, isnull(p.GrossPremiumExGSTBeforeDiscount, 0)) - isnull(p.StampDuty, 0) - isnull(p.ActualCommissionAfterDiscount, isnull(p.CommissionAmount, 0)) - isnull(p.ActualAdminFeeAfterDiscount,   
  isnull(p.ActualAdminFee, 0)) - isnull(p.GSTOnCommission, 0) [NAP],  
        isnull(p.ActualGrossPremiumAfterDiscount, isnull(p.GrossPremiumExGSTBeforeDiscount, 0)) + isnull(p.GSTonGrossPremium, 0) - isnull(p.ActualCommissionAfterDiscount, isnull(p.CommissionAmount, 0)) - isnull(p.ActualAdminFeeAfterDiscount,   
  isnull(p.ActualAdminFee, 0)) - isnull(p.GSTOnCommission, 0) [NAP (incl Tax)],  
  
        case  
            when p.PolicyType = 'N' then 1  
            when p.PolicyType = 'R' and p.OldPolicyType = 'N' then -1  
            else 0  
        end [Policy Count],  
        null [Price Beat Policy],  
        null [Competitor Name],  
        null [Competitor Price],  
  
        tp.PolicyID,  
        case  
            when o.OutletName like '%test %' then 'Test policy'  
            when o.OutletName like '% test%' then 'Test policy'  
            when o.OutletName = 'test' then 'Test policy'  
            when p.PolicyComment like '%partial%' then 'Partial cancellation'  
            when p.PolicyComment like '%override%' then 'Partial cancellation'  
            when p.PolicyComment like '%overide%' then 'Partial cancellation'  
            when p.PolicyComment like '%DP%' then 'Dummy policy'  
            when p.PolicyComment like '%D/P%' then 'Dummy policy'  
            when p.PolicyComment like '%top up%' then 'Dummy policy'  
            when p.PolicyComment like '%write off%' then 'Dummy policy'  
            when p.PolicyComment like '%offset%' then 'Dummy policy'  
            when p.PolicyComment like '%dummy%' then 'Dummy policy'  
            when p.PolicyComment like '%staff%' then 'Dummy policy'  
            when p.PolicyNo like '94%' and p.PolicyType = 'N' then 'Manual cancellation'  
            else ''  
        end Category  
    from  
        [db-au-cba]..Policy p (nolock)  
        cross apply  
        (  
            select top 1   
                AncestorPolicyNo,  
                AncestorPolicyKey,  
   r.CountryKey AncestorCountryKey,  
                r.CompanyKey AncestorCompanyKey,  
                r.AgencyCode AncestorAgencyCode  
            from  
                [db-au-actuary].ws.PolicyLineage pl  
                inner join [db-au-cba]..Policy r with(nolock) on  
                    r.PolicyKey = pl.AncestorPolicyKey  
            where  
                pl.PolicyKey = p.PolicyKey  
        ) pl  
        cross apply  
        (  
            select top 1   
                o.[OutletKey],  
                o.AlphaCode,  
                o.OutletName  
            from  
                [db-au-cba]..penOutlet o with(nolock)  
            where  
                o.OutletStatus = 'Current' and  
                o.CountryKey = pl.AncestorCountryKey and  
                o.CompanyKey = pl.AncestorCompanyKey and  
                o.AlphaCode = pl.AncestorAgencyCode  
        ) o  
        outer apply  
        (  
            select  
                p.ActualCancellationPremiumAfterDiscount [Canx Premium],  
                p.RentalCarPremium [Rental Car Premium],  
                p.MotorcyclePremium [Motorcycle Premium],  
                p.LuggagePremium [Luggage Premium],  
                p.MedicalPremium [Medical Premium],  
                p.CancellationPremium [Undiscounted Canx Premium],  
                p.WinterSportPremium [Winter Sport Premium],  
                0 [Cruise Premium]  
        ) pap  
        outer apply  
        (  
            select   
                p.PlanCode [Plan Code],  
    '' [Plan Name],        --TRIPS do not have plan name  
                p.SingleFamily [Single/Family],  
                case  
                    when p.ProductCode = 'CMB' and p.PlanCode = 'A' then 'Area 1'  
                    when   
                        p.CountryKey = 'AU' and  
                        p.NumberOfDays >= 15 and  
                        upper(p.Destination) in   
                        (  
                            'ENGLAND',   
                            'ENGLAND (UNITED',   
                            'UNITED KINGDOM',   
                            'WALES',   
                            'WALES (UNITED K',   
                            'SCOTLAND',   
                            'SCOTLAND (UK)',   
                            'NORTHERN IRELAN',   
                            'REPUBLIC OF IRE',   
                            'IRELAND'  
                        ) then 'Area 3'  
                    else dbo.fSASMapping('PlanArea', p.PlanCode)  
                end [Area Number]  
        ) pp  
        outer apply  
        (  
            select top 1   
                dp.ProductName [Product Name],  
                dp.ProductPlan [Product Plan],  
                dp.ProductType [Product Type],   
                dp.ProductGroup [Product Group],  
                dp.PolicyType [Policy Type],  
                dp.PlanType [Plan Type],  
                dp.TripType [Trip Type],  
                dp.ProductClassification [Product Classification],  
                dp.FinanceProductCode [Finance Product Code]  
            from  
                [db-au-star]..dimProduct dp  
            where  
            --trips policies  
                ProductCode = p.ProductCode and  
                (  
                    ProductPlan = p.PlanCode or  
                    ProductPlan like '% ' + p.PlanCode or  
                    ProductPlan like '%TRIPS' + p.PlanCode or  
                    (  
                        p.PlanCode = 'DA' and  
                        dp.ProductPlan like '% ' + p.PlanCode + '%'  
                    ) or  
                    (  
                        p.PlanCode like 'X%' and  
                        p.PlanCode <> 'X' and  
                        ProductPlan like '%' + replace(p.PlanCode, 'X', '')  
                    )  
                )  
        ) dp  
        outer apply  
        (  
            select top 1  
                pt.PolicyTransactionKey,  
                [Pricing Exposure Measure] GUG  
            from  
                [db-au-cba]..penPolicyTransSummary pt with(nolock)  
                inner join [db-au-cba]..vPenguinPolicyUWPremiums gug with(nolock) on  
                    gug.PolicyTransactionKey = pt.PolicyTransactionKey  
            where  
                pt.PolicyNumber = convert(varchar(50), p.PolicyNo) and  
                pt.CountryKey = p.CountryKey and  
                pt.CompanyKey = p.CompanyKey  
        ) pt  
        outer apply  
        (  
          
            select   
                count(distinct ltrim(rtrim(isnull(cbp.FirstName, ''))) + ltrim(rtrim(isnull(cbp.LastName, ''))) + isnull(convert(varchar(10), cbp.DateOfBirth, 120), '')) [Unique Traveller Count],  
                count(cbp.CustomerID) [Traveller Count],  
                sum(  
                    case  
                        when cbp.PersonIsAdult = 1 then 1  
                        else 0  
                    end  
                ) [Charged Traveller Count],  
                count(  
                    distinct   
                    case  
                        when cbp.PersonIsAdult = 1 then ltrim(rtrim(isnull(cbp.FirstName, ''))) + ltrim(rtrim(isnull(cbp.LastName, ''))) + isnull(convert(varchar(10), cbp.DateOfBirth, 120), '')  
                        else null  
                    end  
                ) [Unique Charged Traveller Count],  
                sum(  
                    case  
                        when cbp.PersonIsAdult = 1 then 1  
                        else 0  
                    end  
                ) [Adult Traveller Count],  
                min(  
                    case  
                        when cbp.DateOfBirth = '1900-01-01' then null  
                        else cbp.DateOfBirth  
                    end  
                ) [Oldest DOB],  
                max(  
                    case  
                        when cbp.DateOfBirth = '1900-01-01' then null  
                        else cbp.DateOfBirth  
                    end  
                ) [Youngest DOB],  
                min(  
                    case   
                        when cbp.DateOfBirth = '1900-01-01' then null  
                        when cbp.PersonIsAdult = 1 then cbp.DateOfBirth  
                        else null  
                    end  
                ) [Oldest Charged DOB],  
                max(  
                    case   
                        when cbp.DateOfBirth = '1900-01-01' then null  
                        when cbp.PersonIsAdult = 1 then cbp.DateOfBirth  
                        else null  
                    end  
                ) [Youngest Charged DOB]  
            from  
                [db-au-actuary].ws.CustomerOnBasePolicy cbp  
            where  
                cbp.PolicyKey = pl.AncestorPolicyKey  
        ) ptv  
        outer apply  
        (  
            select   
                count(  
                    distinct   
                    case  
                        when isnull(cbp.EMCPremiumAmount, 0) <> 0 then ltrim(rtrim(isnull(cbp.FirstName, ''))) + ltrim(rtrim(isnull(cbp.LastName, ''))) + isnull(convert(varchar(10), cbp.DateOfBirth, 120), '')  
                        else null  
                    end  
                ) [EMC Traveller Count]  
            from  
                [db-au-actuary].ws.CustomerOnBasePolicy cbp  
            where  
                cbp.PolicyKey = pl.AncestorPolicyKey  
        ) tetc  
        outer apply  
        (  
            select   
                sum(  
                    case  
                        when pta.AddOnGroup = 'Luggage' then CoverIncrease  
                        else 0  
                    end  
                ) *   
                case  
                    when p.PolicyType = 'R' then -1  
                    else 1  
                end [Luggage Increase],  
                sum(  
                    case  
                        when pta.AddOnGroup = 'Rental Car' then CoverIncrease  
                        else 0  
                    end  
                ) *   
                case  
                    when p.PolicyType = 'R' then -1  
                    else 1  
                end [Rental Car Increase]  
 from  
                [db-au-cba]..penPolicyTransAddOn pta with(nolock)   
            where  
                pta.PolicyTransactionKey = pt.PolicyTransactionKey and  
                pta.AddOnGroup in ('Luggage', 'Rental Car')  
        ) ll  
        outer apply  
        (  
            select top 1  
                tpp.PolicyID,  
                tpp.DepartureDate,  
                tpp.ReturnDate,  
                tpp.GroupPolicy,  
                tpp.PostCode [Customer Post Code],  
                tpp.Destination  
            from  
                [db-au-actuary].ws.PolicySourceID tpp  
            where  
                tpp.Country = p.CountryKey and  
                tpp.PolicyNo = p.PolicyNo and  
                tpp.OldPolicyNo = p.OldPolicyNo and  
                isnull(tpp.AgencyCode, '') collate database_default = isnull(p.AgencyCode, '') collate database_default  
        ) tp  
        cross apply  
        (  
            select  
                isnull(max([Charged Traveller 1 Gender]), '') [Charged Traveller 1 Gender],  
                max([Charged Traveller 1 DOB]) [Charged Traveller 1 DOB],  
                isnull(max([Charged Traveller 1 Has EMC]), 0) [Charged Traveller 1 Has EMC],  
                isnull(max([Charged Traveller 1 Has Manual EMC]), 0) [Charged Traveller 1 Has Manual EMC],  
                isnull(max([Charged Traveller 1 EMC Score]), 0) [Charged Traveller 1 EMC Score],  
                isnull(max([Charged Traveller 1 EMC Reference]), -1) [Charged Traveller 1 EMC Reference],  
                isnull(max([Charged Traveller 2 Gender]), '') [Charged Traveller 2 Gender],  
                max([Charged Traveller 2 DOB]) [Charged Traveller 2 DOB],  
                isnull(max([Charged Traveller 2 Has EMC]), 0) [Charged Traveller 2 Has EMC],  
                isnull(max([Charged Traveller 2 Has Manual EMC]), 0) [Charged Traveller 2 Has Manual EMC],  
                isnull(max([Charged Traveller 2 EMC Score]), 0) [Charged Traveller 2 EMC Score],  
                isnull(max([Charged Traveller 2 EMC Reference]), -1) [Charged Traveller 2 EMC Reference],  
                isnull(max([Charged Traveller 3 Gender]), '') [Charged Traveller 3 Gender],  
                max([Charged Traveller 3 DOB]) [Charged Traveller 3 DOB],  
                isnull(max([Charged Traveller 3 Has EMC]), 0) [Charged Traveller 3 Has EMC],  
                isnull(max([Charged Traveller 3 Has Manual EMC]), 0) [Charged Traveller 3 Has Manual EMC],  
                isnull(max([Charged Traveller 3 EMC Score]), 0) [Charged Traveller 3 EMC Score],  
                isnull(max([Charged Traveller 3 EMC Reference]), -1) [Charged Traveller 3 EMC Reference],  
                isnull(max([Charged Traveller 4 Gender]), '') [Charged Traveller 4 Gender],  
                max([Charged Traveller 4 DOB]) [Charged Traveller 4 DOB],  
                isnull(max([Charged Traveller 4 Has EMC]), 0) [Charged Traveller 4 Has EMC],  
                isnull(max([Charged Traveller 4 Has Manual EMC]), 0) [Charged Traveller 4 Has Manual EMC],  
                isnull(max([Charged Traveller 4 EMC Score]), 0) [Charged Traveller 4 EMC Score],  
                isnull(max([Charged Traveller 4 EMC Reference]), -1) [Charged Traveller 4 EMC Reference],  
                isnull(max([Charged Traveller 5 Gender]), '') [Charged Traveller 5 Gender],  
                max([Charged Traveller 5 DOB]) [Charged Traveller 5 DOB],  
                isnull(max([Charged Traveller 5 Has EMC]), 0) [Charged Traveller 5 Has EMC],  
                isnull(max([Charged Traveller 5 Has Manual EMC]), 0) [Charged Traveller 5 Has Manual EMC],  
                isnull(max([Charged Traveller 5 EMC Score]), 0) [Charged Traveller 5 EMC Score],  
                isnull(max([Charged Traveller 5 EMC Reference]), -1) [Charged Traveller 5 EMC Reference],  
                isnull(max([Charged Traveller 6 Gender]), '') [Charged Traveller 6 Gender],  
                max([Charged Traveller 6 DOB]) [Charged Traveller 6 DOB],  
    isnull(max([Charged Traveller 6 Has EMC]), 0) [Charged Traveller 6 Has EMC],  
                isnull(max([Charged Traveller 6 Has Manual EMC]), 0) [Charged Traveller 6 Has Manual EMC],  
                isnull(max([Charged Traveller 6 EMC Score]), 0) [Charged Traveller 6 EMC Score],  
                isnull(max([Charged Traveller 6 EMC Reference]), -1) [Charged Traveller 6 EMC Reference],  
                isnull(max([Charged Traveller 7 Gender]), '') [Charged Traveller 7 Gender],  
                max([Charged Traveller 7 DOB]) [Charged Traveller 7 DOB],  
                isnull(max([Charged Traveller 7 Has EMC]), 0) [Charged Traveller 7 Has EMC],  
                isnull(max([Charged Traveller 7 Has Manual EMC]), 0) [Charged Traveller 7 Has Manual EMC],  
                isnull(max([Charged Traveller 7 EMC Score]), 0) [Charged Traveller 7 EMC Score],  
                isnull(max([Charged Traveller 7 EMC Reference]), -1) [Charged Traveller 7 EMC Reference],  
                isnull(max([Charged Traveller 8 Gender]), '') [Charged Traveller 8 Gender],  
                max([Charged Traveller 8 DOB]) [Charged Traveller 8 DOB],  
                isnull(max([Charged Traveller 8 Has EMC]), 0) [Charged Traveller 8 Has EMC],  
                isnull(max([Charged Traveller 8 Has Manual EMC]), 0) [Charged Traveller 8 Has Manual EMC],  
                isnull(max([Charged Traveller 8 EMC Score]), 0) [Charged Traveller 8 EMC Score],  
                isnull(max([Charged Traveller 8 EMC Reference]), -1) [Charged Traveller 8 EMC Reference],  
                isnull(max([Charged Traveller 9 Gender]), '') [Charged Traveller 9 Gender],  
                max([Charged Traveller 9 DOB]) [Charged Traveller 9 DOB],  
                isnull(max([Charged Traveller 9 Has EMC]), 0) [Charged Traveller 9 Has EMC],  
                isnull(max([Charged Traveller 9 Has Manual EMC]), 0) [Charged Traveller 9 Has Manual EMC],  
                isnull(max([Charged Traveller 9 EMC Score]), 0) [Charged Traveller 9 EMC Score],  
                isnull(max([Charged Traveller 9 EMC Reference]), -1) [Charged Traveller 9 EMC Reference],  
                isnull(max([Charged Traveller 10 Gender]), '') [Charged Traveller 10 Gender],  
                max([Charged Traveller 10 DOB]) [Charged Traveller 10 DOB],  
                isnull(max([Charged Traveller 10 Has EMC]), 0) [Charged Traveller 10 Has EMC],  
                isnull(max([Charged Traveller 10 Has Manual EMC]), 0) [Charged Traveller 10 Has Manual EMC],  
                isnull(max([Charged Traveller 10 EMC Score]), 0) [Charged Traveller 10 EMC Score],  
                isnull(max([Charged Traveller 10 EMC Reference]), -1) [Charged Traveller 10 EMC Reference]  
            from  
                (  
                    select top 10   
                        case when row_number() over (order by PolicyTravellerID) = 1 then Gender end [Charged Traveller 1 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then DOB end [Charged Traveller 1 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then hef.HasEMCFlag end [Charged Traveller 1 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then hmef.HasManualEMCFlag end [Charged Traveller 1 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then e.EMCScore end [Charged Traveller 1 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 1 then e.ApplicationID end [Charged Traveller 1 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then Gender end [Charged Traveller 2 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then DOB end [Charged Traveller 2 DOB],  
         case when row_number() over (order by PolicyTravellerID) = 2 then hef.HasEMCFlag end [Charged Traveller 2 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then hmef.HasManualEMCFlag end [Charged Traveller 2 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then e.EMCScore end [Charged Traveller 2 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 2 then e.ApplicationID end [Charged Traveller 2 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then Gender end [Charged Traveller 3 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then DOB end [Charged Traveller 3 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then hef.HasEMCFlag end [Charged Traveller 3 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then hmef.HasManualEMCFlag end [Charged Traveller 3 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then e.EMCScore end [Charged Traveller 3 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 3 then e.ApplicationID end [Charged Traveller 3 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then Gender end [Charged Traveller 4 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then DOB end [Charged Traveller 4 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then hef.HasEMCFlag end [Charged Traveller 4 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then hmef.HasManualEMCFlag end [Charged Traveller 4 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then e.EMCScore end [Charged Traveller 4 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 4 then e.ApplicationID end [Charged Traveller 4 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then Gender end [Charged Traveller 5 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then DOB end [Charged Traveller 5 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then hef.HasEMCFlag end [Charged Traveller 5 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then hmef.HasManualEMCFlag end [Charged Traveller 5 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then e.EMCScore end [Charged Traveller 5 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 5 then e.ApplicationID end [Charged Traveller 5 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then Gender end [Charged Traveller 6 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then DOB end [Charged Traveller 6 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then hef.HasEMCFlag end [Charged Traveller 6 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then hmef.HasManualEMCFlag end [Charged Traveller 6 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then e.EMCScore end [Charged Traveller 6 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 6 then e.ApplicationID end [Charged Traveller 6 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then Gender end [Charged Traveller 7 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then DOB end [Charged Traveller 7 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then hef.HasEMCFlag end [Charged Traveller 7 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then hmef.HasManualEMCFlag end [Charged Traveller 7 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then e.EMCScore end [Charged Traveller 7 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 7 then e.ApplicationID end [Charged Traveller 7 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then Gender end [Charged Traveller 8 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then DOB end [Charged Traveller 8 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then hef.HasEMCFlag end [Charged Traveller 8 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then hmef.HasManualEMCFlag end [Charged Traveller 8 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then e.EMCScore end [Charged Traveller 8 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 8 then e.ApplicationID end [Charged Traveller 8 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then Gender end [Charged Traveller 9 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then DOB end [Charged Traveller 9 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then hef.HasEMCFlag end [Charged Traveller 9 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then hmef.HasManualEMCFlag end [Charged Traveller 9 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then e.EMCScore end [Charged Traveller 9 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 9 then e.ApplicationID end [Charged Traveller 9 EMC Reference],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then Gender end [Charged Traveller 10 Gender],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then DOB end [Charged Traveller 10 DOB],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then hef.HasEMCFlag end [Charged Traveller 10 Has EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then hmef.HasManualEMCFlag end [Charged Traveller 10 Has Manual EMC],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then e.EMCScore end [Charged Traveller 10 EMC Score],  
                        case when row_number() over (order by PolicyTravellerID) = 10 then e.ApplicationID end [Charged Traveller 10 EMC Reference]  
                    from  
                        [db-au-actuary].ws.CustomerOnBasePolicy cb  
                        left join [db-au-cba]..emcApplications ea with(nolock) on  
                            ea.ApplicationID <> 0 and  
                            ea.ApplicationID = [db-au-cba].dbo.fn_StrToInt(replace(isnull(cb.ClientID,''),'.00',''))  
                        cross apply  
                        (  
                            select  
                                ea.ApplicationID,  
                                cb.CustomerID PolicyTravellerID,  
                                case  
                                    when rtrim(ltrim(lower(cb.Title))) in ('mr', 'mstr') then 'M'  
                                    when rtrim(ltrim(lower(cb.Title))) in ('mrs', 'ms', 'miss') then 'F'  
                               else 'U'  
                                end Gender,  
                                cb.DateOfBirth DOB,  
                                EMCPremiumAmount PremiumIncrease,  
                                ApplicationType,  
                                MedicalRisk EMCScore  
                        ) e  
                        outer apply  
                        (  
                            select  
                                case  
                                    when isnull(e.PremiumIncrease, 0) <> 0 then 1  
                                    else 0  
                                end HasEMCFlag  
                        ) hef  
                        outer apply  
                        (  
                            select  
                                case  
                                    when hef.HasEMCFlag = 0 then 0  
                                    when e.ApplicationType is null then 0  
                                    when e.ApplicationType = 'Healix' then 0  
                                    else 1  
                                end HasManualEMCFlag  
                        ) hmef  
                    where  
                        cb.PolicyKey = pl.AncestorPolicyKey and  
                        cb.PersonIsAdult = 1  
                    order by  
                        PolicyTravellerID  
                ) otv  
        ) tptvl  
        outer apply  
        (  
            select top 1  
                [Max EMC Score],  
                [Total EMC Score]  
            from  
                [db-au-actuary].ws.EMCGroupScore es  
            where  
                es.SourceSystem = 'TRIPS' and  
                es.SourceKey = p.PolicyKey  
        ) es  
    where  
        isnull(p.isTripsPolicy, 0) = 1 and  
        p.CreateDate >= @StartDate and  
        p.CreateDate <  dateadd(day, 1, @EndDate)  
  
    union all  
      
    /* corporate policies */  
    select  
        q.CountryKey [Domain Country],  
        'CM' [Company],  
        q.QuoteKey [PolicyKey],  
        qi.BankRecordKey + isnull('-' + qd.DestinationKey, '') [PolicyTransactionKey],  
        1 [isParent],  
        convert(varchar(50), q.PolicyNo) [Base Policy No],  
        convert(varchar(50), q.PolicyNo) [Policy No],  
        q.IssuedDate [Issue Date],  
        isnull(qt.AccountingPeriod, q.IssuedDate) [Transaction Issue Date],  
        isnull(qt.AccountingPeriod, q.IssuedDate) [Posting Date],  
        'Base' [Transaction Type],  
        'Active' [Policy Status],  
        'Active' [Transaction Status],  
     convert(date, q.PolicyStartDate) [Departure Date],  
     convert(date, q.PolicyExpiryDate) [Return Date],  
        datediff(day, q.IssuedDate, convert(date, q.PolicyStartDate)) [Lead Time],  
        isnull(qd.NoDays, 0) [Maximum Trip Length],  
        datediff(day, q.PolicyStartDate, q.PolicyExpiryDate) + 1 [Trip Duration],  
        abs(isnull(qd.TotDays, 0)) [Trip Length],  
        isnull(qd.DestinationDesc, '') [Area Name],  
        case  
            when qd.DestinationDesc in   
                (  
                    'Americas, Africa,Middle East Japan, China, Mongolia, Former Soviet State and all other areas not stated below',   
                    'The Americas and Africa',   
                    'South America, Middle East, Papua New Guinea'  
                ) then 'Area 1'  
            when qd.DestinationDesc in ('UK and Europe', 'UK/Europe', 'South America, Middle East, Papua New Guinea') then 'Area 2'  
            when qd.DestinationDesc in ('South East Asia and Indian Sub Continent', 'Middle East, China, Japan, the Indian Sub Continent and all other areas not stated', 'North and Central America and Africa') then 'Area 3'  
            when qd.DestinationDesc in ('New Zealand and South Pacific', 'Asia (excluding China and Japan)', 'UK and Republic of Ireland') then 'Area 4'  
            when qd.DestinationDesc in ('Indonesia, South West Pacific, Norfolk Is and New Zealand', 'New Zealand') then 'Area 5'  
            when qd.DestinationDesc in ('Australia (Domestic Travel)', 'Australia', 'Domestic Australia') then 'Area 6'  
            else ''  
        end [Area Number],  
        '' [Destination],  
        isnull(q.Excess, 0) Excess,  
        1 [Group Policy],  
        0 [Has Rental Car],  
        0 [Has Motorcycle],  
        0 [Has Wintersport],  
        case  
            when qi.BankRecordType = 'EMC' then 1  
            else 0  
        end [Has Medical],  
        0 [Has Cruise],  
  
        '' [Single/Family],  
        'Corporate' [Purchase Path],  
        1 [TRIPS Policy],  
        dp.ProductCode [Product Code],  
        '' [Plan Code],  
  '' [Plan Name],  
        dp.ProductName [Product Name],  
        dp.ProductPlan [Product Plan],  
        dp.ProductType [Product Type],   
        dp.ProductGroup [Product Group],  
        dp.PolicyType [Policy Type],  
        dp.PlanType [Plan Type],  
        dp.TripType [Trip Type],  
        dp.ProductClassification [Product Classification],  
        dp.FinanceProductCode [Finance Product Code],  
        o.OutletKey [OutletKey],  
        o.AlphaCode [Alpha Code],  
        o.AlphaCode [Original Alpha Code],  
        o.AlphaCode [Transaction Alpha Code],  
        o.OutletKey [Transaction OutletKey],  
  
        '' [Customer Post Code],  
        1 [Unique Traveller Count],  
        1 [Unique Charged Traveller Count],  
        1 [Traveller Count],  
        1 [Charged Traveller Count],  
        1 [Adult Traveller Count],  
        case  
            when qi.BankRecordType = 'EMC' then 1  
            else 0  
        end [EMC Traveller Count],  
        null [Youngest Charged DOB],  
        null [Oldest Charged DOB],  
        null [Youngest Age],  
        null [Oldest Age],  
        null [Youngest Charged Age],  
        null [Oldest Charged Age],  
  
        isnull(es.[Max EMC Score], 0) [Max EMC Score],  
        isnull(es.[Total EMC Score], 0) [Total EMC Score],  
  
        null [EMC Tier Oldest Charged],  
        null [EMC Tier Youngest Charged],  
  
        'U' [Charged Traveller 1 Gender],  
        null [Charged Traveller 1 DOB],  
        null [Charged Traveller 1 Has EMC],  
        null [Charged Traveller 1 Has Manual EMC],  
        null [Charged Traveller 1 EMC Score],  
        null [Charged Traveller 1 EMC Reference],  
        'U' [Charged Traveller 2 Gender],  
        null [Charged Traveller 2 DOB],  
        null [Charged Traveller 2 Has EMC],  
        null [Charged Traveller 2 Has Manual EMC],  
        null [Charged Traveller 2 EMC Score],  
        null [Charged Traveller 2 EMC Reference],  
        'U' [Charged Traveller 3 Gender],  
        null [Charged Traveller 3 DOB],  
        null [Charged Traveller 3 Has EMC],  
        null [Charged Traveller 3 Has Manual EMC],  
        null [Charged Traveller 3 EMC Score],  
        null [Charged Traveller 3 EMC Reference],  
        'U' [Charged Traveller 4 Gender],  
        null [Charged Traveller 4 DOB],  
        null [Charged Traveller 4 Has EMC],  
        null [Charged Traveller 4 Has Manual EMC],  
        null [Charged Traveller 4 EMC Score],  
        null [Charged Traveller 4 EMC Reference],  
        'U' [Charged Traveller 5 Gender],  
        null [Charged Traveller 5 DOB],  
        null [Charged Traveller 5 Has EMC],  
        null [Charged Traveller 5 Has Manual EMC],  
        null [Charged Traveller 5 EMC Score],  
        null [Charged Traveller 5 EMC Reference],  
        'U' [Charged Traveller 6 Gender],  
        null [Charged Traveller 6 DOB],  
        null [Charged Traveller 6 Has EMC],  
        null [Charged Traveller 6 Has Manual EMC],  
        null [Charged Traveller 6 EMC Score],  
        null [Charged Traveller 6 EMC Reference],  
        'U' [Charged Traveller 7 Gender],  
        null [Charged Traveller 7 DOB],  
        null [Charged Traveller 7 Has EMC],  
        null [Charged Traveller 7 Has Manual EMC],  
      null [Charged Traveller 7 EMC Score],  
        null [Charged Traveller 7 EMC Reference],  
      'U' [Charged Traveller 8 Gender],  
        null [Charged Traveller 8 DOB],  
        null [Charged Traveller 8 Has EMC],  
        null [Charged Traveller 8 Has Manual EMC],  
        null [Charged Traveller 8 EMC Score],  
        null [Charged Traveller 8 EMC Reference],  
        'U' [Charged Traveller 9 Gender],  
        null [Charged Traveller 9 DOB],  
        null [Charged Traveller 9 Has EMC],  
        null [Charged Traveller 9 Has Manual EMC],  
        null [Charged Traveller 9 EMC Score],  
        null [Charged Traveller 9 EMC Reference],  
        'U' [Charged Traveller 10 Gender],  
        null [Charged Traveller 10 DOB],  
        null [Charged Traveller 10 Has EMC],  
        null [Charged Traveller 10 Has Manual EMC],  
        null [Charged Traveller 10 EMC Score],  
        null [Charged Traveller 10 EMC Reference],  
  
        '' [Commission Tier],  
        0 [Volume Commission],  
        0 [Discount],  
  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Base Base Premium],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Base Premium],  
        0 [Canx Premium],  
        0 [Undiscounted Canx Premium],  
        0 [Rental Car Premium],  
        0 [Motorcycle Premium],  
        case  
            when qi.BankRecordType = 'Luggage' then 1  
            else 0  
        end *  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Luggage Premium],  
        case  
            when qi.BankRecordType = 'EMC' then 1  
            else 0  
        end *  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Medical Premium],  
        0 [Winter Sport Premium],  
        0 [Cruise Premium],  
  
        0 [Luggage Increase],  
        0 [Rental Car Increase],  
        0 [Trip Cost],  
  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Unadjusted Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumGST  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumGST  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumGST  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumGST  
                end  
            else qtt.TotalPremiumGST  
        end [Unadjusted GST on Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumSD  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumSD  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumSD  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumSD  
                end  
      else qtt.TotalPremiumSD  
        end [Unadjusted Stamp Duty on Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            else qtt.TotalCommission  
        end [Unadjusted Agency Commission],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommissionGST  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommissionGST  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommissionGST  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommissionGST  
                end  
            else qtt.TotalCommissionGST  
        end [Unadjusted GST on Agency Commission],  
        0 [Unadjusted Stamp Duty on Agency Commission],  
        0 [Unadjusted Admin Fee],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end [Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumGST  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumGST  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumGST  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumGST  
                end  
            else qtt.TotalPremiumGST  
     end [GST on Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumSD  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumSD  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremiumSD  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremiumSD  
                end  
            else qtt.TotalPremiumSD  
        end [Stamp Duty on Sell Price],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            else qtt.TotalPremium  
        end [Premium],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            else qtt.TotalPremium  
        end [Risk Nett],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            else qtt.TotalPremium  
        end [GUG],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            else qtt.TotalCommission  
        end [Agency Commission],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommissionGST  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommissionGST  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommissionGST  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommissionGST  
                end  
            else qtt.TotalCommissionGST  
        end [GST on Agency Commission],  
        0 [Stamp Duty on Agency Commission],  
        0 [Admin Fee],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalPremium  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalPremium  
                end  
            else qtt.TotalPremium  
        end -  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            else qtt.TotalCommission  
        end [NAP],  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalSellprice  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalSellprice  
                end  
            else qtt.TotalSellprice  
        end -  
        case  
            when qi.BankRecordType = 'DaysPaid' then  
                case  
                    when sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else isnull(qd.DaysLoad, 0) / sum(isnull(qd.DaysLoad, 0)) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            when qi.BankRecordType = 'EMC' then  
                case  
                    when sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) = 0 then qtt.TotalCommission  
                    else qe.EMCLoading / sum(qe.EMCLoading) over (partition by q.QuoteKey, qi.ItemID, isnull(qt.AccountingPeriod, q.IssuedDate)) * qtt.TotalCommission  
                end  
            else qtt.TotalCommission  
        end [NAP (incl Tax)],  
  
        null [Policy Count],  
        null [Price Beat Policy],  
        null [Competitor Name],  
        null [Competitor Price],  
          
        q.QuoteID PolicyID,  
        '' Category  
  
    from  
        [db-au-cba].dbo.corpQuotes q with(nolock)  
        inner join [db-au-cba].dbo.vcorpItems qi with(nolock) on   
      qi.QuoteKey = q.QuoteKey  
        inner join [db-au-cba].dbo.corpTaxes qt with(nolock) on  
      qi.QuoteKey = qt.QuoteKey and   
      qi.ItemID = qt.ItemID  
        cross apply  
        (  
            select  
             isnull(qt.UWSaleExGST, 0) - (isnull(qt.DomStamp, 0) + isnull(qt.IntStamp, 0)) TotalPremium,  
             isnull(qt.UWSaleExGST, 0) + isnull(qt.GSTGross, 0) TotalSellPrice,  
             isnull(qt.DomStamp, 0) + isnull(qt.IntStamp, 0) TotalPremiumSD,  
                isnull(qt.GSTGross, 0) TotalPremiumGST,  
                isnull(qt.AgtCommExGST, 0) + isnull(qt.GSTAgtComm, 0) TotalCommission,  
                isnull(qt.GSTAgtComm, 0) TotalCommissionGST  
        ) qtt  
        outer apply  
        (  
            select top 1   
                *  
            from  
                [db-au-star].dbo.dimProduct with(nolock)  
            where  
                Country = q.CountryKey and  
                ProductCode = 'CMC'  
        ) dp  
        outer apply  
        (  
            select top 1  
                o.OUtletKey,  
                o.AlphaCode  
            from  
                [db-au-cba].dbo.penOutlet o with(nolock)  
            where  
          o.CountryKey = q.CountryKey and  
          o.AlphaCode = q.AgencyCode and  
          o.OutletStatus = 'Current'  
        ) o  
        left join [db-au-cba].dbo.corpDestination qd with(nolock) on  
            qd.QuoteKey = q.QuoteKey and  
            qd.DaysPaidID = qi.ItemID and  
            qi.BankRecordType = 'DaysPaid' and  
            qd.TotDays <> 0  
        left join [db-au-cba].dbo.corpEMC qe with(nolock) on  
            qe.QuoteKey = q.QuoteKey and  
            qe.EMCID = qi.ItemID and  
            qi.BankRecordType = 'EMC' and  
            qe.EMCLoading <> 0  
        outer apply  
        (  
            select  
                case  
                    when qd.TotDays > 0 then 1  
                    when qd.TotDays < 0 then -1  
                    else 0  
                end PolicyCount  
        ) qp  
    outer apply  
        (  
            select top 1  
                [Max EMC Score],  
                [Total EMC Score]  
 from  
                [db-au-actuary].ws.EMCGroupScore es  
            where  
                es.SourceSystem = 'Corporate' and  
                es.SourceKey = q.QuoteKey  
        ) es  
    where  
        q.PolicyNo is not null and  
        (  
            qt.PropBal = 'P' or  
            qt.AccountingPeriod is not null  
        ) and  
        isnull(qt.AccountingPeriod, q.IssuedDate) >= @StartDate and  
        isnull(qt.AccountingPeriod, q.IssuedDate) <  dateadd(day, 1, @EndDate)  
  
  
    --process EMC Tier  
    if object_id('tempdb..#dump') is not null  
        drop table #dump  
  
    select   
        PolicyKey,  
        [Charged Traveller 1 DOB],  
        [Charged Traveller 1 EMC Reference],  
        [Charged Traveller 2 DOB],  
        [Charged Traveller 2 EMC Reference],  
        [Charged Traveller 3 DOB],  
        [Charged Traveller 3 EMC Reference],  
        [Charged Traveller 4 DOB],  
        [Charged Traveller 4 EMC Reference],  
        [Charged Traveller 5 DOB],  
        [Charged Traveller 5 EMC Reference],  
        [Charged Traveller 6 DOB],  
        [Charged Traveller 6 EMC Reference],  
        [Charged Traveller 7 DOB],  
        [Charged Traveller 7 EMC Reference],  
        [Charged Traveller 8 DOB],  
        [Charged Traveller 8 EMC Reference],  
        [Charged Traveller 9 DOB],  
        [Charged Traveller 9 EMC Reference],  
        [Charged Traveller 10 DOB],  
        [Charged Traveller 10 EMC Reference]  
    into #dump  
    from  
        ws.DWHDataSet t  
    where  
        [Posting Date] >= @StartDate and  
        [Posting Date] <  dateadd(day, 1, @EndDate)  
  
  
    if object_id('tempdb..#unpivot') is not null  
        drop table #unpivot  
  
    select   
        us.*  
    into #unpivot  
    from  
        (  
            select *  
            from  
                #dump t  
        ) t  
        unpivot   
        (  
            DOB for  
            Traveller in  
            (  
                [Charged Traveller 1 DOB],  
                [Charged Traveller 2 DOB],  
                [Charged Traveller 3 DOB],  
                [Charged Traveller 4 DOB],  
                [Charged Traveller 5 DOB],  
                [Charged Traveller 6 DOB],  
                [Charged Traveller 7 DOB],  
                [Charged Traveller 8 DOB],  
                [Charged Traveller 9 DOB],  
                [Charged Traveller 10 DOB]  
            )  
        ) ud  
        unpivot   
        (  
            EMCReference for  
            Travellers in  
            (  
                [Charged Traveller 1 EMC Reference],  
                [Charged Traveller 2 EMC Reference],  
                [Charged Traveller 3 EMC Reference],  
                [Charged Traveller 4 EMC Reference],  
                [Charged Traveller 5 EMC Reference],  
                [Charged Traveller 6 EMC Reference],  
                [Charged Traveller 7 EMC Reference],  
                [Charged Traveller 8 EMC Reference],  
                [Charged Traveller 9 EMC Reference],  
                [Charged Traveller 10 EMC Reference]  
            )  
        ) us  
    where  
        left(us.Travellers, 20) = left(us.Traveller, 20)  
  
    if object_id('tempdb..#emctier') is not null  
        drop table #emctier  
  
    select   
        t.PolicyKey,  
        --old.EMCReference,  
        --young.EMCReference,  
        OldestTier,  
        YoungestTier  
    into #emctier  
    from  
        (  
            select distinct  
                PolicyKey  
            from  
                #unpivot t  
        ) t  
        outer apply  
        (  
            select top 1   
                r.EMCReference  
            from  
                #unpivot r  
            where  
                r.PolicyKey = t.PolicyKey  
            order by  
                r.DOB  
        ) old  
        outer apply  
        (  
            select top 1   
                r.EMCReference  
  from  
                #unpivot r  
            where  
                r.PolicyKey = t.PolicyKey  
            order by  
                r.DOB desc  
        ) young  
        outer apply  
        (  
            select top 1  
                try_convert(int, replace(a.AddOnCode, 'EMCT', '')) OldestTier  
            from  
                [db-au-cba].dbo.penPolicyEMC pe with(nolock)  
                inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt with(nolock) on  
                    ptt.PolicyTravellerTransactionKey = pe.PolicyTravellerTransactionKey  
                inner join [db-au-cba].dbo.penPolicyTraveller ptv with(nolock) on  
                    ptv.PolicyTravellerKey = ptt.PolicyTravellerKey  
                inner join [db-au-cba].dbo.penAddOn a with(nolock) on  
                    a.AddOnID = pe.AddOnID and  
                    a.DomainKey = pe.DomainKey  
            where  
                pe.EMCRef = old.EMCReference and  
                ptv.PolicyKey = t.PolicyKey  
        ) ot  
        outer apply  
        (  
            select top 1  
                try_convert(int, replace(a.AddOnCode, 'EMCT', '')) YoungestTier  
            from  
                [db-au-cba].dbo.penPolicyEMC pe with(nolock)  
                inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt with(nolock) on  
                    ptt.PolicyTravellerTransactionKey = pe.PolicyTravellerTransactionKey  
                inner join [db-au-cba].dbo.penPolicyTraveller ptv with(nolock) on  
                    ptv.PolicyTravellerKey = ptt.PolicyTravellerKey  
                inner join [db-au-cba].dbo.penAddOn a with(nolock) on  
                    a.AddOnID = pe.AddOnID and  
                    a.DomainKey = pe.DomainKey  
            where  
                young.EMCReference <> old.EMCReference and  
                pe.EMCRef = young.EMCReference and  
                ptv.PolicyKey = t.PolicyKey  
        ) yt  
      
    update ds  
    set  
        ds.[EMC Tier Oldest Charged] = r.OldestTier,  
        ds.[EMC Tier Youngest Charged] = r.YoungestTier  
    from  
        #emctier r  
        inner join ws.DWHDataSet ds on  
            ds.PolicyKey = r.PolicyKey  
  
  
   
  
 SELECT DISTINCT  a.productcode, B.ProductName, ProductType,ProductGroup,PolicyType,ProductClassification,B.FinanceProductCode,PlanType,TripType, a.ProductCode +' ' +ProductName +' ' + PlanName AS  ProductPlan  
 ,PlanCode--,[OutletKey]  
 INTO #T1  
   FROM  (SELECT DISTINCT PlanCode,Productcode, financeproductCode,PlanName FROM [db-au-cba].[dbo].[penProductPlan]) A  
   LEFT OUTER JOIN  [db-au-star].[dbo].[dimProduct]  B ON   
   A.ProductCode=B.[ProductCode] AND A.[FinanceProductCode] = B.[FinanceProductCode]  
   WHERE B.ProductGroup IS NOT NULL --AND B.PRODUCTCODE='CBA'  
   ORDER BY ProductCode  
  
  
  
    
 -- Update Blank Plan Code  
 UPDATE A SET  
 [Plan Code]    = [PlanCode]   
 -- SELECT *  
 FROM (SELECT DISTINCT  ProductCode,PlanCode from #T1    
    WHERE ISNULL(PRODUCTCODE,'')<>'') B  
 INNER JOIN [db-au-actuary].[ws].[DWHDataSet]  A ON  B.productcode = A.[Product Code]  
 WHERE ISNULL([Plan Code],'')=''  
  
  
 -- Remove duplicate records  
  
 SELECT  B.*,A.[Product Code],a.[Plan Code],A.BIRowID  
 INTO #T2  
   FROM [db-au-actuary].[ws].[DWHDataSet] A (NOLOCK)  
   LEFT OUTER JOIN  #T1  B (NOLOCK) On A.[Product Code]=B.productcode AND A.[Plan Code]=B.PlanCode  
   where ISNULL([Plan Type],'')='' OR ISNULL([Product Plan],'')=''   
  
  
 ALTER TABLE #T2 ADD  ID_T2 INT IDENTITY (1,1)  
  
 DELETE from #T2 WHERE ID_T2 IN (  
 SELECT ID_T2 FROM #T2   
 inner join   
  (  
   SELECT  [Product Code],[Plan Code],birOWid from #T2 GROUP BY [Product Code],[Plan Code],birOWid  
   Having Count (*)>1  
  
  ) A on a.BIRowID=#T2.BIRowID where ProductGroup ='NULL'  
 )  
  
  
 UPDATE A SET  
 [Product Name]    = ProductName,  
 [Product Plan]    =   [ProductPlan],                                                                                       
 [Product Type]    =   ProductType ,                                                                                   
 [Product Group]    =   ProductGroup ,                         
 [Policy Type]    =   PolicyType   ,                          
 [Plan Type]     =   ProductClassification,                       
 [Trip Type]     =   TripType          ,                  
 [Product Classification]    =   ProductClassification  ,                                                                         
 [Finance Product Code]  = FinanceProductCode  
 -- SELECT  A.[Product Plan] ,[ProductPlan]   ,    *   
 FROM #T2  INNER JOIN [db-au-actuary].[ws].[DWHDataSet]  A ON  #T2.BIRowID = A.BIRowID  
 WHERE ISNULL([Plan Type],'')='' OR ISNULL([Product Plan],'')=''  
  
  
  
end  
  
  
  
  
  
  
GO
