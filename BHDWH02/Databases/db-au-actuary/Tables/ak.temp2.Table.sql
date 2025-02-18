USE [db-au-actuary]
GO
/****** Object:  Table [ak].[temp2]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[temp2](
	[JV Description] [nvarchar](100) NULL,
	[PolicyKey] [varchar](41) NULL,
	[DomainCountry] [varchar](2) NULL,
	[Outlet Channel] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[premium] [float] NULL,
	[Issue Date] [datetime] NULL,
	[claimno] [int] NULL,
	[sectionid] [int] NULL,
	[EventDescription] [nvarchar](max) NULL,
	[PerilDesc] [nvarchar](65) NULL,
	[sectiondescription] [nvarchar](200) NULL,
	[BenefitCategory] [varchar](35) NULL,
	[actuarialbenefitgroup] [varchar](19) NULL,
	[LossMonth] [date] NULL,
	[NetIncurredMovementIncRecoveries] [numeric](38, 6) NULL,
	[NetPaymentMovementIncRecoveries] [numeric](38, 6) NULL,
	[SectionCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
