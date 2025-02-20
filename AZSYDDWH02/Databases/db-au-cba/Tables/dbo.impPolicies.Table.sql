USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impPolicies]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impPolicies](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[ImpulsePolicyID] [varchar](50) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[PolicyKey] [varchar](41) NULL,
	[ImpulsePolicyQuoteID] [varchar](50) NULL,
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](50) NULL,
	[QuoteSource] [nvarchar](50) NULL,
	[cbaChannelID] [nvarchar](50) NULL,
 CONSTRAINT [PK_impPolicies] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_quote]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_quote] ON [dbo].[impPolicies]
(
	[QuoteID] ASC,
	[BIRowID] ASC,
	[PolicyNumber] ASC,
	[PolicyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
