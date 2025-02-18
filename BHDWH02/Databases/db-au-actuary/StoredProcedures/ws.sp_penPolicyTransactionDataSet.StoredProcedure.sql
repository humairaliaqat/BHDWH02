USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_penPolicyTransactionDataSet]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [ws].[sp_penPolicyTransactionDataSet]
as

SET NOCOUNT ON

/****************************************************************************************************/
--  Name:           ws.sp_penPolicyTransactionDataSet
--  Author:         Linus Tor
--  Date Created:   20171023
--	Prerequisite:	[db-au-actuary].[ws].[penPolicy] table exists and populated with data.
--  Description:    This stored procedure inserts [db-au-cmdwh].dbo.penPolicyTransaction data into [db-au-actuary].[ws].[penPolicyTransaction]
--
--  Change History: 20171023 - LT - Created
--                  
/****************************************************************************************************/

--create penPolicyTransaction table and populate with data that exists in [db-au-actuary].ws.penPolicy
if object_id('[db-au-actuary].ws.penPolicyTransaction') is null
begin
	create table [db-au-actuary].ws.penPolicyTransaction
	(
		CountryKey varchar(2) not null,
		CompanyKey varchar(5) not null,
		PolicyTransactionKey varchar(41) not null,
		PolicyKey varchar(41) null,
		PolicyNoKey varchar(100) null,
		UserKey varchar(41) null,
		UserSKey bigint null,
		PolicyTransactionID int not null,
		PolicyID int not null,
		PolicyNumber varchar(50) null,
		TransactionTypeID int not null,
		TransactionType varchar(50) null,
		GrossPremium money not null,
		IssueDate datetime not null,
		AccountingPeriod datetime not null,
		CRMUserID int null,
		CRMUserName nvarchar(100) null,
		TransactionStatusID int not null,
		TransactionStatus nvarchar(50) null,
		Transferred bit not null,
		UserComments nvarchar(1000) null,
		CommissionTier varchar(50) null,
		VolumeCommission numeric(18, 9) null,
		Discount numeric(18, 9) null,
		isExpo bit not null,
		isPriceBeat bit not null,
		NoOfBonusDaysApplied int null,
		isAgentSpecial bit not null,
		ParentID int null,
		ConsultantID int null,
		isClientCall bit null,
		RiskNet money null,
		AutoComments nvarchar(2000) null,
		TripCost varchar(50) null,
		AllocationNumber int null,
		PaymentDate datetime null,
		TransactionStart datetime null,
		TransactionEnd datetime null,
		StoreCode varchar(10) null,
		DomainKey varchar(41) null,
		DomainID int null,
		IssueDateUTC datetime null,
		PaymentDateUTC datetime null,
		TransactionStartUTC datetime null,
		TransactionEndUTC datetime null,
		ImportDate datetime null,
		TransactionDateTime datetime null,
		TotalCommission money null,
		TotalNet money null,
		PaymentMode nvarchar(20) null,
		PointsRedeemed money null,
		RedemptionReference nvarchar(255) null,
		GigyaId nvarchar(300) null,
		IssuingConsultantID int null,
		LeadTimeDate date null,
		MaxAMTDuration int null
	) 
    create clustered index idx_penPolicyTransaction_PolicyKey on [db-au-actuary].ws.penPolicyTransaction(PolicyKey)
    create nonclustered index idx_penPolicyTransaction_IssueDate on [db-au-actuary].ws.penPolicyTransaction(IssueDate)
    create nonclustered index idx_penPolicyTransaction_PaymentDate on [db-au-actuary].ws.penPolicyTransaction(PaymentDate)
    create nonclustered index idx_penPolicyTransaction_PolicyID on [db-au-actuary].ws.penPolicyTransaction(PolicyID)
    create nonclustered index idx_penPolicyTransaction_PolicyNumber on [db-au-actuary].ws.penPolicyTransaction(PolicyNumber)
    create nonclustered index idx_penPolicyTransaction_PolicyTransactionID on [db-au-actuary].ws.penPolicyTransaction(PolicyTransactionID)
    create nonclustered index idx_penPolicyTransaction_PolicyTransactionKey on [db-au-actuary].ws.penPolicyTransaction(PolicyTransactionKey) include (PolicyNumber,PolicyKey,TransactionType)
    create nonclustered index idx_penPolicyTransaction_UserKey on [db-au-actuary].ws.penPolicyTransaction(UserKey)
    create nonclustered index idx_penPolicyTransaction_UserSKey on [db-au-actuary].ws.penPolicyTransaction(UserSKey)
end


--populate policytransaction data
insert into [db-au-actuary].ws.penPolicyTransaction with (tablockx)
(
    CountryKey,
    CompanyKey,
    DomainKey,
    PolicyTransactionKey,
    PolicyKey,
    PolicyNoKey,
    UserKey,
    UserSKey,
    DomainID,
    PolicyTransactionID,
    PolicyID,
    PolicyNumber,
    TransactionTypeID,
    TransactionType,
    GrossPremium,
    IssueDate,
    IssueDateUTC,
    AccountingPeriod,
    CRMUserID,
    CRMUserName,
    TransactionStatusID,
    TransactionStatus,
    Transferred,
    UserComments,
    CommissionTier,
    VolumeCommission,
    Discount,
    isExpo,
    isPriceBeat,
    NoOfBonusDaysApplied,
    isAgentSpecial,
    ParentID,
    ConsultantID,
    isClientCall,
    RiskNet,
    AutoComments,
    TripCost,
    AllocationNumber,
    PaymentDate,
    TransactionStart,
    TransactionEnd,
    PaymentDateUTC,
    TransactionStartUTC,
    TransactionEndUTC,
    StoreCode,
    ImportDate,
    TransactionDateTime,
    TotalCommission,
    TotalNet,
    PaymentMode,
    PointsRedeemed,
    RedemptionReference,
	GigyaId,
    IssuingConsultantID,
    LeadTimeDate
)
select
    CountryKey,
    CompanyKey,
    DomainKey,
    PolicyTransactionKey,
    PolicyKey,
    PolicyNoKey,
    UserKey,
    UserSKey,
    DomainID,
    PolicyTransactionID,
    PolicyID,
    PolicyNumber,
    TransactionTypeID,
    TransactionType,
    GrossPremium,
    IssueDate,
    IssueDateUTC,
    AccountingPeriod,
    CRMUserID,
    CRMUserName,
    TransactionStatusID,
    TransactionStatus,
    Transferred,
    UserComments,
    CommissionTier,
    VolumeCommission,
    Discount,
    isExpo,
    isPriceBeat,
    NoOfBonusDaysApplied,
    isAgentSpecial,
    ParentID,
    ConsultantID,
    isClientCall,
    RiskNet,
    AutoComments,
    TripCost,
    AllocationNumber,
    PaymentDate,
    TransactionStart,
    TransactionEnd,
    PaymentDateUTC,
    TransactionStartUTC,
    TransactionEndUTC,
    StoreCode,
    ImportDate,
    TransactionDateTime,
    TotalCommission,
    TotalNet,
    PaymentMode,
    PointsRedeemed,
    RedemptionReference,
	GigyaId,
    IssuingConsultantID,
    LeadTimeDate
from
    [db-au-cmdwh].dbo.penPolicyTransaction
where
	CountryKey = 'AU' and
	PolicyKey in (select PolicyKey from [db-au-actuary].ws.penPolicy)

GO
