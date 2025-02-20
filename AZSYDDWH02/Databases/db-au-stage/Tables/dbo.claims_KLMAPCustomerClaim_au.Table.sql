USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLMAPCustomerClaim_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLMAPCustomerClaim_au](
	[ID] [int] NOT NULL,
	[KLCLAIM] [int] NOT NULL,
	[OnlineClaimId] [int] NOT NULL,
	[CustomerId] [nvarchar](100) NULL,
	[BinNumber] [nvarchar](50) NULL
) ON [PRIMARY]
GO
