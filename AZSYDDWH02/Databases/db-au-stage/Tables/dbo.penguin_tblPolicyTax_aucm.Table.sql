USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyTax_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyTax_aucm](
	[ID] [int] NOT NULL,
	[PolicyTravellerTransactionID] [int] NOT NULL,
	[TaxID] [int] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[TaxOnAgentComm] [money] NOT NULL,
	[IsPOSDiscount] [bit] NOT NULL
) ON [PRIMARY]
GO
