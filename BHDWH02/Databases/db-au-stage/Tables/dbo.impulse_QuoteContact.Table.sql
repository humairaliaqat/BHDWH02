USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteContact]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteContact](
	[QuoteID] [varchar](50) NULL,
	[email] [nvarchar](4000) NULL,
	[city] [nvarchar](4000) NULL,
	[state] [nvarchar](4000) NULL,
	[suburb] [nvarchar](4000) NULL,
	[country] [nvarchar](4000) NULL,
	[street1] [nvarchar](4000) NULL,
	[street2] [nvarchar](4000) NULL,
	[postCode] [nvarchar](4000) NULL,
	[optInMarketing] [nvarchar](4000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_QuoteContact]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_QuoteContact] ON [dbo].[impulse_QuoteContact]
(
	[QuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
