USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_excel_AgeBands_test]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_excel_AgeBands_test](
	[Age] [float] NULL,
	[Code] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL
) ON [PRIMARY]
GO
