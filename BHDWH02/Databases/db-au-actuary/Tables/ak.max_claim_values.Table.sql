USE [db-au-actuary]
GO
/****** Object:  Table [ak].[max_claim_values]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[max_claim_values](
	[policykey] [varchar](41) NULL,
	[ClaimNo] [int] NULL,
	[max_incurred] [numeric](38, 6) NULL
) ON [PRIMARY]
GO
