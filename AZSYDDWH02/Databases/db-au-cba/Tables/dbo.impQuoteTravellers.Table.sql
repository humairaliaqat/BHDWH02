USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuoteTravellers]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuoteTravellers](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteSK] [bigint] NOT NULL,
	[QuoteID] [varchar](50) NULL,
	[TravellerIdentifier] [nvarchar](max) NULL,
	[Title] [nvarchar](max) NULL,
	[firstName] [nvarchar](max) NULL,
	[lastName] [nvarchar](max) NULL,
	[memberId] [nvarchar](max) NULL,
	[PrimaryTraveller] [nvarchar](max) NULL,
	[age] [nvarchar](max) NULL,
	[isPlaceholderAge] [nvarchar](max) NULL,
	[dateOfBirth] [date] NULL,
	[BinNumber] [varchar](20) NULL,
	[PartnerUniqueId] [varchar](100) NULL,
 CONSTRAINT [PK_impQuoteTravellers] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_quote]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_quote] ON [dbo].[impQuoteTravellers]
(
	[QuoteID] ASC
)
INCLUDE([PartnerUniqueId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_traveller]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_traveller] ON [dbo].[impQuoteTravellers]
(
	[PartnerUniqueId] ASC
)
INCLUDE([QuoteID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
