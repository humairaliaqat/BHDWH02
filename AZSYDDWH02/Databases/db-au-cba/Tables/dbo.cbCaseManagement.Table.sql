USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbCaseManagement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbCaseManagement](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[CaseManagementKey] [nvarchar](20) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[CaseManagementID] [int] NOT NULL,
	[CSIData] [nvarchar](max) NOT NULL,
	[TemplateName] [nvarchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCaseManagement_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbCaseManagement_BIRowID] ON [dbo].[cbCaseManagement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCaseManagement_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCaseManagement_CaseKey] ON [dbo].[cbCaseManagement]
(
	[CaseKey] ASC
)
INCLUDE([CSIData],[TemplateName],[CaseManagementKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
