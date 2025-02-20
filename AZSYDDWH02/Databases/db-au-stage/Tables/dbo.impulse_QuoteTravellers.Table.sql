USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteTravellers]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteTravellers](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[TravellerOrder] [int] NULL,
	[TravellerIdentifier] [nvarchar](4000) NULL,
	[Title] [nvarchar](4000) NULL,
	[firstName] [nvarchar](4000) NULL,
	[lastName] [nvarchar](4000) NULL,
	[memberId] [nvarchar](4000) NULL,
	[PrimaryTraveller] [nvarchar](4000) NULL,
	[age] [nvarchar](4000) NULL,
	[isPlaceholderAge] [nvarchar](4000) NULL,
	[dateOfBirth] [date] NULL,
	[BinNumber] [nvarchar](4000) NULL,
	[PartnerUniqueId] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
