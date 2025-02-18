USE [db-au-stage]
GO
/****** Object:  Table [dbo].[UW_Premiums_test]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UW_Premiums_test](
	[Rank] [bigint] NULL,
	[UW_Month] [date] NULL,
	[PolicyKey] [nvarchar](50) NULL,
	[UW_Policy_Status] [nvarchar](50) NULL,
	[UW_Premium] [float] NULL,
	[UW_Premium_COVID19] [float] NULL,
	[Previous_Policy_Status] [nvarchar](50) NULL,
	[Previous_UW_Premium] [float] NULL,
	[Previous_UW_Premium_COVID19] [float] NULL,
	[Movement] [float] NULL,
	[Movement_COVID19] [float] NULL,
	[Total_Movement] [float] NULL,
	[Total_Movement_COVID19] [float] NULL,
	[Domain_Country] [nvarchar](50) NULL,
	[Issue_Mth] [datetime2](7) NULL,
	[Rating_Group] [nvarchar](50) NULL,
	[JV_Description_Orig] [nvarchar](50) NULL,
	[JV_Group] [nvarchar](50) NULL,
	[Product_Code] [nvarchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UW_Premiums_test_PolicyKeyProductCode_test]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE CLUSTERED INDEX [idx_UW_Premiums_test_PolicyKeyProductCode_test] ON [dbo].[UW_Premiums_test]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_UW_Premiums_test_Movement_test]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_UW_Premiums_test_Movement_test] ON [dbo].[UW_Premiums_test]
(
	[Movement] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
