USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteTravellerAddons]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteTravellerAddons](
	[QuoteID] [varchar](50) NULL,
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
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_QuoteTravellerAddons]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_QuoteTravellerAddons] ON [dbo].[impulse_QuoteTravellerAddons]
(
	[QuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
