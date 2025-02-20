USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyTravellerTransaction]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPolicyTravellerTransaction]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120127
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    Policy Traveller Transaction table contains policy transactions attributes.
                This transformation adds essential key fields
Change History:
                20120127 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20131204 - LS - case 19524, index optimisation for new pricing calculation
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
                20150808 - LS - TFS 15452, add MemberRewardFactor & MemberRewardPointsEarned
				20160321 - LT - Penguin 18.0, added US Penguin instance

*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penPolicyTravellerTransaction') is not null
        drop table etl_penPolicyTravellerTransaction

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, ptt.ID) PolicyTravellerTransactionKey,
        PrefixKey + convert(varchar, ptt.PolicyTransactionID) PolicyTransactionKey,
        PrefixKey + convert(varchar, ptt.PolicyTravellerID) PolicyTravellerKey,
        ptt.ID as PolicyTravellerTransactionID,
        ptt.PolicyTransactionID,
        ptt.PolicyTravellerID,
        ptt.HasEMC,
        ptt.TripsTravellerID,
        ptt.MemberRewardFactor,
        ptt.MemberRewardPointsEarned
    into etl_penPolicyTravellerTransaction
    from
        penguin_tblPolicyTravellerTransaction_aucm ptt
        inner join penguin_tblPolicyTransaction_aucm pt on
            pt.ID = ptt.PolicyTransactionID
        cross apply dbo.fn_GetPolicyDomainKeys(pt.PolicyID, pt.CRMUserID, pt.ConsultantID, 'CM', 'AU') dk

   


    if object_id('[db-au-cba].dbo.penPolicyTravellerTransaction') is null
    begin

        create table [db-au-cba].dbo.[penPolicyTravellerTransaction]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyTravellerTransactionKey] varchar(41) not null,
            [PolicyTransactionKey] varchar(41) null,
            [PolicyTravellerKey] varchar(41) null,
            [PolicyTravellerTransactionID] int not null,
            [PolicyTransactionID] int null,
            [PolicyTravellerID] int not null,
            [HasEMC] bit not null,
            [TripsTravellerID] int null,
            [MemberRewardFactor] decimal(18,2) null,
            [MemberRewardPointsEarned] money null
        )

        create clustered index idx_penPolicyTravellerTransaction_PolicyTransactionKey on [db-au-cba].dbo.penPolicyTravellerTransaction(PolicyTransactionKey)
        create nonclustered index idx_penPolicyTravellerTransaction_PolicyTravellerKey on [db-au-cba].dbo.penPolicyTravellerTransaction(PolicyTravellerKey,PolicyTransactionKey) include (CountryKey,CompanyKey,PolicyTravellerTransactionID,PolicyTravellerTransactionKey)
        create nonclustered index idx_penPolicyTravellerTransaction_PolicyTravellerTransactionKey on [db-au-cba].dbo.penPolicyTravellerTransaction(PolicyTravellerTransactionKey) include (PolicyTransactionKey)

    end


    begin transaction penPolicyTravellerTransaction

    begin try

        delete a
        from
            [db-au-cba].dbo.penPolicyTravellerTransaction a
            inner join etl_penPolicyTravellerTransaction b on
                a.PolicyTravellerTransactionKey = b.PolicyTravellerTransactionKey

        insert into [db-au-cba].dbo.penPolicyTravellerTransaction with(tablockx)
        (
            CountryKey,
            CompanyKey,
            PolicyTravellerTransactionKey,
            PolicyTransactionKey,
            PolicyTravellerKey,
            PolicyTravellerTransactionID,
            PolicyTransactionID,
            PolicyTravellerID,
            HasEMC,
            TripsTravellerID,
            MemberRewardFactor,
            MemberRewardPointsEarned
        )
        select
            CountryKey,
            CompanyKey,
            PolicyTravellerTransactionKey,
            PolicyTransactionKey,
            PolicyTravellerKey,
            PolicyTravellerTransactionID,
            PolicyTransactionID,
            PolicyTravellerID,
            HasEMC,
            TripsTravellerID,
            MemberRewardFactor,
            MemberRewardPointsEarned
        from
            etl_penPolicyTravellerTransaction

        update ptv
        set
            MemberRewardPointsEarned = TotalMemberRewardPointsEarned
        from
            [db-au-cba].dbo.penPolicyTraveller ptv
            outer apply
            (
                select
                    sum(MemberRewardPointsEarned) TotalMemberRewardPointsEarned
                from
                    [db-au-cba].dbo.penPolicyTravellerTransaction ptt
                where
                    ptt.PolicyTravellerKey = ptv.PolicyTravellerKey
            ) ptt
        where
            ptv.PolicyTravellerKey in
            (
                select
                    PolicyTravellerKey
                from
                    etl_penPolicyTravellerTransaction
            )

    end try

    begin catch

        if @@trancount > 0
            rollback transaction penPolicyTravellerTransaction

        exec syssp_genericerrorhandler 'penPolicyTravellerTransaction data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction penPolicyTravellerTransaction

end


GO
