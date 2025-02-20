USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyDomain_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyDomain_aucm](
	[PolicyDomainID] [int] NOT NULL,
	[PolicyDomainName] [nvarchar](50) NOT NULL,
	[PolicyDomainDB] [nvarchar](50) NOT NULL,
	[PolicyNumberStartRange] [int] NOT NULL,
	[PolicyNumberEndRange] [int] NOT NULL,
	[NextAvailablePolicyNumber] [int] NOT NULL,
	[TimeZoneInfo] [varchar](50) NULL,
	[TransactionNumberStartRange] [int] NOT NULL,
	[TransactionNumberEndRange] [int] NOT NULL,
	[NextAvailableTransactionNumber] [int] NOT NULL
) ON [PRIMARY]
GO
