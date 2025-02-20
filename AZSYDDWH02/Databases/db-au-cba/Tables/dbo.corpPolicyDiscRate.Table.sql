USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpPolicyDiscRate]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpPolicyDiscRate](
	[CountryKey] [varchar](2) NOT NULL,
	[PolicyDiscRateKey] [varchar](10) NULL,
	[PolicyDiscRateID] [int] NULL,
	[DiscountRate] [decimal](24, 0) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpPolicyDiscRate_EMCKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpPolicyDiscRate_EMCKey] ON [dbo].[corpPolicyDiscRate]
(
	[PolicyDiscRateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
