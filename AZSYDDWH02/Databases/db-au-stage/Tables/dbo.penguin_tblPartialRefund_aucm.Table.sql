USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPartialRefund_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPartialRefund_aucm](
	[MonthNumber] [int] NOT NULL,
	[RefundPercentage] [numeric](18, 5) NOT NULL,
	[DomainId] [int] NOT NULL
) ON [PRIMARY]
GO
