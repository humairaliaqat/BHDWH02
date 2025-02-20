USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penAUDIT_Policy]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penAUDIT_Policy](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[AuditPolicyKey] [varchar](41) NULL,
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
	[PrimaryCountry] [nvarchar](max) NULL,
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
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penAudit_Policy_AuditPolicyKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penAudit_Policy_AuditPolicyKey] ON [dbo].[penAUDIT_Policy]
(
	[AuditPolicyKey] ASC,
	[AUDIT_DATETIME] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
