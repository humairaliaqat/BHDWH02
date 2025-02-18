USE [db-au-actuary]
GO
/****** Object:  Table [ak].[t_claims2024]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[t_claims2024](
	[domaincountry] [varchar](2) NOT NULL,
	[ReceiptDate] [date] NULL,
	[ReceiptMonth] [date] NULL,
	[FinalisedTime] [datetime] NULL,
	[JV] [nvarchar](100) NULL,
	[policykey] [varchar](41) NULL,
	[basepolicyno] [varchar](50) NULL,
	[claimkey] [varchar](40) NOT NULL,
	[claimno] [int] NOT NULL,
	[eventdescription] [nvarchar](max) NULL,
	[sectionid] [int] NOT NULL,
	[ActuarialBenefitGroup] [varchar](19) NULL,
	[NetPaymentMovement] [numeric](38, 6) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
