USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcMedicalGroup]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcMedicalGroup](
	[CountryKey] [varchar](2) NULL,
	[ApplicationKey] [varchar](15) NULL,
	[ApplicationID] [int] NULL,
	[GroupID] [int] NOT NULL,
	[GroupStatus] [varchar](19) NULL,
	[GroupScore] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
