USE [SSISDB]
GO
/****** Object:  Table [internal].[projects]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [internal].[projects](
	[project_id] [bigint] IDENTITY(1,1) NOT NULL,
	[folder_id] [bigint] NOT NULL,
	[name] [sysname] NOT NULL,
	[description] [nvarchar](1024) NULL,
	[project_format_version] [int] NULL,
	[deployed_by_sid] [varbinary](85) NOT NULL,
	[deployed_by_name] [nvarchar](128) NOT NULL,
	[last_deployed_time] [datetimeoffset](7) NOT NULL,
	[created_time] [datetimeoffset](7) NOT NULL,
	[object_version_lsn] [bigint] NOT NULL,
	[validation_status] [char](1) NOT NULL,
	[last_validation_time] [datetimeoffset](7) NULL,
 CONSTRAINT [PK_Projects] PRIMARY KEY CLUSTERED 
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_Project_FolderName] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[folder_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Projects_Name]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE NONCLUSTERED INDEX [IX_Projects_Name] ON [internal].[projects]
(
	[name] ASC
)
INCLUDE([project_id],[folder_id],[object_version_lsn]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [internal].[projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_FolderId_Folders] FOREIGN KEY([folder_id])
REFERENCES [internal].[folders] ([folder_id])
GO
ALTER TABLE [internal].[projects] CHECK CONSTRAINT [FK_Projects_FolderId_Folders]
GO
