USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penJobError]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penJobError]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20121011
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:
Change History:
                20121011 - LT - Procedure created
                20130418 - LS - change country/domain reference to use Company value
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
				20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
				20140117 - LT - Removed reference to UK penguin data loader. This is now a separate ETL process				
				20151027 - DM - Penguin v16 Release, Alter DataID Column
				20180911 - LT - Customised for CBA

*************************************************************************************************************************************/
    set nocount on

    /*************************************************************/
    --select data into temporary table
    /*************************************************************/
    if object_id('etl_penJobError') is not null
        drop table etl_penJobError

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar,d.ID),41) collate database_default as JobErrorKey,
        left(PrefixKey + convert(varchar,d.JobID),41) collate database_default as JobKey,
        d.ID,
        d.JobID,
        d.Description,
        dbo.xfn_ConvertUTCtoLocal(d.CreateDateTime, TimeZone) as CreateDateTime,
        d.ErrorSource,
        d.DataID,
        d.SourceData
    into etl_penJobError
    from
        penguin_tblJobError_aucm d
        inner join penguin_tblJob_aucm j on
            d.JobID = j.JobID
        cross apply dbo.fn_GetDomainKeys(j.DomainID, j.Company, 'AU') dk

        
    /*************************************************************/
    --delete existing job data or create table if table doesnt exist
    /*************************************************************/
    if object_id('[db-au-cba].dbo.penJobError') is null
    begin

        create table [db-au-cba].dbo.penJobError
        (
            CountryKey varchar(2) null,
            CompanyKey varchar(3) null,
            DomainKey varchar(41) null,
            JobErrorKey varchar(41) null,
            JobKey varchar(41) null,
            ID int null,
            JobID int null,
            [Description] varchar(max) null,
            CreateDateTime datetime null,
            ErrorSource varchar(15) null,
            DataID varchar(300) not null,
            SourceData varchar(max) null
        )

        create clustered index idx_penJobError_JobErrorKey on [db-au-cba].dbo.penJobError(JobErrorKey)
        create index idx_penJobError_CountryKey on [db-au-cba].dbo.penJobError(CountryKey)
        create index idx_penJobError_CompanyKey on [db-au-cba].dbo.penJobError(CompanyKey)
        create index idx_penJobError_JobKey on [db-au-cba].dbo.penJobError(JobKey)
        create index idx_penJobError_DataID on [db-au-cba].dbo.penJobError(DataID)

    end
    else
    begin

        delete [db-au-cba].dbo.penJobError
        from [db-au-cba].dbo.penJobError a
            inner join etl_penJobError b on
                a.JobErrorKey = b.JobErrorKey

    end


    /*************************************************************/
    -- Transfer data from etl_penDataImport to [db-au-cba].dbo.penDataImport
    /*************************************************************/
    insert into [db-au-cba].dbo.penJobError with (tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        JobErrorKey,
        JobKey,
        ID,
        JobID,
        [Description],
        CreateDateTime,
        ErrorSource,
        DataID,
        SourceData
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        JobErrorKey,
        JobKey,
        ID,
        JobID,
        [Description],
        CreateDateTime,
        ErrorSource,
        DataID,
        SourceData
    from
        etl_penJobError

end


GO
