USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteTravellerAddons]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteTravellerAddons](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[TravellerIdentifier] [nvarchar](4000) NULL,
	[AddonCode] [nvarchar](4000) NULL,
	[AddonName] [nvarchar](4000) NULL,
	[AppliedLevel] [nvarchar](4000) NULL,
	[ChosenLevel] [nvarchar](4000) NULL,
	[EMCAccepted] [nvarchar](4000) NULL,
	[EMCAssessmentID] [nvarchar](4000) NULL,
	[AddonGrossPrice] [float] NULL,
	[AddonActualGross] [float] NULL,
	[discountRate] [float] NULL,
	[AddonDiscountedGross] [float] NULL,
	[AddonFormattedActualGross] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
