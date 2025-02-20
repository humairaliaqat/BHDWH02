USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyPrice]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyPrice](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[PolicyPriceKey] [varchar](41) NOT NULL,
	[PolicyTransactionID] [int] NULL,
	[ID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[GrossPremium] [money] NULL,
	[BasePremium] [money] NOT NULL,
	[AdjustedNet] [money] NOT NULL,
	[Commission] [money] NOT NULL,
	[CommissionRate] [numeric](15, 9) NULL,
	[Discount] [money] NOT NULL,
	[DiscountRate] [numeric](15, 9) NULL,
	[BaseAdminFee] [money] NULL,
	[GrossAdminFee] [money] NULL,
	[isPOSDiscount] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_PolicyPrice_ID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_PolicyPrice_ID] ON [dbo].[penPolicyPrice]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_PolicyPrice_Composite]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_PolicyPrice_Composite] ON [dbo].[penPolicyPrice]
(
	[CountryKey] ASC,
	[CompanyKey] ASC,
	[GroupID] ASC,
	[ComponentID] ASC
)
INCLUDE([BasePremium],[GrossPremium],[Commission],[Discount],[GrossAdminFee],[CommissionRate],[DiscountRate],[AdjustedNet],[isPOSDiscount],[BaseAdminFee]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_PolicyPrice_PolicyTransactionID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_PolicyPrice_PolicyTransactionID] ON [dbo].[penPolicyPrice]
(
	[PolicyTransactionID] ASC
)
INCLUDE([CountryKey],[CompanyKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
