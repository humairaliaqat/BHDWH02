USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[clmOnlineClaimCreditCard]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmOnlineClaimCreditCard](
	[BIRowID] [bigint] NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[OnlineClaimKey] [varchar](40) NOT NULL,
	[OnlineClaimID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[CardProvider] [nvarchar](max) NULL,
	[CardType] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
