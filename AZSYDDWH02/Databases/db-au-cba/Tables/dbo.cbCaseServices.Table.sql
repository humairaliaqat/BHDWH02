USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbCaseServices]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbCaseServices](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[ServiceTypeID] [int] NOT NULL,
	[ServiceType] [nvarchar](250) NOT NULL,
	[ServiceAmount] [int] NULL,
	[ServiceFee] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCaseServices_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbCaseServices_BIRowID] ON [dbo].[cbCaseServices]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbCaseServices_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCaseServices_CaseKey] ON [dbo].[cbCaseServices]
(
	[CaseKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
