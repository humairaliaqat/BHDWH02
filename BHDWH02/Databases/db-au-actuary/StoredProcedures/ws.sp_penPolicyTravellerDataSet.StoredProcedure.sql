USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_penPolicyTravellerDataSet]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [ws].[sp_penPolicyTravellerDataSet]
as

SET NOCOUNT ON

/****************************************************************************************************/
--  Name:           ws.sp_penPolicyTravellerDataSet
--  Author:         Linus Tor
--  Date Created:   20171023
--	Prerequisite:	[db-au-actuary].[ws].[penPolicy] table exists and populated with data.
--  Description:    This stored procedure inserts [db-au-cmdwh].dbo.penPolicyTraveller data into [db-au-actuary].[ws].[penPolicyTraveller]
--
--  Change History: 20171023 - LT - Created
--                  
/****************************************************************************************************/

--create penPolicyTraveller table and populate with data that exists in [db-au-actuary].ws.penPolicy
if object_id('[db-au-actuary].ws.penPolicyTraveller') is null
begin

    create table [db-au-actuary].ws.[penPolicyTraveller]
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
        [PIDValue] nvarchar(50),
        [MemberRewardPointsEarned] money null,
		[StateOfArrival] varchar(100) null,
        [MemberTypeID] int null,
		[TicketType] nvarchar(50) null
    )

    create clustered index idx_penPolicyTraveller_PolicyKey on [db-au-actuary].ws.penPolicyTraveller(PolicyKey)
    create nonclustered index idx_penPolicyTraveller_EMCRef on [db-au-actuary].ws.penPolicyTraveller(EMCRef)
    create nonclustered index idx_penPolicyTraveller_MemberNumber on [db-au-actuary].ws.penPolicyTraveller(MemberNumber,PolicyTravellerID) include (PolicyKey)
    create nonclustered index idx_penPolicyTraveller_Names on [db-au-actuary].ws.penPolicyTraveller(FirstName,LastName,DOB,PolicyTravellerID) include (CountryKey,PolicyKey)
    create nonclustered index idx_penPolicyTraveller_PolicyKeyTraveller on [db-au-actuary].ws.penPolicyTraveller(PolicyKey,isPrimary) include (PolicyTravellerKey,FirstName,LastName,DOB,MemberNumber,PolicyTravellerID,State,AddressLine1,Suburb)
    create nonclustered index idx_penPolicyTraveller_PolicyTravellerKey on [db-au-actuary].ws.penPolicyTraveller(PolicyTravellerKey)

end

--populate policytraveller data
insert into [db-au-actuary].ws.penPolicyTraveller with (tablockx)
(
    [CountryKey],
    [CompanyKey],
    [PolicyTravellerKey],
    [PolicyKey],
    [QuoteCustomerKey],
    [PolicyTravellerID],
    [PolicyID],
    [QuoteCustomerID],
    [Title],
    [FirstName],
    [LastName],
    [DOB],
    [Age],
    [isAdult],
    [AdultCharge],
    [isPrimary],
    [AddressLine1],
    [AddressLine2],
    [PostCode],
    [Suburb],
    [State],
    [Country],
    [HomePhone],
    [WorkPhone],
    [MobilePhone],
    [EmailAddress],
    [OptFurtherContact],
    [MemberNumber],
    [DomainKey],
    [DomainID],
    [EMCRef],
    [EMCScore],
    [DisplayName],
    [AssessmentType],
    [EmcCoverLimit],
    [MarketingConsent],
    [Gender],
    [PIDType],
    [PIDCode],
    [PIDValue],
    [MemberRewardPointsEarned],
	[StateOfArrival],
    [MemberTypeID],
	[TicketType]
)
select
    [CountryKey],
    [CompanyKey],
    [PolicyTravellerKey],
    [PolicyKey],
    [QuoteCustomerKey],
    [PolicyTravellerID],
    [PolicyID],
    [QuoteCustomerID],
    [Title],
    [FirstName],
    [LastName],
    [DOB],
    [Age],
    [isAdult],
    [AdultCharge],
    [isPrimary],
    [AddressLine1],
    [AddressLine2],
    [PostCode],
    [Suburb],
    [State],
    [Country],
    [HomePhone],
    [WorkPhone],
    [MobilePhone],
    [EmailAddress],
    [OptFurtherContact],
    [MemberNumber],
    [DomainKey],
    [DomainID],
    [EMCRef],
    [EMCScore],
    [DisplayName],
    [AssessmentType],
    [EmcCoverLimit],
    [MarketingConsent],
    [Gender],
    [PIDType],
    [PIDCode],
    [PIDValue],
    [MemberRewardPointsEarned],
	[StateOfArrival],
    [MemberTypeID],
	[TicketType]
from
    [db-au-cmdwh].dbo.penPolicyTraveller
where
	CountryKey = 'AU' and
	PolicyKey in (select PolicyKey from [db-au-actuary].ws.penPolicy)
GO
