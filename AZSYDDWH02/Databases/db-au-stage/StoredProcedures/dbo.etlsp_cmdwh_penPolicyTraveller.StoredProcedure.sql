USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyTraveller]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penPolicyTraveller]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120127
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    Policy Traveller table contains both traveller attributes.
                This transformation adds essential key fields
Change History:
                20120127 - LT - Procedure created
                20120323 - LT - Fixed duplication bug due to PolicyTraveller record not being deleted for each ETL
                20121108 - LS - refactoring & domain related changes
                20130408 - LS - Case 18432, EMC info
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20131204 - LS - case 19524, index optimisation for new pricing calculation
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
                20150808 - LS - TFS 15452, add Gender, ID & MemberRewardPointsEarned
				20151027 - DM - Penguin v16 Release, add column StateOfArrival
				20160321 - LT - Penguin 18.0, added US penguin instance
                20161021 - LS - MemberTypeId
				20170125 - LT - Added TicketType column (TicketType nvarchar(50) NULL)
				20180219 - SD - Added VelocityNumber column (VelocityNumber nvarchar(50) NULL)
                20180918 - LL - CBA: keep history of removed travellers (not on day 1 go live, but .. keeping it here nonetheless)

*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penPolicyTraveller') is not null
        drop table etl_penPolicyTraveller

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, pt.ID) PolicyTravellerKey,
        PrefixKey + convert(varchar, pt.PolicyID) PolicyKey,
        PrefixKey + convert(varchar, pt.QuoteCustomerID) QuoteCustomerKey,
        DomainID,
        pt.ID as PolicyTravellerID,
        pt.PolicyID,
        pt.QuoteCustomerID,
        pt.Title,
        pt.FirstName,
        pt.LastName,
        dbo.xfn_ConvertUTCtoLocal(pt.DOB, TimeZone) DOB,
        pt.Age,
        pt.isAdult,
        pt.AdultCharge,
        pt.isPrimary,
        pt.AddressLine1,
        pt.AddressLine2,
        pt.PostCode,
        pt.Suburb,
        pt.State,
        pt.Country,
        pt.HomePhone,
        pt.WorkPhone,
        pt.MobilePhone,
        pt.EmailAddress,
        pt.OptFurtherContact,
        pt.MemberNumber,
        pe.EMCRef,
        pe.EMCScore,
        pe.DisplayName,
        pe.AssessmentType,
        pt.EmcCoverLimit,
        pt.MarketingConsent,
        pt.Gender,
        pid.PIDType,
        pid.PIDCode,
        pt.PersonalIdentifierValue PIDValue,
		pt.StateOfArrival,
        pt.MemberTypeId,
		pt.TicketType,
		pt.VelocityNumber
    into etl_penPolicyTraveller
    from
        penguin_tblPolicyTraveller_aucm pt
        cross apply dbo.fn_GetPolicyDomainKeys(pt.PolicyID, null, null, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                pe.EMCRef,
                pe.EMCScore,
                a.DisplayName,
                case
                    when pe.EMCRef = 'Not Applicable' or pe.EMCRef is null then 'Self Assessed'
                    else 'Assessed'
                end AssessmentType
            from
                penguin_tblPolicyTravellerTransaction_aucm ptt
                inner join penguin_tblPolicyEMC_aucm pe on
                    pe.PolicyTravellerTransactionID = ptt.ID
                inner join penguin_tblAddOn_aucm a on
                    a.AddOnId = pe.AddOnID
            where
                ptt.PolicyTravellerID = pt.ID
        ) pe
        outer apply
        (
            select top 1
                pid.Type PIDType,
                pid.Code PIDCode
            from
                penguin_tblPersonalIdentifier_aucm pid
            where
                pid.ID = pt.PersonalIdentifierID
        ) pid

 


    if object_id('[db-au-cba].dbo.penPolicyTraveller') is null
    begin

        create table [db-au-cba].dbo.[penPolicyTraveller]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyTravellerKey] varchar(41) null,
            [PolicyKey] varchar(41) null,
            [QuoteCustomerKey] varchar(41) null,
            [PolicyTravellerID] int not null,
            [PolicyID] int not null,
            [QuoteCustomerID] int not null,
            [Title] nvarchar(50) null,
            [FirstName] nvarchar(100) null,
            [LastName] nvarchar(100) null,
            [DOB] datetime null,
            [Age] int null,
            [isAdult] bit null,
            [AdultCharge] numeric(18,5) null,
            [isPrimary] bit null,
            [AddressLine1] nvarchar(100) null,
            [AddressLine2] nvarchar(100) null,
            [PostCode] nvarchar(50) null,
            [Suburb] nvarchar(50) null,
            [State] nvarchar(100) null,
            [Country] nvarchar(100) null,
            [HomePhone] varchar(50) null,
            [WorkPhone] varchar(50) null,
            [MobilePhone] varchar(50) null,
            [EmailAddress] nvarchar(255) null,
            [OptFurtherContact] bit null,
            [MemberNumber] nvarchar(25) null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [EMCRef] varchar(100) null,
            [EMCScore] numeric(10,4) null,
            [DisplayName] nvarchar(100) null,
            [AssessmentType] varchar(20) null,
            [EmcCoverLimit] numeric(18,2) null,
            [MarketingConsent] bit null,
            [Gender] nchar(2) null,
            [PIDType] nvarchar(100),
            [PIDCode] nvarchar(50),
            [PIDValue] nvarchar(256),
            [MemberRewardPointsEarned] money null,
			[StateOfArrival] varchar(100) null,
            [MemberTypeID] int null,
			[TicketType] nvarchar(50) null,
			[VelocityNumber] nvarchar(50) null
        )

        create clustered index idx_penPolicyTraveller_PolicyKey on [db-au-cba].dbo.penPolicyTraveller(PolicyKey)
        create nonclustered index idx_penPolicyTraveller_EMCRef on [db-au-cba].dbo.penPolicyTraveller(EMCRef)
        create nonclustered index idx_penPolicyTraveller_MemberNumber on [db-au-cba].dbo.penPolicyTraveller(MemberNumber,PolicyTravellerID) include (PolicyKey)
        create nonclustered index idx_penPolicyTraveller_Names on [db-au-cba].dbo.penPolicyTraveller(FirstName,LastName,DOB,PolicyTravellerID) include (CountryKey,PolicyKey)
        create nonclustered index idx_penPolicyTraveller_PolicyKeyTraveller on [db-au-cba].dbo.penPolicyTraveller(PolicyKey,isPrimary) include (PolicyTravellerKey,FirstName,LastName,DOB,MemberNumber,PolicyTravellerID,State,AddressLine1,Suburb)
        create nonclustered index idx_penPolicyTraveller_PolicyTravellerKey on [db-au-cba].dbo.penPolicyTraveller(PolicyTravellerKey)

    end

    if object_id('[db-au-cba].dbo.penPolicyTraveller_History') is null
    begin

        create table [db-au-cba].dbo.[penPolicyTraveller_History]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyTravellerKey] varchar(41) null,
            [PolicyKey] varchar(41) null,
            [QuoteCustomerKey] varchar(41) null,
            [PolicyTravellerID] int not null,
            [PolicyID] int not null,
            [QuoteCustomerID] int not null,
            [Title] nvarchar(50) null,
            [FirstName] nvarchar(100) null,
            [LastName] nvarchar(100) null,
            [DOB] datetime null,
            [Age] int null,
            [isAdult] bit null,
            [AdultCharge] numeric(18,5) null,
            [isPrimary] bit null,
            [AddressLine1] nvarchar(100) null,
            [AddressLine2] nvarchar(100) null,
            [PostCode] nvarchar(50) null,
            [Suburb] nvarchar(50) null,
            [State] nvarchar(100) null,
            [Country] nvarchar(100) null,
            [HomePhone] varchar(50) null,
            [WorkPhone] varchar(50) null,
            [MobilePhone] varchar(50) null,
            [EmailAddress] nvarchar(255) null,
            [OptFurtherContact] bit null,
            [MemberNumber] nvarchar(25) null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [EMCRef] varchar(100) null,
            [EMCScore] numeric(10,4) null,
            [DisplayName] nvarchar(100) null,
            [AssessmentType] varchar(20) null,
            [EmcCoverLimit] numeric(18,2) null,
            [MarketingConsent] bit null,
            [Gender] nchar(2) null,
            [PIDType] nvarchar(100),
            [PIDCode] nvarchar(50),
            [PIDValue] nvarchar(256),
            [MemberRewardPointsEarned] money null,
			[StateOfArrival] varchar(100) null,
            [MemberTypeID] int null,
			[TicketType] nvarchar(50) null,
			[VelocityNumber] nvarchar(50) null,
            [RemovedDate] date null
        )

        create clustered index idx_penPolicyTraveller_PolicyTravellerKey on [db-au-cba].dbo.penPolicyTraveller_History(PolicyTravellerKey)
        create nonclustered index idx_penPolicyTraveller_PolicyKey on [db-au-cba].dbo.penPolicyTraveller_History(PolicyKey)

    end

    begin transaction penPolicyTraveller

    begin try

        --keep history of removed travellers
        insert [db-au-cba].dbo.penPolicyTraveller_History
        (
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTravellerKey,
            PolicyKey,
            QuoteCustomerKey,
            DomainID,
            PolicyTravellerID,
            PolicyID,
            QuoteCustomerID,
            Title,
            FirstName,
            LastName,
            DOB,
            Age,
            isAdult,
            AdultCharge,
            isPrimary,
            AddressLine1,
            AddressLine2,
            PostCode ,
            Suburb,
            State,
            Country,
            HomePhone,
            WorkPhone,
            MobilePhone,
            EmailAddress,
            OptFurtherContact,
            MemberNumber,
            EMCRef,
            EMCScore,
            DisplayName,
            AssessmentType,
            EmcCoverLimit,
            MarketingConsent,
            Gender,
            PIDType,
            PIDCode,
            PIDValue,
			StateOfArrival,
            MemberTypeId,
			TicketType,
			VelocityNumber,
            RemovedDate
        )
        select
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTravellerKey,
            PolicyKey,
            QuoteCustomerKey,
            DomainID,
            PolicyTravellerID,
            PolicyID,
            QuoteCustomerID,
            Title,
            FirstName,
            LastName,
            DOB,
            Age,
            isAdult,
            AdultCharge,
            isPrimary,
            AddressLine1,
            AddressLine2,
            PostCode ,
            Suburb,
            State,
            Country,
            HomePhone,
            WorkPhone,
            MobilePhone,
            EmailAddress,
            OptFurtherContact,
            MemberNumber,
            EMCRef,
            EMCScore,
            DisplayName,
            AssessmentType,
            EmcCoverLimit,
            MarketingConsent,
            Gender,
            PIDType,
            PIDCode,
            PIDValue,
			StateOfArrival,
            MemberTypeId,
			TicketType,
			VelocityNumber,
            getdate()
        from
            [db-au-cba].dbo.penPolicyTraveller
        where
            PolicyKey in
            (
                select 
                    PolicyKey
                from
                    etl_penPolicyTraveller
            ) and
            PolicyTravellerKey not in
            (
                select 
                    PolicyTravellerKey
                from
                    etl_penPolicyTraveller
            )


        delete a
        from
            [db-au-cba].dbo.penPolicyTraveller a
        where
            PolicyKey in
            (
                select 
                    PolicyKey
                from
                    etl_penPolicyTraveller
            )
        

        insert [db-au-cba].dbo.penPolicyTraveller with(tablockx)
        (
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTravellerKey,
            PolicyKey,
            QuoteCustomerKey,
            DomainID,
            PolicyTravellerID,
            PolicyID,
            QuoteCustomerID,
            Title,
            FirstName,
            LastName,
            DOB,
            Age,
            isAdult,
            AdultCharge,
            isPrimary,
            AddressLine1,
            AddressLine2,
            PostCode ,
            Suburb,
            State,
            Country,
            HomePhone,
            WorkPhone,
            MobilePhone,
            EmailAddress,
            OptFurtherContact,
            MemberNumber,
            EMCRef,
            EMCScore,
            DisplayName,
            AssessmentType,
            EmcCoverLimit,
            MarketingConsent,
            Gender,
            PIDType,
            PIDCode,
            PIDValue,
			StateOfArrival,
            MemberTypeId,
			TicketType,
			VelocityNumber
        )
        select
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTravellerKey,
            PolicyKey,
            QuoteCustomerKey,
            DomainID,
            PolicyTravellerID,
            PolicyID,
            QuoteCustomerID,
            Title,
            FirstName,
            LastName,
            DOB,
            Age,
            isAdult,
            AdultCharge,
            isPrimary,
            AddressLine1,
            AddressLine2,
            PostCode ,
            Suburb,
            State,
            Country,
            HomePhone,
            WorkPhone,
            MobilePhone,
            EmailAddress,
            OptFurtherContact,
            MemberNumber,
            EMCRef,
            EMCScore,
            DisplayName,
            AssessmentType,
            EmcCoverLimit,
            MarketingConsent,
            Gender,
            PIDType,
            PIDCode,
            PIDValue,
			StateOfArrival,
            MemberTypeId,
			TicketType,
			VelocityNumber
        from
            etl_penPolicyTraveller

    end try

    begin catch

        if @@trancount > 0
            rollback transaction penPolicyTraveller

        exec syssp_genericerrorhandler 'penPolicyTraveller data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction penPolicyTraveller

end
GO
