USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpExcessDiscRate]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpExcessDiscRate](
	[CountryKey] [varchar](2) NOT NULL,
	[ExcessDiscRateKey] [varchar](10) NULL,
	[ExcessDiscRateID] [int] NOT NULL,
	[ExcessAmount] [money] NULL,
	[DiscountRate] [decimal](24, 0) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpExcessDiscRate_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpExcessDiscRate_CountryKey] ON [dbo].[corpExcessDiscRate]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
