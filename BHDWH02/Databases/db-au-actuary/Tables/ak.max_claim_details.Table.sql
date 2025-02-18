USE [db-au-actuary]
GO
/****** Object:  Table [ak].[max_claim_details]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[max_claim_details](
	[policykey] [varchar](41) NULL,
	[claimno] [int] NULL,
	[perildesc] [nvarchar](65) NULL,
	[sectiondescription] [nvarchar](200) NULL,
	[benefitcategory] [varchar](35) NULL,
	[actuarialbenefitgroup] [varchar](19) NULL
) ON [PRIMARY]
GO
