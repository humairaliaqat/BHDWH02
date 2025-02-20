USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyAdminCallComment]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPolicyAdminCallComment]
as
begin

/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:           20120821
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    CRM Policy Admin Call Comments table contains comment details
                This transformation adds essential key fields
Change History:
                20120821 - LS - create proc
                20121107 - LS - refactoring & domain related changes
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20140805 - LT - TFS 13021, changed PolicyNumber from bigint to varchar(50)
				20160321 - LT - Penguin 18.0, added US Penguin instance
				20180913 - LT - Customised for CBA
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    /* transform */
    if object_id('etl_penPolicyAdminCallComment') is not null
        drop table etl_penPolicyAdminCallComment

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, c.CallCommentID) CallCommentKey,
        PrefixKey + convert(varchar, c.PolicyID) PolicyKey,
        PrefixKey + convert(varchar, c.CRMUserID) CRMUserKey,
        DomainID,
        c.CallCommentID,
        c.PolicyID,
        p.PolicyNumber,
        c.CRMUserID,
        dbo.xfn_ConvertUTCtoLocal(c.CommentDate, TimeZone) CallDate,
        c.CommentDate CallDateUTC,
        dbo.fn_GetReferenceValueByID(c.ReasonID, CompanyKey, CountrySet) CallReason,
        convert(varchar(max), c.Comment) as CallComment
    into etl_penPolicyAdminCallComment
    from
        penguin_tblPolicyAdminCallComment_aucm c
        cross apply
        (
            select top 1
                PolicyNumber,
                DomainID
            from
                (
                    select
                        PolicyNumber collate database_default PolicyNumber,
                        DomainID
                    from
                        penguin_tblPolicy_aucm p
                    where
                        p.PolicyID = c.PolicyID
                ) p
        ) p
        cross apply dbo.fn_GetDomainKeys(p.DomainId, 'CM', 'AU') dk



    /* prepare destination */
    if object_id('[db-au-cba].dbo.penPolicyAdminCallComment') is null
    begin

        create table [db-au-cba].dbo.[penPolicyAdminCallComment]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(3) not null,
            [CallCommentKey] varchar(41) not null,
            [PolicyKey] varchar(41) null,
            [CRMUserKey] varchar(41) null,
            [CallCommentID] int not null,
            [PolicyID] int null,
            [PolicyNumber] varchar(50) null,
            [CRMUserID] int null,
            [CallDate] datetime null,
            [CallReason] nvarchar(50) null,
            [CallComment] nvarchar(max) null,
            [DomainID] int null,
            [CallDateUTC] datetime null
        )

        create clustered index idx_penPolicyAdminCallComment_PolicyKey on [db-au-cba].dbo.penPolicyAdminCallComment(PolicyKey)
        create nonclustered index idx_penPolicyAdminCallComment_CallCommentKey on [db-au-cba].dbo.penPolicyAdminCallComment(CallCommentKey)
        create nonclustered index idx_penPolicyAdminCallComment_CallDate on [db-au-cba].dbo.penPolicyAdminCallComment(CallDate,CountryKey)
        create nonclustered index idx_penPolicyAdminCallComment_CallReason on [db-au-cba].dbo.penPolicyAdminCallComment(CallReason,CountryKey)
        create nonclustered index idx_penPolicyAdminCallComment_CRMUserKey on [db-au-cba].dbo.penPolicyAdminCallComment(CRMUserKey)
        create nonclustered index idx_penPolicyAdminCallComment_PolicyNumber on [db-au-cba].dbo.penPolicyAdminCallComment(PolicyNumber,CountryKey)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penPolicyAdminCallComment a
            inner join etl_penPolicyAdminCallComment b on
                a.CallCommentKey = b.CallCommentKey

    end


    /* output */
    insert into [db-au-cba].dbo.penPolicyAdminCallComment with(tablockx)
    (
        CountryKey,
        CompanyKey,
        CallCommentKey,
        PolicyKey,
        CRMUserKey,
        DomainID,
        CallCommentID,
        PolicyID,
        PolicyNumber,
        CRMUserID,
        CallDate,
        CallDateUTC,
        CallReason,
        CallComment
    )
    select
        CountryKey,
        CompanyKey,
        CallCommentKey,
        PolicyKey,
        CRMUserKey,
        DomainID,
        CallCommentID,
        PolicyID,
        PolicyNumber,
        CRMUserID,
        CallDate,
        CallDateUTC,
        CallReason,
        CallComment
    from
        etl_penPolicyAdminCallComment

end



GO
