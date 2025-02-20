USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblParentCompany_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblParentCompany_AU](
	[ParentCompanyid] [int] NOT NULL,
	[ParentCompanyName] [nchar](100) NULL,
	[Display] [int] NULL,
	[ParentCompanyCode] [varchar](3) NULL
) ON [PRIMARY]
GO
