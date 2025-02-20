USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penAuditPenguin]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[etlsp_cmdwh_penAuditPenguin]
AS
BEGIN
  /*
  20190812 - RS - Initial version
  */

  --set nocount on


  /*************************************Start of AUDIT_tblPolicy*************************************/
  IF OBJECT_ID('etl_penAUDIT_Policy') IS NOT NULL
    DROP TABLE etl_penAUDIT_Policy

  SELECT
    CountryKey,
    CompanyKey,
    DomainKey,
    PrefixKey + CONVERT(varchar, a.[AUDIT_PolicyID]) AuditPolicyKey,
    a.[AUDIT_USERNAME],
    a.[AUDIT_RECORDTYPE],
    dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime,
	a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC,
    a.[AUDIT_PolicyID],
    a.[PolicyID],
    a.[PolicyNumber],
    a.[QuotePlanID],
    a.[AlphaCode],
    a.[IssueDate],
    a.[CancelledDate],
    a.[PolicyStatus],
    a.[Area],
    a.[PrimaryCountry],
    a.[TripStart],
    a.[TripEnd],
    a.[AffiliateReference],
    a.[HowDidYouHear],
    a.[AffiliateComments],
    a.[GroupName],
    a.[CompanyName],
    a.[IsCancellation],
    a.[ExternalReference],
    a.[DomainId],
    a.[CurrencyCode],
    a.[PreviousPolicyNumber],
    a.[CultureCode],
    a.[AreaCode],
    a.[InitialDepositDate] 
  INTO etl_penAUDIT_Policy
  FROM [db-au-stage].[dbo].[penguin_AUDIT_tblPolicy_aucm] a
  CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk;
  
  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_Policy') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_Policy] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPolicyKey] varchar(41) NULL,
      [AUDIT_USERNAME] [varchar](255) NULL,
      [AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
      [AUDIT_PolicyID] [int] NOT NULL,
      [PolicyID] [int] NOT NULL,
      [PolicyNumber] [varchar](25) NULL,
      [QuotePlanID] [int] NOT NULL,
      [AlphaCode] [nvarchar](60) NULL,
      [IssueDate] [datetime] NOT NULL,
      [CancelledDate] [datetime] NULL,
      [PolicyStatus] [int] NULL,
      [Area] [nvarchar](100) NULL,
      [PrimaryCountry] [nvarchar](MAX) NULL,
      [TripStart] [datetime] NULL,
      [TripEnd] [datetime] NULL,
      [AffiliateReference] [nvarchar](200) NULL,
      [HowDidYouHear] [nvarchar](200) NULL,
      [AffiliateComments] [varchar](500) NULL,
      [GroupName] [nvarchar](100) NULL,
      [CompanyName] [nvarchar](100) NULL,
      [IsCancellation] [bit] NULL,
      [ExternalReference] [nvarchar](75) NULL,
      [DomainId] [int] NOT NULL,
      [CurrencyCode] [varchar](3) NOT NULL,
      [PreviousPolicyNumber] [varchar](25) NULL,
      [CultureCode] [nvarchar](20) NULL,
      [AreaCode] [nvarchar](3) NULL,
      [InitialDepositDate] [datetime] NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_Policy_AuditPolicyKey ON [db-au-cba].dbo.penAudit_Policy (AuditPolicyKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_Policy a
      INNER JOIN etl_penAUDIT_Policy b
        ON a.AuditPolicyKey = b.AuditPolicyKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_Policy WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPolicyKey]
  , [AUDIT_USERNAME]
  , [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
  , [AUDIT_PolicyID]
  , [PolicyID]
  , [PolicyNumber]
  , [QuotePlanID]
  , [AlphaCode]
  , [IssueDate]
  , [CancelledDate]
  , [PolicyStatus]
  , [Area]
  , [PrimaryCountry]
  , [TripStart]
  , [TripEnd]
  , [AffiliateReference]
  , [HowDidYouHear]
  , [AffiliateComments]
  , [GroupName]
  , [CompanyName]
  , [IsCancellation]
  , [ExternalReference]
  , [DomainId]
  , [CurrencyCode]
  , [PreviousPolicyNumber]
  , [CultureCode]
  , [AreaCode]
  , [InitialDepositDate])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPolicyKey],
      [AUDIT_USERNAME],
      [AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
      [AUDIT_PolicyID],
      [PolicyID],
      [PolicyNumber],
      [QuotePlanID],
      [AlphaCode],
      [IssueDate],
      [CancelledDate],
      [PolicyStatus],
      [Area],
      [PrimaryCountry],
      [TripStart],
      [TripEnd],
      [AffiliateReference],
      [HowDidYouHear],
      [AffiliateComments],
      [GroupName],
      [CompanyName],
      [IsCancellation],
      [ExternalReference],
      [DomainId],
      [CurrencyCode],
      [PreviousPolicyNumber],
      [CultureCode],
      [AreaCode],
      [InitialDepositDate]
    FROM etl_penAUDIT_Policy
	/*************************************End of AUDIT_tblPolicy*************************************/


	  /*************************************Start of AUDIT_tblPolicyDetails*************************************/
  IF OBJECT_ID('etl_penAUDIT_PolicyDetails') IS NOT NULL
    DROP TABLE etl_penAUDIT_PolicyDetails

  SELECT
       CountryKey
      ,CompanyKey
      ,DomainKey
      ,PrefixKey + CONVERT(varchar, a.[AUDIT_tblPolicyDetails_ID]) AuditPolicyDetailsKey
      ,[AUDIT_USERNAME]
      ,[AUDIT_RECORDTYPE]
      ,dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime
	  ,a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC
      ,[ID]
      ,[AUDIT_tblPolicyDetails_ID]
      ,[PolicyID]
      ,[ProductID]
      ,[UniquePlanID]
      ,[Excess]
      ,[AreaName]
      ,[PolicyStart]
      ,[PolicyEnd]
      ,[DaysCovered]
      ,[MaxDuration]
      ,[PlanName]
      ,[PlanType]
      ,[PlanID]
      ,[TripDuration]
      ,[EmailConsent]
      ,[ShowDiscount]
      ,[AreaCode]
      ,[IsUnbundled]
  INTO etl_penAUDIT_PolicyDetails
  FROM [db-au-stage].[dbo].[penguin_AUDIT_tblPolicyDetails_aucm] a
  --CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk
  CROSS APPLY dbo.fn_GetDomainKeys(7, 'CM', 'AU') dk;
  

  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_PolicyDetails') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_PolicyDetails] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPolicyDetailsKey] varchar(41) NULL,
      [AUDIT_USERNAME] [varchar](255) NULL,
      [AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
        [ID] [int] NOT NULL,
		[AUDIT_tblPolicyDetails_ID] [int] NOT NULL,
		[PolicyID] [int] NOT NULL,
		[ProductID] [int] NOT NULL,
		[UniquePlanID] [int] NOT NULL,
		[Excess] [money] NOT NULL,
		[AreaName] [nvarchar](100) NULL,
		[PolicyStart] [datetime] NOT NULL,
		[PolicyEnd] [datetime] NOT NULL,
		[DaysCovered] [int] NULL,
		[MaxDuration] [int] NULL,
		[PlanName] [nvarchar](50) NULL,
		[PlanType] [nvarchar](50) NULL,
		[PlanID] [int] NULL,
		[TripDuration] [int] NULL,
		[EmailConsent] [bit] NULL,
		[ShowDiscount] [bit] NULL,
		[AreaCode] [nvarchar](3) NULL,
		[IsUnbundled] [bit] NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_PolicyDetails_AuditPolicyDetailsKey ON [db-au-cba].dbo.penAudit_PolicyDetails(AuditPolicyDetailsKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_PolicyDetails a
      INNER JOIN etl_penAUDIT_PolicyDetails b
        ON a.AuditPolicyDetailsKey = b.AuditPolicyDetailsKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_PolicyDetails WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPolicyDetailsKey]
  , [AUDIT_USERNAME]
  , [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
    , [ID],
	[AUDIT_tblPolicyDetails_ID],
	[PolicyID],
	[ProductID],
	[UniquePlanID],
	[Excess],
	[AreaName],
	[PolicyStart],
	[PolicyEnd],
	[DaysCovered],
	[MaxDuration],
	[PlanName],
	[PlanType],
	[PlanID],
	[TripDuration],
	[EmailConsent],
	[ShowDiscount],
	[AreaCode],
	[IsUnbundled])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPolicyDetailsKey],
      [AUDIT_USERNAME],
      [AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
    [ID],
	[AUDIT_tblPolicyDetails_ID],
	[PolicyID],
	[ProductID],
	[UniquePlanID],
	[Excess],
	[AreaName],
	[PolicyStart],
	[PolicyEnd],
	[DaysCovered],
	[MaxDuration],
	[PlanName],
	[PlanType],
	[PlanID],
	[TripDuration],
	[EmailConsent],
	[ShowDiscount],
	[AreaCode],
	[IsUnbundled]
    FROM etl_penAUDIT_PolicyDetails
	/*************************************End of AUDIT_tblPolicyDetails*************************************/
	

	
	  /*************************************Start of AUDIT_tblPolicyPrice*************************************/
  IF OBJECT_ID('etl_penAUDIT_PolicyPrice') IS NOT NULL
    DROP TABLE etl_penAUDIT_PolicyPrice

  SELECT
       CountryKey
      ,CompanyKey
      ,DomainKey
      ,PrefixKey + CONVERT(varchar, a.[AUDIT_tblPolicyPrice_ID]) AuditPolicyPriceKey
      ,[AUDIT_USERNAME]
      ,[AUDIT_RECORDTYPE]
      ,dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime
	  ,a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC
      ,[AUDIT_tblPolicyPrice_ID]
      ,[ID]
      ,[GroupID]
      ,[ComponentID]
      ,[GrossPremium]
      ,[BasePremium]
      ,[AdjustedNet]
      ,[Commission]
      ,[CommissionRate]
      ,[Discount]
      ,[DiscountRate]
      ,[BaseAdminFee]
      ,[GrossAdminFee]
      ,[IsPOSDiscount]
  INTO etl_penAUDIT_PolicyPrice
  FROM [db-au-stage].[dbo].[penguin_AUDIT_tblPolicyPrice_aucm] a
  --CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk
  CROSS APPLY dbo.fn_GetDomainKeys(7, 'CM', 'AU') dk;
 


  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_PolicyPrice') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_PolicyPrice] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPolicyPriceKey] varchar(41) NULL,
      [AUDIT_USERNAME] [varchar](255) NULL,
      [AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
    [AUDIT_tblPolicyPrice_ID] [int] NOT NULL,
	[ID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[GrossPremium] [money] NULL,
	[BasePremium] [money] NOT NULL,
	[AdjustedNet] [money] NOT NULL,
	[Commission] [money] NOT NULL,
	[CommissionRate] [numeric](10, 9) NULL,
	[Discount] [money] NOT NULL,
	[DiscountRate] [numeric](12, 9) NULL,
	[BaseAdminFee] [money] NULL,
	[GrossAdminFee] [money] NULL,
	[IsPOSDiscount] [bit] NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_PolicyPrice_AuditPolicyPriceKey ON [db-au-cba].dbo.penAudit_PolicyPrice(AuditPolicyPriceKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_PolicyPrice a
      INNER JOIN etl_penAUDIT_PolicyPrice b
        ON a.AuditPolicyPriceKey = b.AuditPolicyPriceKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_PolicyPrice WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPolicyPriceKey]
  , [AUDIT_USERNAME]
  , [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
    ,[AUDIT_tblPolicyPrice_ID]
      ,[ID]
      ,[GroupID]
      ,[ComponentID]
      ,[GrossPremium]
      ,[BasePremium]
      ,[AdjustedNet]
      ,[Commission]
      ,[CommissionRate]
      ,[Discount]
      ,[DiscountRate]
      ,[BaseAdminFee]
      ,[GrossAdminFee]
      ,[IsPOSDiscount])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPolicyPriceKey],
      [AUDIT_USERNAME],
      [AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
       [AUDIT_tblPolicyPrice_ID]
      ,[ID]
      ,[GroupID]
      ,[ComponentID]
      ,[GrossPremium]
      ,[BasePremium]
      ,[AdjustedNet]
      ,[Commission]
      ,[CommissionRate]
      ,[Discount]
      ,[DiscountRate]
      ,[BaseAdminFee]
      ,[GrossAdminFee]
      ,[IsPOSDiscount]
    FROM etl_penAUDIT_PolicyPrice
	/*************************************End of AUDIT_tblPolicyPrice*************************************/
	

	
	
	  /*************************************Start of AUDIT_tblPolicyTax*************************************/
  IF OBJECT_ID('etl_penAUDIT_PolicyTax') IS NOT NULL
    DROP TABLE etl_penAUDIT_PolicyTax

  SELECT
       CountryKey
      ,CompanyKey
      ,DomainKey
      ,PrefixKey + CONVERT(varchar, a.[AUDIT_tblPolicyTax_ID]) AuditPolicyTaxKey
      ,[AUDIT_USERNAME]
      ,[AUDIT_RECORDTYPE]
      ,dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime
	  ,a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC
     ,[AUDIT_tblPolicyTax_ID]
      ,[ID]
      ,[PolicyTravellerTransactionID]
      ,[TaxID]
      ,[TaxAmount]
      ,[TaxOnAgentComm]
      ,[IsPOSDiscount]
  INTO etl_penAUDIT_PolicyTax
  FROM [db-au-stage].[dbo].[penguin_AUDIT_tblPolicyTax_aucm] a
  --CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk
  CROSS APPLY dbo.fn_GetDomainKeys(7, 'CM', 'AU') dk;  


  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_PolicyTax') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_PolicyTax] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPolicyTaxKey] varchar(41) NULL,
      [AUDIT_USERNAME] [varchar](255) NULL,
      [AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
    [AUDIT_tblPolicyTax_ID] [int] NOT NULL,
	[ID] [int] NULL,
	[PolicyTravellerTransactionID] [int] NOT NULL,
	[TaxID] [int] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[TaxOnAgentComm] [money] NOT NULL,
	[IsPOSDiscount] [bit] NOT NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_PolicyTax_AuditPolicyTaxKey ON [db-au-cba].dbo.penAudit_PolicyTax(AuditPolicyTaxKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_PolicyTax a
      INNER JOIN etl_penAUDIT_PolicyTax b
        ON a.AuditPolicyTaxKey = b.AuditPolicyTaxKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_PolicyTax WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPolicyTaxKey]
  , [AUDIT_USERNAME]
  , [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
   ,[AUDIT_tblPolicyTax_ID]
      ,[ID]
      ,[PolicyTravellerTransactionID]
      ,[TaxID]
      ,[TaxAmount]
      ,[TaxOnAgentComm]
      ,[IsPOSDiscount])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPolicyTaxKey],
      [AUDIT_USERNAME],
      [AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
      [AUDIT_tblPolicyTax_ID]
      ,[ID]
      ,[PolicyTravellerTransactionID]
      ,[TaxID]
      ,[TaxAmount]
      ,[TaxOnAgentComm]
      ,[IsPOSDiscount]
    FROM etl_penAUDIT_PolicyTax
	/*************************************End of AUDIT_tblPolicyTax*************************************/
	
	
	
	  /*************************************Start of AUDIT_tblPolicyTransaction*************************************/
  IF OBJECT_ID('etl_penAUDIT_PolicyTransaction') IS NOT NULL
    DROP TABLE etl_penAUDIT_PolicyTransaction

  SELECT
       CountryKey
      ,CompanyKey
      ,DomainKey
      ,PrefixKey + CONVERT(varchar, a.[AUDIT_tblPolicyTransaction_ID]) AuditPolicyTransactionKey
      ,[AUDIT_USERNAME]
      ,[AUDIT_RECORDTYPE]
      ,dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime
	  ,a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC
     ,[AUDIT_tblPolicyTransaction_ID]
      ,[ID]
      ,[PolicyID]
      ,[TripsPolicyNumber]
      ,[TransactionType]
      ,[GrossPremium]
      ,[IssueDate]
      ,[AccountingPeriod]
      ,[CRMUserID]
      ,[TransactionStatus]
      ,[Transferred]
      ,[UserComments]
      ,[CommissionTier]
      ,[VolumeCommission]
      ,[Discount]
      ,[IsExpo]
      ,[IsPriceBeat]
      ,[NoOfBonusDaysApplied]
      ,[IsAgentSpecial]
      ,[ParentID]
      ,[ConsultantID]
      ,[IsClientCall]
      ,[RiskNet]
      ,[AutoComments]
      ,[TripCost]
      ,[AllocationNumber]
      ,[PaymentDate]
      ,[TransactionStart]
      ,[TransactionEnd]
      ,[StoreCode]
      ,[TotalCommission]
      ,[TotalNet]
      ,[TransactionDateTime]
      ,[PaymentMode]
      ,[IssuingConsultantId]
      ,[GigyaId]
      ,[LeadTimeDate]
      ,[RefundTransactionId]
  INTO etl_penAUDIT_PolicyTransaction
  FROM [db-au-stage].[dbo].[penguin_AUDIT_tblPolicyTransaction_aucm] a
  --CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk
  CROSS APPLY dbo.fn_GetDomainKeys(7, 'CM', 'AU') dk


  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_PolicyTransaction') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_PolicyTransaction] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPolicyTransactionKey] varchar(41) NULL,
      [AUDIT_USERNAME] [varchar](255) NULL,
      [AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
   [AUDIT_tblPolicyTransaction_ID] [int] NOT NULL,
	[ID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[TripsPolicyNumber] [varchar](25) NULL,
	[TransactionType] [int] NOT NULL,
	[GrossPremium] [money] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[AccountingPeriod] [datetime] NOT NULL,
	[CRMUserID] [int] NULL,
	[TransactionStatus] [int] NOT NULL,
	[Transferred] [bit] NOT NULL,
	[UserComments] [nvarchar](1000) NULL,
	[CommissionTier] [varchar](50) NULL,
	[VolumeCommission] [numeric](18, 9) NULL,
	[Discount] [numeric](18, 9) NULL,
	[IsExpo] [bit] NOT NULL,
	[IsPriceBeat] [bit] NOT NULL,
	[NoOfBonusDaysApplied] [int] NULL,
	[IsAgentSpecial] [bit] NOT NULL,
	[ParentID] [int] NULL,
	[ConsultantID] [int] NULL,
	[IsClientCall] [bit] NULL,
	[RiskNet] [money] NULL,
	[AutoComments] [nvarchar](2000) NULL,
	[TripCost] [nvarchar](50) NULL,
	[AllocationNumber] [int] NULL,
	[PaymentDate] [datetime] NULL,
	[TransactionStart] [datetime] NULL,
	[TransactionEnd] [datetime] NULL,
	[StoreCode] [varchar](10) NULL,
	[TotalCommission] [money] NULL,
	[TotalNet] [money] NULL,
	[TransactionDateTime] [datetime] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[IssuingConsultantId] [int] NOT NULL,
	[GigyaId] [nvarchar](300) NULL,
	[LeadTimeDate] [date] NOT NULL,
	[RefundTransactionId] [int] NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_PolicyTransaction_AuditPolicyTransactionKey ON [db-au-cba].dbo.penAudit_PolicyTransaction(AuditPolicyTransactionKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_PolicyTransaction a
      INNER JOIN etl_penAUDIT_PolicyTransaction b
        ON a.AuditPolicyTransactionKey = b.AuditPolicyTransactionKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_PolicyTransaction WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPolicyTransactionKey]
  , [AUDIT_USERNAME]
  , [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
   ,[AUDIT_tblPolicyTransaction_ID]
      ,[ID]
      ,[PolicyID]
      ,[TripsPolicyNumber]
      ,[TransactionType]
      ,[GrossPremium]
      ,[IssueDate]
      ,[AccountingPeriod]
      ,[CRMUserID]
      ,[TransactionStatus]
      ,[Transferred]
      ,[UserComments]
      ,[CommissionTier]
      ,[VolumeCommission]
      ,[Discount]
      ,[IsExpo]
      ,[IsPriceBeat]
      ,[NoOfBonusDaysApplied]
      ,[IsAgentSpecial]
      ,[ParentID]
      ,[ConsultantID]
      ,[IsClientCall]
      ,[RiskNet]
      ,[AutoComments]
      ,[TripCost]
      ,[AllocationNumber]
      ,[PaymentDate]
      ,[TransactionStart]
      ,[TransactionEnd]
      ,[StoreCode]
      ,[TotalCommission]
      ,[TotalNet]
      ,[TransactionDateTime]
      ,[PaymentMode]
      ,[IssuingConsultantId]
      ,[GigyaId]
      ,[LeadTimeDate]
      ,[RefundTransactionId])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPolicyTransactionKey],
      [AUDIT_USERNAME],
      [AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
      [AUDIT_tblPolicyTransaction_ID]
      ,[ID]
      ,[PolicyID]
      ,[TripsPolicyNumber]
      ,[TransactionType]
      ,[GrossPremium]
      ,[IssueDate]
      ,[AccountingPeriod]
      ,[CRMUserID]
      ,[TransactionStatus]
      ,[Transferred]
      ,[UserComments]
      ,[CommissionTier]
      ,[VolumeCommission]
      ,[Discount]
      ,[IsExpo]
      ,[IsPriceBeat]
      ,[NoOfBonusDaysApplied]
      ,[IsAgentSpecial]
      ,[ParentID]
      ,[ConsultantID]
      ,[IsClientCall]
      ,[RiskNet]
      ,[AutoComments]
      ,[TripCost]
      ,[AllocationNumber]
      ,[PaymentDate]
      ,[TransactionStart]
      ,[TransactionEnd]
      ,[StoreCode]
      ,[TotalCommission]
      ,[TotalNet]
      ,[TransactionDateTime]
      ,[PaymentMode]
      ,[IssuingConsultantId]
      ,[GigyaId]
      ,[LeadTimeDate]
      ,[RefundTransactionId]
    FROM etl_penAUDIT_PolicyTransaction
	/*************************************End of AUDIT_tblPolicyTransaction*************************************/

	
	
	
	  /*************************************Start of tblpayment_audit*************************************/
  IF OBJECT_ID('etl_penAUDIT_payment') IS NOT NULL
    DROP TABLE etl_penAUDIT_payment

  SELECT
       CountryKey
      ,CompanyKey
      ,DomainKey
      ,PrefixKey + CONVERT(varchar, a.[PAYUNIQUE_ID]) AuditPaymentKey
      ,[AUDIT_USER]
      --,[AUDIT_RECORDTYPE]
      ,dbo.xfn_ConvertUTCtoLocal(a.[AUDIT_DATETIME],TimeZone) as Audit_DateTime
	  ,a.[AUDIT_DATETIME] as AUDIT_DATETIME_UTC
      ,[PAYUNIQUE_ID]
      ,[PaymentId]
      ,[PolicyTransactionId]
      ,[PAYMENTREF_ID]
      ,[ORDERID]
      ,[STATUS]
      ,[TOTAL]
      ,[CLIENTID]
      ,[TTIME]
      ,[MerchantID]
      ,[ReceiptNo]
      ,[ResponseDescription]
      ,[ACQResponseCode]
      ,[TransactionNo]
      ,[AuthoriseID]
      ,[CardType]
      ,[BatchNo]
      ,[TxnResponseCode]
      ,[PaymentGatewayID]
      ,[PaymentMerchantID]
      ,[CreateDateTime]
      ,[UpdateDateTime]
      ,[Source]
      --,[AUDIT_DATETIME]
      ,[AUDIT_ACTION]
      --,[AUDIT_USER]
      ,[PaymentChannel]
  INTO etl_penAUDIT_payment
  FROM [db-au-stage].[dbo].[penguin_tblPayment_Audit_aucm] a
  --CROSS APPLY dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk
  CROSS APPLY dbo.fn_GetDomainKeys(7, 'CM', 'AU') dk


  IF OBJECT_ID('[db-au-cba].dbo.penAUDIT_payment') IS NULL
  BEGIN

    CREATE TABLE [db-au-cba].dbo.[penAUDIT_payment] (
      [CountryKey] varchar(2) NOT NULL,
      [CompanyKey] varchar(5) NOT NULL,
      [AuditPaymentKey] varchar(41) NULL,
      [AUDIT_USER] [varchar](255) NULL,
      --[AUDIT_RECORDTYPE] [varchar](255) NULL,
      [AUDIT_DATETIME] [datetime] NULL,
	  [AUDIT_DATETIME_UTC] [datetime] NULL,
    [PAYUNIQUE_ID] [int] NOT NULL,
	[PaymentId] [int] NULL,
	[PolicyTransactionId] [int] NULL,
	[PAYMENTREF_ID] [varchar](50) NULL,
	[ORDERID] [varchar](50) NULL,
	[STATUS] [varchar](100) NULL,
	[TOTAL] [money] NULL,
	[CLIENTID] [int] NULL,
	[TTIME] [datetime] NULL,
	[MerchantID] [varchar](60) NULL,
	[ReceiptNo] [varchar](50) NULL,
	[ResponseDescription] [varchar](34) NULL,
	[ACQResponseCode] [varchar](50) NULL,
	[TransactionNo] [varchar](50) NULL,
	[AuthoriseID] [varchar](50) NULL,
	[CardType] [varchar](50) NULL,
	[BatchNo] [varchar](20) NULL,
	[TxnResponseCode] [varchar](5) NULL,
	[PaymentGatewayID] [varchar](50) NULL,
	[PaymentMerchantID] [int] NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Source] [nvarchar](50) NULL,
	--[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_ACTION] [nvarchar](100) NULL,
	--[AUDIT_USER] [nvarchar](50) NULL,
	[PaymentChannel] [nvarchar](100) NULL
    )

    CREATE CLUSTERED INDEX idx_penAudit_payment_AuditPaymentKey ON [db-au-cba].dbo.penAudit_payment(AuditPaymentKey,AUDIT_DATETIME)
  --create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

  END
  ELSE
  BEGIN

    DELETE a
      FROM [db-au-cba].dbo.penAUDIT_payment a
      INNER JOIN etl_penAUDIT_payment b
        ON a.AuditPaymentKey = b.AuditPaymentKey

  END

  INSERT [db-au-cba].dbo.penAUDIT_payment WITH (TABLOCKX) ([CountryKey]
  , [CompanyKey]
  , [AuditPaymentKey]
  , [AUDIT_USER]
  --, [AUDIT_RECORDTYPE]
  , [AUDIT_DATETIME]
  , [AUDIT_DATETIME_UTC]
      ,[PAYUNIQUE_ID]
      ,[PaymentId]
      ,[PolicyTransactionId]
      ,[PAYMENTREF_ID]
      ,[ORDERID]
      ,[STATUS]
      ,[TOTAL]
      ,[CLIENTID]
      ,[TTIME]
      ,[MerchantID]
      ,[ReceiptNo]
      ,[ResponseDescription]
      ,[ACQResponseCode]
      ,[TransactionNo]
      ,[AuthoriseID]
      ,[CardType]
      ,[BatchNo]
      ,[TxnResponseCode]
      ,[PaymentGatewayID]
      ,[PaymentMerchantID]
      ,[CreateDateTime]
      ,[UpdateDateTime]
      ,[Source]
      --,[AUDIT_DATETIME]
      ,[AUDIT_ACTION]
      --,[AUDIT_USER]
      ,[PaymentChannel])
    SELECT
      [CountryKey],
      [CompanyKey],
      [AuditPaymentKey],
      [AUDIT_USER],
      --[AUDIT_RECORDTYPE],
      [AUDIT_DATETIME],
	  [AUDIT_DATETIME_UTC],
      [PAYUNIQUE_ID]
      ,[PaymentId]
      ,[PolicyTransactionId]
      ,[PAYMENTREF_ID]
      ,[ORDERID]
      ,[STATUS]
      ,[TOTAL]
      ,[CLIENTID]
      ,[TTIME]
      ,[MerchantID]
      ,[ReceiptNo]
      ,[ResponseDescription]
      ,[ACQResponseCode]
      ,[TransactionNo]
      ,[AuthoriseID]
      ,[CardType]
      ,[BatchNo]
      ,[TxnResponseCode]
      ,[PaymentGatewayID]
      ,[PaymentMerchantID]
      ,[CreateDateTime]
      ,[UpdateDateTime]
      ,[Source]
      --,[AUDIT_DATETIME]
      ,[AUDIT_ACTION]
     -- ,[AUDIT_USER]
      ,[PaymentChannel]
    FROM etl_penAUDIT_payment
	/*************************************End of Start of tblpayment_audit*************************************/

END
GO
