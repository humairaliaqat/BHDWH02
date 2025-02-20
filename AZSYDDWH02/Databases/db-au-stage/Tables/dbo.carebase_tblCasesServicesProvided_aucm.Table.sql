USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblCasesServicesProvided_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblCasesServicesProvided_aucm](
	[CaseNo] [varchar](14) NOT NULL,
	[ServiceTypeID] [int] NULL,
	[Amount] [money] NULL
) ON [PRIMARY]
GO
