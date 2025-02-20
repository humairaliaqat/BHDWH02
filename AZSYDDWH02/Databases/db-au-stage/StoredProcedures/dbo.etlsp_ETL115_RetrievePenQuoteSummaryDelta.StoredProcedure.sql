USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL115_RetrievePenQuoteSummaryDelta]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--CREATE 
CREATE
procedure [dbo].[etlsp_ETL115_RetrievePenQuoteSummaryDelta]
 @StartDate date = null,
    @EndDate date = null
    
as
begin
/************************************************************************************************************************************
Author:         Ratnesh Sharma
Date:           20181121
Description:    import penQuoteSummary delta for CBA
Parameters:     
Change History:
                20190319 - RS - created
				20191119 - RS - Moving the proc to CBA server. Correcting table names from <tablename>_CBA to <tablename>. Changed subjectArea from "CDG Quote Bigquery CBA" to "CDG Quote Bigquery".

*************************************************************************************************************************************/
    set nocount on

--uncomment to debug
/*
	declare @StartDate datetime
	declare @EndDate datetime
	select @StartDate = '2018-10-11', @EndDate = '2018-10-14'
*/

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    --declare @mergeoutput table (MergeAction varchar(20))


    if @StartDate is null and @EndDate is null
    begin
    
        exec syssp_getrunningbatch
            @SubjectArea = 'CDG Quote Bigquery',
            @BatchID = @batchid out,
            @StartDate = @start out,
            @EndDate = @end out

        select
            @name = object_name(@@procid)

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'
            
    end
    else
        select
            @start = @StartDate,
            @end = @EndDate


	 delete [db-au-cba]..penQuoteSummary
        where
            QuoteDate >= @start and
            QuoteDate <  dateadd(day, 1, @end)
	

    insert into [db-au-cba]..penQuoteSummary
	(QuoteDate,QuoteSource,CountryKey,CompanyKey,OutletAlphaKey,StoreCode,UserKey,CRMUserKey,SaveStep,CurrencyCode,Area,Destination,PurchasePath,ProductKey,ProductCode,ProductName,PlanCode,PlanName,PlanType,MaxDuration,Duration,LeadTime,Excess,CompetitorName,CompetitorGap,PrimaryCustomerAge,PrimaryCustomerSuburb,PrimaryCustomerState,YoungestAge,OldestAge,NumberOfChildren,NumberOfAdults,NumberOfPersons,QuotedPrice,QuoteSessionCount,QuoteCount,QuoteWithPriceCount,SavedQuoteCount,ConvertedCount,ExpoQuoteCount,AgentSpecialQuoteCount,PromoQuoteCount,UpsellQuoteCount,PriceBeatQuoteCount,QuoteRenewalCount,CancellationQuoteCount,LuggageQuoteCount,MotorcycleQuoteCount,WinterQuoteCount,EMCQuoteCount)
    select 
	QuoteDate,QuoteSource,CountryKey,CompanyKey,OutletAlphaKey,StoreCode,UserKey,CRMUserKey,SaveStep,CurrencyCode,Area,Destination,PurchasePath,ProductKey,ProductCode,ProductName,PlanCode,PlanName,PlanType,MaxDuration,Duration,LeadTime,Excess,CompetitorName,CompetitorGap,PrimaryCustomerAge,PrimaryCustomerSuburb,PrimaryCustomerState,YoungestAge,OldestAge,NumberOfChildren,NumberOfAdults,NumberOfPersons,QuotedPrice,QuoteSessionCount,QuoteCount,QuoteWithPriceCount,SavedQuoteCount,ConvertedCount,ExpoQuoteCount,AgentSpecialQuoteCount,PromoQuoteCount,UpsellQuoteCount,PriceBeatQuoteCount,QuoteRenewalCount,CancellationQuoteCount,LuggageQuoteCount,MotorcycleQuoteCount,WinterQuoteCount,EMCQuoteCount
    from
        [db-au-stage]..etl_penQuoteSummary
    

end


GO
