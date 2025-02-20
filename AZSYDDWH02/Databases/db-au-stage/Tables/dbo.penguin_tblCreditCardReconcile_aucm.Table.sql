USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCreditCardReconcile_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCreditCardReconcile_aucm](
	[CreditCardReconcileId] [int] NOT NULL,
	[CRMUserId] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[AccountingPeriod] [date] NOT NULL,
	[Groups] [varchar](255) NULL,
	[DomainId] [int] NOT NULL,
	[DirectsCheque] [varchar](30) NULL,
	[NetCheque] [varchar](30) NULL,
	[CommissionCheque] [varchar](30) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
