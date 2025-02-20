USE [db-au-star]
GO
/****** Object:  Table [dbo].[Dim_Scenario_ind]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dim_Scenario_ind](
	[Scenario_SK] [int] IDENTITY(1,1) NOT NULL,
	[Scenario_Code] [varchar](50) NOT NULL,
	[Scenario_Desc] [varchar](200) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Update_Date] [datetime] NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [Dim_Scenario_PK_ind]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [Dim_Scenario_PK_ind] ON [dbo].[Dim_Scenario_ind]
(
	[Scenario_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX01_Dim_Scenario_ind]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [IX01_Dim_Scenario_ind] ON [dbo].[Dim_Scenario_ind]
(
	[Scenario_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
