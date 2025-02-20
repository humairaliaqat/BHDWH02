USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuoteTravellerAddons]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuoteTravellerAddons](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteSK] [bigint] NOT NULL,
	[QuoteID] [varchar](50) NULL,
	[TravellerIdentifier] [nvarchar](max) NULL,
	[AddonCode] [nvarchar](max) NULL,
	[AddonName] [nvarchar](max) NULL,
	[AppliedLevel] [nvarchar](max) NULL,
	[ChosenLevel] [nvarchar](max) NULL,
	[EMCAccepted] [nvarchar](max) NULL,
	[EMCAssessmentID] [nvarchar](max) NULL,
	[AddonGrossPrice] [float] NULL,
	[AddonActualGross] [float] NULL,
	[discountRate] [float] NULL,
	[AddonDiscountedGross] [float] NULL,
	[AddonFormattedActualGross] [nvarchar](max) NULL,
 CONSTRAINT [PK_impQuoteTravellerAddons] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
