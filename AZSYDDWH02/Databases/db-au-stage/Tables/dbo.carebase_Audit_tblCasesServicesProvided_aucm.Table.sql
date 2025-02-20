USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_Audit_tblCasesServicesProvided_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_Audit_tblCasesServicesProvided_aucm](
	[Audit_UserName] [varchar](255) NULL,
	[Audit_Datetime] [datetime] NULL,
	[Audit_Action] [varchar](10) NULL,
	[CaseNo] [varchar](14) NULL,
	[ServiceTypeID] [int] NULL,
	[Amount] [money] NULL
) ON [PRIMARY]
GO
