USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyTravellerTransaction]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyTravellerTransaction](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[PolicyTravellerTransactionKey] [varchar](41) NOT NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[PolicyTravellerKey] [varchar](41) NULL,
	[PolicyTravellerTransactionID] [int] NOT NULL,
	[PolicyTransactionID] [int] NULL,
	[PolicyTravellerID] [int] NOT NULL,
	[HasEMC] [bit] NOT NULL,
	[TripsTravellerID] [int] NULL,
	[MemberRewardFactor] [decimal](18, 2) NULL,
	[MemberRewardPointsEarned] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTravellerTransaction_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyTravellerTransaction_PolicyTransactionKey] ON [dbo].[penPolicyTravellerTransaction]
(
	[PolicyTransactionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTravellerTransaction_PolicyTravellerKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTravellerTransaction_PolicyTravellerKey] ON [dbo].[penPolicyTravellerTransaction]
(
	[PolicyTravellerKey] ASC,
	[PolicyTransactionKey] ASC
)
INCLUDE([CountryKey],[CompanyKey],[PolicyTravellerTransactionID],[PolicyTravellerTransactionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTravellerTransaction_PolicyTravellerTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTravellerTransaction_PolicyTravellerTransactionKey] ON [dbo].[penPolicyTravellerTransaction]
(
	[PolicyTravellerTransactionKey] ASC
)
INCLUDE([PolicyTransactionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
