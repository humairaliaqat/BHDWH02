USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[budget_2020_premium]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[budget_2020_premium](
	[Domain] [varchar](2) NULL,
	[JV] [nvarchar](2) NULL,
	[Channel] [varchar](19) NULL,
	[Product] [nvarchar](4000) NULL,
	[Month] [date] NULL,
	[PremiumBudget] [float] NULL
) ON [PRIMARY]
GO
