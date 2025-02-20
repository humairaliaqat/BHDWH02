USE [db-au-stage]
GO
/****** Object:  Table [dbo].[e5_WorkActivityProperty_v3]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5_WorkActivityProperty_v3](
	[Work_Id] [uniqueidentifier] NOT NULL,
	[WorkActivity_Id] [uniqueidentifier] NOT NULL,
	[Property_Id] [nvarchar](32) NOT NULL,
	[PropertyValue] [sql_variant] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [e5_WorkActivityProperty_v31]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [e5_WorkActivityProperty_v31] ON [dbo].[e5_WorkActivityProperty_v3]
(
	[Work_Id] ASC,
	[WorkActivity_Id] ASC,
	[Property_Id] ASC
)
INCLUDE([PropertyValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
