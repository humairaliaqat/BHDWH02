USE [db-au-actuary]
GO
/****** Object:  Table [ak].[max_claim_values_pollevel]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[max_claim_values_pollevel](
	[policykey] [varchar](41) NULL,
	[max_incurred] [numeric](38, 6) NULL
) ON [PRIMARY]
GO
