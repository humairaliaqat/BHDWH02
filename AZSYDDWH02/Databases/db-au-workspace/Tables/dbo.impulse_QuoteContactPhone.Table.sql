USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[impulse_QuoteContactPhone]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteContactPhone](
	[QuoteID] [varchar](50) NULL,
	[type] [nvarchar](4000) NULL,
	[number] [nvarchar](4000) NULL
) ON [PRIMARY]
GO
