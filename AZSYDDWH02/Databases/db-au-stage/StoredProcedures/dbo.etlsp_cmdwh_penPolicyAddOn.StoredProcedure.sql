USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyAddOn]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPolicyAddOn]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120127
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    Transform penPolicyAddOn table and adding essential key fields

Change History:
                20120127 - LT - Procedure created
                20121107 - LS - refactoring & domain related changes
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20131204 - LS - case 19524, index optimisation for new pricing calculation
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
				20160321 - LT - Penguin 18.0, added US Penguin instance

*************************************************************************************************************************************/

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    set nocount on

    if object_id('etl_penPolicyAddOn') is not null
        drop table etl_penPolicyAddOn

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, pa.ID) PolicyAddOnKey,
        PrefixKey + convert(varchar, pa.PolicyTransactionID) PolicyTransactionKey,
        PrefixKey + convert(varchar, pa.AddOnID) AddOnKey,
        DomainID,
        pa.ID as PolicyAddOnID,
        pa.PolicyTransactionID,
        pa.AddOnID,
        a.AddonCode,
        a.AddonName,
        a.DisplayName,
        pa.AddOnValueID,
        av.AddonValueCode,
        av.AddonValueDesc,
        av.AddonValuePremiumIncrease,
        pa.CoverIncrease,
        pa.AddOnGroup,
        pa.AddOnText,
        pa.isRateCardBased
    into etl_penPolicyAddOn
    from
        penguin_tblPolicyAddon_aucm pa
        inner join penguin_tblPolicyTransaction_aucm pt
            on pt.ID = pa.PolicyTransactionId
        cross apply dbo.fn_GetPolicyDomainKeys(pt.PolicyID, pt.CRMUserID, pt.ConsultantID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                AddonCode,
                AddonName,
                DisplayName
            from
                penguin_tblAddon_aucm a
            where
                a.AddonID = pa.AddonID
        ) a
        outer apply
        (
            select top 1
                Code AddonValueCode,
                [Description] AddonValueDesc,
                PremiumIncrease AddonValuePremiumIncrease
            from
                penguin_tblAddonValue_aucm av
            where
                av.AddonValueID = pa.AddonValueID
        ) av

    


    if object_id('[db-au-cba].dbo.penPolicyAddOn') is null
    begin

        create table [db-au-cba].dbo.[penPolicyAddOn]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyAddOnKey] varchar(41) null,
            [PolicyTransactionKey] varchar(41) null,
            [AddOnKey] varchar(33) null,
            [PolicyAddOnID] int not null,
            [PolicyTransactionID] int not null,
            [AddOnID] int not null,
            [AddonCode] nvarchar(50) null,
            [AddonName] nvarchar(50) null,
            [DisplayName] nvarchar(100) null,
            [AddOnValueID] int not null,
            [AddonValueCode] nvarchar(10) null,
            [AddonValueDesc] nvarchar(50) null,
            [AddonValuePremiumIncrease] numeric(18,5) null,
            [CoverIncrease] money not null,
            [AddOnGroup] nvarchar(50) null,
            [AddOnText] nvarchar(500) null,
            [isRateCardBased] bit not null,
            [DomainID] int null
        )

        create clustered index idx_penPolicyAddOn_PolicyTransactionKey on [db-au-cba].dbo.penPolicyAddOn(PolicyTransactionKey)
        create nonclustered index idx_penPolicyAddOn_AddOnKey on [db-au-cba].dbo.penPolicyAddOn(AddOnKey)
        create nonclustered index idx_penPolicyAddOn_CountryKey on [db-au-cba].dbo.penPolicyAddOn(CountryKey,AddOnID)
        create nonclustered index idx_penPolicyAddOn_Pricing on [db-au-cba].dbo.penPolicyAddOn(PolicyTransactionKey) include (AddOnGroup,CountryKey,CompanyKey,PolicyAddOnKey,PolicyAddOnID,CoverIncrease,AddOnText)

    end
    
    
    begin transaction penPolicyAddOn
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penPolicyAddOn a
            inner join etl_penPolicyAddOn b on
                --a.PolicyAddonKey = b.PolicyAddOnKey and
                a.PolicyTransactionKey = b.PolicyTransactionKey

        insert into [db-au-cba].dbo.penPolicyAddOn with(tablockx)
        (
            CountryKey,
            CompanyKey,
            PolicyAddOnKey,
            PolicyTransactionKey,
            AddOnKey,
            DomainID,
            PolicyAddOnID,
            PolicyTransactionID,
            AddOnID,
            AddonCode,
            AddonName,
            DisplayName,
            AddOnValueID,
            AddonValueCode,
            AddonValueDesc,
            AddonValuePremiumIncrease,
            CoverIncrease,
            AddOnGroup,
            AddOnText,
            isRateCardBased
        )
        select
            CountryKey,
            CompanyKey,
            PolicyAddOnKey,
            PolicyTransactionKey,
            AddOnKey,
            DomainID,
            PolicyAddOnID,
            PolicyTransactionID,
            AddOnID,
            AddonCode,
            AddonName,
            DisplayName,
            AddOnValueID,
            AddonValueCode,
            AddonValueDesc,
            AddonValuePremiumIncrease,
            CoverIncrease,
            AddOnGroup,
            AddOnText,
            isRateCardBased
        from
            etl_penPolicyAddOn

    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPolicyAddOn
            
        exec syssp_genericerrorhandler 'penPolicyAddOn data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPolicyAddOn

end


GO
