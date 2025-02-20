USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_NIT_INCIDENTTYPE_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_NIT_INCIDENTTYPE_aucm](
	[CLI_CODE] [varchar](3) NULL,
	[POL_CODE] [varchar](3) NULL,
	[INCIDENT_TYPE] [nvarchar](60) NULL,
	[ID] [int] NOT NULL,
	[Active] [bit] NULL
) ON [PRIMARY]
GO
