USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_excel_supergroup]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_excel_supergroup](
	[Country] [nvarchar](255) NULL,
	[DomainID] [int] NULL,
	[SuperGroup] [nvarchar](255) NULL
) ON [PRIMARY]
GO
