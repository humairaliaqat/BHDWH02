USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPaymentAllocationAdjustment_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPaymentAllocationAdjustment_aucm](
	[PaymentAllocationAdjustmentId] [int] NOT NULL,
	[PaymentAllocationId] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[AdjustmentType] [varchar](30) NOT NULL,
	[Comments] [varchar](255) NULL
) ON [PRIMARY]
GO
