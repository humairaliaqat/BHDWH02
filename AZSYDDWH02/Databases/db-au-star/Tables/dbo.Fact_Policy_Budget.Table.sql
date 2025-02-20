USE [db-au-star]
GO
/****** Object:  Table [dbo].[Fact_Policy_Budget]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Policy_Budget](
	[Date_SK] [int] NULL,
	[Outlet_SK] [int] NULL,
	[Business_Unit_SK] [int] NULL,
	[Currency_SK] [int] NULL,
	[Gross_Premium_Budget_Amount] [decimal](30, 15) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX01_Fact_Policy_Budget]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [IX01_Fact_Policy_Budget] ON [dbo].[Fact_Policy_Budget]
(
	[Date_SK] ASC,
	[Outlet_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
