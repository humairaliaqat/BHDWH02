USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penDataQueue]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penDataQueue]
as
begin

/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:           20130418
Prerequisite:   Requires Penguin Data Loader ETL successfully run.
Description:
Change History:
                20130418 - LS - created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
				20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
				20140117 - LT - Removed reference to UK penguin data loader. This is now a separate ETL process
				20150915 - LT - Penguin 15.0 release, added LastRunTime column
				20151027 - DM - Penguin 16.0 release, added LastSourceUpdated column, Alter DataID column
				20180911 - LT - Customised for CBA
*************************************************************************************************************************************/

    set nocount on

    /*************************************************************/
    --select data into temporary table
    /*************************************************************/
    if object_id('etl_penDataQueue') is not null
        drop table etl_penDataQueue

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar,d.DataQueueID), 41) collate database_default as DataQueueKey,
        left(PrefixKey + convert(varchar,d.JobID), 41) collate database_default as JobKey,
        d.DataQueueID,
        d.JobID,
        d.DataID,
        d.DataQueueTypeID,
        d.DataValue,
        d.Comment,
        d.RetryCount,
        d.Status,
        dbo.xfn_ConvertUTCtoLocal(d.CreateDateTime, TimeZone) as CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(d.CreateDateTime, TimeZone) as UpdateDateTime,
		d.TrooperName,
		dbo.xfn_ConvertUTCtoLocal(d.LastSourceUpdated, TimeZone) as LastSourceUpdated
    into etl_penDataQueue
    from
        penguin_tblDataQueue_aucm d
        inner join penguin_tblJob_aucm j on
            d.JobID = j.JobID
        cross apply dbo.fn_GetDomainKeys(j.DomainID, j.Company, 'AU') dk
        
        
    /*************************************************************/
    --delete existing data import or create table if table doesnt exist
    /*************************************************************/
    if object_id('[db-au-cba].dbo.penDataQueue') is null
    begin

        create table [db-au-cba].dbo.penDataQueue
        (
            CountryKey varchar(2) null,
            CompanyKey varchar(5) null,
            DomainKey varchar(41) null,
            DataQueueKey varchar(41) null,
            JobKey varchar(41) null,
            DataQueueID int null,
            JobID int null,
            DataID varchar(300) not null,
            DataQueueTypeID int null,
            DataValue xml,
            Comment varchar(2000) null,
            RetryCount int null,
            [Status] varchar(15) null,
            CreateDateTime datetime null,
            UpdateDateTime datetime null,
			TrooperName varchar(100) null,
			LastSourceUpdated datetime null
        )

        create clustered index idx_penDataQueue_DataQueueKey on [db-au-cba].dbo.penDataQueue(DataQueueKey)
        create index idx_penDataQueue_JobKey on [db-au-cba].dbo.penDataQueue(JobKey)
        create index idx_penDataQueue_CountryKey on [db-au-cba].dbo.penDataQueue(CountryKey)
        create index idx_penDataQueue_CreateDateTime on [db-au-cba].dbo.penDataQueue(CreateDateTime)
        create index idx_penDataQueue_DataID on [db-au-cba].dbo.penDataQueue(DataID, CountryKey, CompanyKey)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penDataQueue a
            inner join etl_penDataQueue b on
                a.DataQueueKey = b.DataQueueKey

    end


    /*************************************************************/
    -- Transfer data from etl_penDataQueue to [db-au-cba].dbo.penDataQueue
    /*************************************************************/
    insert into [db-au-cba].dbo.penDataQueue with (tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        DataQueueKey,
        JobKey,
        DataQueueID,
        JobID,
        DataID,
        DataQueueTypeID,
        DataValue,
        Comment,
        RetryCount,
        Status,
        CreateDateTime,
        UpdateDateTime,
		TrooperName,
		LastSourceUpdated
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        DataQueueKey,
        JobKey,
        DataQueueID,
        JobID,
        DataID,
        DataQueueTypeID,
        DataValue,
        Comment,
        RetryCount,
        Status,
        CreateDateTime,
        UpdateDateTime,
		TrooperName,
		LastSourceUpdated
    from
        etl_penDataQueue

end


GO
