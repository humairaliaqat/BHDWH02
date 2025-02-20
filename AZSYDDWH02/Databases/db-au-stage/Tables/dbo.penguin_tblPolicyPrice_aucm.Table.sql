USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyPrice_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyPrice_aucm](
	[ID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[GrossPremium] [money] NULL,
	[BasePremium] [money] NOT NULL,
	[AdjustedNet] [money] NOT NULL,
	[Commission] [money] NOT NULL,
	[CommissionRate] [numeric](10, 9) NULL,
	[Discount] [money] NOT NULL,
	[DiscountRate] [numeric](12, 9) NULL,
	[BaseAdminFee] [money] NULL,
	[GrossAdminFee] [money] NULL,
	[IsPOSDiscount] [bit] NULL
) ON [PRIMARY]
GO
