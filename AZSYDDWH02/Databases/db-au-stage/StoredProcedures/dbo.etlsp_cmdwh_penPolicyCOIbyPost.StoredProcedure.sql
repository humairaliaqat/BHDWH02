USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyCOIbyPost]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penPolicyCOIbyPost]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20180926
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    Transform table and adding essential key fields

Change History:
                20180926 - LT - Procedure created
				20180927 - LT - Customised for CBA
                20181023 - LL - bug fix, don't join to transaction, this creates duplicate records
                                no need to store at transaction level
                                delete on COI id, there may be duplicate requests on policy level
*************************************************************************************************************************************/

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    set nocount on

    if object_id('etl_penPolicyCOIByPost') is not null
        drop table etl_penPolicyCOIByPost

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, pcbp.ID) PolicyCOIByPostKey,
		PrefixKey + convert(varchar, p.PolicyID) PolicyKey,
		--PrefixKey + convert(varchar, pt.ID) PolicyTransactionKey,
        p.DomainID,
		pcbp.ID as PolicyCOIByPostID,
		pcbp.PolicyNumber,		
		dbo.xfn_ConvertUTCtoLocal(pcbp.CreateDateTime, TimeZone) CreateDateTime,
		dbo.xfn_ConvertUTCtoLocal(pcbp.UpdateDateTime, TimeZone) UpdateDateTime,
		pcbp.Postcode,
		pcbp.AddressLine1,
		pcbp.AddressLine2,
		pcbp.Suburb,
		pcbp.[State],
		pcbp.CountryName,
		pcbp.CountryCode,
		pcbp.Comments,
		pcbp.UpdateDateTime as UpdateDateTimeUTC,
		pcbp.CreateDateTime as CreateDateTimeUTC
    into etl_penPolicyCOIByPost
    from
        penguin_tblPolicyCOIByPost_aucm pcbp
		inner join penguin_tblPolicy_aucm p on pcbp.PolicyNumber = p.PolicyNumber
		--inner join penguin_tblPolicyTransaction_aucm pt on p.PolicyID = pt.PolicyID
        --cross apply dbo.fn_GetPolicyDomainKeys(pt.PolicyID, pt.CRMUserID, pt.ConsultantID, 'CM', 'AU') dk
        cross apply dbo.fn_GetDomainKeys(p.DomainId, 'CM', 'AU') dk


    if object_id('[db-au-cba].dbo.penPolicyCOIByPost') is null
    begin

        create table [db-au-cba].dbo.penPolicyCOIByPost
        (
            BIRowID bigint identity (1,1) not null,
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyCOIByPostKey] varchar(41) not null,
			[PolicyKey] varchar(41) not null,
			DomainID int not null,
			PolicyCOIByPostID int not null,
			PolicyNumber varchar(50) not null,
			CreateDateTime datetime not null,
			UpdateDateTime datetime not null,
			Postcode varchar(50) null,
			AddressLine1 nvarchar(200) null,
			AddressLine2 nvarchar(200) null,
			Suburb nvarchar(100) null,
			[State] nvarchar(200) null,
			CountryName nvarchar(200) null,
			CountryCode char(3) null,
			Comments nvarchar(max) null,
			UpdateDateTimeUTC datetime not null,
			CreateDateTimeUTC datetime not null
        )

        create clustered index idx_penPolicyCOIByPost_BIRowID on [db-au-cba].dbo.penPolicyCOIByPost(BIRowID)
        create nonclustered index idx_penPolicyCOIByPost_PolicyCOIByPostKey on [db-au-cba].dbo.penPolicyCOIByPost(PolicyCOIByPostKey)
        create nonclustered index idx_penPolicyCOIByPost_PolicyKey on [db-au-cba].dbo.penPolicyCOIByPost(PolicyKey)

    end
    
    
    begin transaction penPolicyCOIByPost
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penPolicyCOIByPost a
            inner join etl_penPolicyCOIByPost b on
                a.PolicyCOIByPostKey = b.PolicyCOIByPostKey

        insert into [db-au-cba].dbo.penPolicyCOIByPost with(tablockx)
        (
            [CountryKey],
            [CompanyKey],
            [PolicyCOIByPostKey],
			[PolicyKey],
            --[PolicyTransactionKey],
			DomainID,
			PolicyCOIByPostID,
			PolicyNumber,
			CreateDateTime,
			UpdateDateTime,
			Postcode,
			AddressLine1,
			AddressLine2,
			Suburb,
			[State],
			CountryName,
			CountryCode,
			Comments,
			UpdateDateTimeUTC,
			CreateDateTimeUTC
        )
        select
            [CountryKey],
            [CompanyKey],
            [PolicyCOIByPostKey],
			[PolicyKey],
            --[PolicyTransactionKey],
			DomainID,
			PolicyCOIByPostID,
			PolicyNumber,
			CreateDateTime,
			UpdateDateTime,
			Postcode,
			AddressLine1,
			AddressLine2,
			Suburb,
			[State],
			CountryName,
			CountryCode,
			Comments,
			UpdateDateTimeUTC,
			CreateDateTimeUTC
        from
            etl_penPolicyCOIByPost

    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPolicyCOIByPost
            
        exec syssp_genericerrorhandler 'penPolicyCOIByPost data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPolicyCOIByPost

end

GO
