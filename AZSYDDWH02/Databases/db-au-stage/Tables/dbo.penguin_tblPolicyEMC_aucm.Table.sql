USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyEMC_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyEMC_aucm](
	[ID] [int] NOT NULL,
	[PolicyTravellerTransactionID] [int] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NOT NULL,
	[DOB] [datetime] NOT NULL,
	[EMCRef] [varchar](100) NOT NULL,
	[EMCScore] [numeric](10, 4) NULL,
	[PremiumIncrease] [numeric](18, 5) NULL,
	[IsPercentage] [bit] NULL,
	[AddOnId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPolicyEMC_aucm_PolicyTravellerTransactionID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblPolicyEMC_aucm_PolicyTravellerTransactionID] ON [dbo].[penguin_tblPolicyEMC_aucm]
(
	[PolicyTravellerTransactionID] ASC
)
INCLUDE([EMCRef],[EMCScore],[AddOnId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
