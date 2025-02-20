USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyCompetitor]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penPolicyCompetitor]
as
begin

/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:           20140220
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    This stored procedure transform price beat data.
Change History:
                20140220 - LS - create, case 19851
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
				20160321 - LT - Penguin 18.0, added US Penguin instance

*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penPolicyCompetitor') is not null
        drop table etl_penPolicyCompetitor

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, pc.PolicyID) PolicyKey,
        dbo.xfn_ConvertUTCtoLocal(CreateDateTime, TimeZone) CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(UpdateDateTime, TimeZone) UpdateDateTime,
        CreateDateTime CreateDateTimeUTC,
        UpdateDateTime UpdateDateTimeUTC,
        PolicyID,
        CompetitorID,
        c.Name CompetitorName,
        CompetitorPrice
    into etl_penPolicyCompetitor
    from
        penguin_tblPolicyCompetitor_aucm pc
        left join penguin_tblCompetitor_aucm c on
            c.Id = pc.CompetitorId
        cross apply dbo.fn_GetDomainKeys(c.DomainId, 'CM', 'AU') dk

    


    /**************************************************************************/
    --delete existing data or create table if table doesnt exist
    /**************************************************************************/
    if object_id('[db-au-cba].dbo.penPolicyCompetitor') is null
    begin

        create table [db-au-cba].dbo.[penPolicyCompetitor]
        (
            [BIRowID] bigint not null identity (1,1),
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [DomainKey] varchar(41) null,
            [PolicyKey] varchar(41) null,
            [CreateDateTime] datetime not null,
            [UpdateDateTime] datetime not null,
            [CreateDateTimeUTC] datetime not null,
            [UpdateDateTimeUTC] datetime not null,
            [PolicyID] int not null,
            [CompetitorID] int null,
            [CompetitorName] nvarchar(50) null,
            [CompetitorPrice] money null
        )

        create clustered index idx_penPolicyCompetitor_BIRowID on [db-au-cba].dbo.penPolicyCompetitor(BIRowID)
        create nonclustered index idx_penPolicyCompetitor_CompetitorName on [db-au-cba].dbo.penPolicyCompetitor(CompetitorName)
        create nonclustered index idx_penPolicyCompetitor_CreateDateTime on [db-au-cba].dbo.penPolicyCompetitor(CreateDateTime) include (PolicyKey,CompetitorName,CompetitorPrice)
        create nonclustered index idx_penPolicyCompetitor_PolicyKey on [db-au-cba].dbo.penPolicyCompetitor(PolicyKey) include (CompetitorName,CompetitorPrice)

    end
    
    
    /*****************************************************************************************/
    -- Transfer data from etl_penPolicyCompetitor to [db-au-cba].dbo.penPolicyCompetitor
    /*****************************************************************************************/
    begin transaction penPolicyCompetitor
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penPolicyCompetitor a
            inner join etl_penPolicyCompetitor b on
                a.PolicyKey = b.PolicyKey

        insert into [db-au-cba].dbo.penPolicyCompetitor with (tablockx)
        (
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyKey,
            CreateDateTime,
            UpdateDateTime,
            CreateDateTimeUTC,
            UpdateDateTimeUTC,
            PolicyID,
            CompetitorID,
            CompetitorName,
            CompetitorPrice
        )
        select
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyKey,
            CreateDateTime,
            UpdateDateTime,
            CreateDateTimeUTC,
            UpdateDateTimeUTC,
            PolicyID,
            CompetitorID,
            CompetitorName,
            CompetitorPrice
        from
            etl_penPolicyCompetitor
            
    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPolicyCompetitor
            
        exec syssp_genericerrorhandler 'penPolicyCompetitor data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPolicyCompetitor
    

end


GO
