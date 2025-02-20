USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOTP_PlanProduct_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOTP_PlanProduct_aucm](
	[ID] [int] NOT NULL,
	[OTP_ProductId] [int] NOT NULL,
	[UniquePlanID] [int] NOT NULL,
	[PlanID] [int] NOT NULL,
	[DefaultExcess] [money] NOT NULL,
	[MaxAdminFee] [money] NOT NULL,
	[IsUpsell] [bit] NOT NULL,
	[SortOrder] [int] NULL,
	[CancellationValueSetID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOTP_PlanProduct_aucm_UniquePlanID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblOTP_PlanProduct_aucm_UniquePlanID] ON [dbo].[penguin_tblOTP_PlanProduct_aucm]
(
	[UniquePlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
