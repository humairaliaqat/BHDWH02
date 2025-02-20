USE [db-au-cba]
GO
/****** Object:  Table [dbo].[sfAccount]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sfAccount](
	[AccountID] [nvarchar](18) NULL,
	[AccountName] [nvarchar](255) NULL,
	[GroupCode] [nvarchar](10) NULL,
	[GroupName] [nvarchar](255) NULL,
	[SubGroupCode] [nvarchar](10) NULL,
	[SubGroupName] [nvarchar](255) NULL,
	[AlphaCode] [nvarchar](10) NULL,
	[OutletName] [nvarchar](255) NULL,
	[AgencyID] [nvarchar](30) NULL,
	[OutletType] [nvarchar](255) NULL,
	[TradingStatus] [nvarchar](40) NULL,
	[AgencyManager] [nvarchar](1300) NULL,
	[ContactTitle] [nvarchar](20) NULL,
	[ContactFirstName] [nvarchar](80) NULL,
	[ContactLastName] [nvarchar](80) NULL,
	[ContactAddress] [nvarchar](255) NULL,
	[ContactCity] [nvarchar](40) NULL,
	[ContactState] [nvarchar](80) NULL,
	[ContactPostcode] [nvarchar](20) NULL,
	[ContactCountry] [nvarchar](80) NULL,
	[ContactEmail] [nvarchar](80) NULL,
	[AccountsEmail] [nvarchar](80) NULL,
	[CompanyCode] [nvarchar](255) NULL,
	[DomainCode] [nvarchar](255) NULL,
	[BDMName] [nvarchar](255) NULL,
	[BDMCallFrequency] [nvarchar](3) NULL,
	[AccountManager] [nvarchar](255) NULL,
	[AMCallFrequency] [nvarchar](3) NULL,
	[Email] [nvarchar](80) NULL,
	[Phone] [nvarchar](40) NULL,
	[Fax] [nvarchar](40) NULL,
	[FCNation] [nvarchar](255) NULL,
	[FCArea] [nvarchar](255) NULL,
	[Industry] [nvarchar](40) NULL,
	[IsDeleted] [bit] NULL,
	[LastVisited] [datetime] NULL,
	[LastActivityDate] [date] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedBy] [nvarchar](121) NULL,
	[LastReferencedDate] [datetime] NULL,
	[LastViewedDate] [datetime] NULL,
	[PreviousAlpha] [bit] NULL,
	[Owner] [nvarchar](121) NULL,
	[PaymentType] [nvarchar](255) NULL,
	[QuadrantPotential] [nvarchar](255) NULL,
	[RecordType] [nvarchar](80) NULL,
	[SalesQuadrant] [nvarchar](255) NULL,
	[SalesSegement] [nvarchar](255) NULL,
	[SalesTier] [nvarchar](255) NULL,
	[VisitDueDate] [date] NULL,
	[VisitStatus] [nvarchar](1300) NULL,
	[LastAccountActivityDate] [datetime] NULL,
	[LastAccountActivityUser] [nvarchar](121) NULL,
	[Quadrant] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_sfAccount_AgencyID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_sfAccount_AgencyID] ON [dbo].[sfAccount]
(
	[AgencyID] ASC
)
INCLUDE([QuadrantPotential],[SalesQuadrant],[SalesSegement],[SalesTier],[Quadrant],[AccountID],[AlphaCode]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
