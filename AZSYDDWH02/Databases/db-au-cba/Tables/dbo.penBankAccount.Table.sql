USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penBankAccount]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penBankAccount](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[BankAccountKey] [varchar](41) NULL,
	[BankAccountID] [int] NULL,
	[CompanyID] [int] NULL,
	[DomainID] [int] NULL,
	[AccountName] [nvarchar](255) NULL,
	[AccountCode] [varchar](6) NULL,
	[AccountBSB] [varchar](10) NULL,
	[AccountNumber] [varchar](30) NULL,
	[AccountStatus] [varchar](15) NULL,
	[AccountStartDate] [datetime] NULL,
	[AccountEndDate] [datetime] NULL,
	[AccountCreateDateTime] [datetime] NULL,
	[AccountUpdateDateTime] [datetime] NULL,
	[AccountCreateDateTimeUTC] [datetime] NULL,
	[AccountUpdateDateTimeUTC] [datetime] NULL,
	[CompanyName] [nvarchar](255) NULL,
	[CompanyFullName] [nvarchar](255) NULL,
	[CompanyCode] [varchar](3) NULL,
	[Underwriter] [nvarchar](255) NULL,
	[CompanyABN] [nvarchar](50) NULL,
	[CompanyStatus] [varchar](15) NULL,
	[CompanyCreateDateTime] [datetime] NULL,
	[CompanyUpdateDateTime] [datetime] NULL,
	[CompanyCreateDateTimeUTC] [datetime] NULL,
	[CompanyUpdateDateTimeUTC] [datetime] NULL,
	[PaymentProcessAgentID] [int] NULL,
	[PaymentProcessAgentName] [nvarchar](55) NULL,
	[PaymentProcessAgentCode] [nvarchar](3) NULL,
	[PaymentProcessAgentStatus] [varchar](15) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penBankAccount_BankAccountKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penBankAccount_BankAccountKey] ON [dbo].[penBankAccount]
(
	[BankAccountKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penBankAccount_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penBankAccount_CountryKey] ON [dbo].[penBankAccount]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
