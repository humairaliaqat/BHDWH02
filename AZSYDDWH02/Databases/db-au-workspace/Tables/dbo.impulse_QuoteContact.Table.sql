USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[impulse_QuoteContact]    Script Date: 20/02/2025 10:27:08 AM ******/
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
