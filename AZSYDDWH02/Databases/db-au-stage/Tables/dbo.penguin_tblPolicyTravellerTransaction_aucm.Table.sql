USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyTravellerTransaction_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyTravellerTransaction_aucm](
	[ID] [int] NOT NULL,
	[PolicyTransactionID] [int] NOT NULL,
	[PolicyTravellerID] [int] NOT NULL,
	[HasEMC] [bit] NOT NULL,
	[TripsTravellerID] [int] NULL,
	[MemberRewardPointsEarned] [money] NULL,
	[MemberRewardFactor] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPolicyTravellerTransaction_aucm_ID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblPolicyTravellerTransaction_aucm_ID] ON [dbo].[penguin_tblPolicyTravellerTransaction_aucm]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPolicyTravellerTransaction_aucm_PolicyTransactionID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblPolicyTravellerTransaction_aucm_PolicyTransactionID] ON [dbo].[penguin_tblPolicyTravellerTransaction_aucm]
(
	[ID] ASC
)
INCLUDE([PolicyTransactionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
