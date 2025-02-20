USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyTransAddOn]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyTransAddOn](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[AddOnGroup] [nvarchar](50) NULL,
	[AddOnText] [nvarchar](500) NULL,
	[CoverIncrease] [money] NULL,
	[GrossPremium] [money] NULL,
	[UnAdjGrossPremium] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransAddOn_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyTransAddOn_PolicyTransactionKey] ON [dbo].[penPolicyTransAddOn]
(
	[PolicyTransactionKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransAddOn_AddOnGroup]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransAddOn_AddOnGroup] ON [dbo].[penPolicyTransAddOn]
(
	[AddOnGroup] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyTransAddOn_AddOnPrice]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyTransAddOn_AddOnPrice] ON [dbo].[penPolicyTransAddOn]
(
	[PolicyTransactionKey] ASC
)
INCLUDE([AddOnGroup],[GrossPremium],[UnAdjGrossPremium]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
