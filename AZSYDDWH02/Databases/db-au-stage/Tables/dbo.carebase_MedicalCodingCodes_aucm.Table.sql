USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_MedicalCodingCodes_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_MedicalCodingCodes_aucm](
	[Id] [int] NOT NULL,
	[MedicalCodingId] [int] NOT NULL,
	[Code] [varchar](75) NOT NULL,
	[CodeText] [varchar](500) NULL,
	[CodeTypeId] [int] NOT NULL
) ON [PRIMARY]
GO
