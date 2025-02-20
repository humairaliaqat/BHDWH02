USE [db-au-cba]
GO
/****** Object:  Table [dbo].[e5WorkActivityProperties_v3]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5WorkActivityProperties_v3](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [varchar](5) NULL,
	[Country] [varchar](5) NULL,
	[Work_ID] [varchar](50) NULL,
	[WorkActivity_ID] [varchar](50) NULL,
	[Original_Work_ID] [uniqueidentifier] NOT NULL,
	[Original_WorkActivity_ID] [uniqueidentifier] NULL,
	[Property_ID] [nvarchar](32) NULL,
	[PropertyValue] [sql_variant] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5WorkActivityProperties_v3_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [idx_e5WorkActivityProperties_v3_BIRowID] ON [dbo].[e5WorkActivityProperties_v3]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5WorkActivityProperties_Property_ID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkActivityProperties_Property_ID] ON [dbo].[e5WorkActivityProperties_v3]
(
	[Property_ID] ASC
)
INCLUDE([WorkActivity_ID],[PropertyValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5WorkActivityProperties_v3_WorkActivity_ID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5WorkActivityProperties_v3_WorkActivity_ID] ON [dbo].[e5WorkActivityProperties_v3]
(
	[WorkActivity_ID] ASC,
	[Property_ID] ASC
)
INCLUDE([Work_ID],[PropertyValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
