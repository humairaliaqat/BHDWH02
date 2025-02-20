USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyRenewalBatchTransaction_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyRenewalBatchTransaction_aucm](
	[PolicyRenewalBatchTransactionId] [int] NOT NULL,
	[PolicyId] [int] NOT NULL,
	[QuoteId] [int] NULL,
	[Status] [varchar](50) NOT NULL,
	[PolicyRenewalBatchId] [int] NOT NULL,
	[PolicyIssued] [bit] NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
