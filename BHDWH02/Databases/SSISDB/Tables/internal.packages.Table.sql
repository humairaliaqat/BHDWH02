USE [SSISDB]
GO
/****** Object:  Table [internal].[packages]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [internal].[packages](
	[package_id] [bigint] IDENTITY(1,1) NOT NULL,
	[project_version_lsn] [bigint] NOT NULL,
	[name] [nvarchar](260) NOT NULL,
	[package_guid] [uniqueidentifier] NOT NULL,
	[description] [nvarchar](1024) NULL,
	[package_format_version] [int] NOT NULL,
	[version_major] [int] NOT NULL,
	[version_minor] [int] NOT NULL,
	[version_build] [int] NOT NULL,
	[version_comments] [nvarchar](1024) NULL,
	[version_guid] [uniqueidentifier] NOT NULL,
	[project_id] [bigint] NOT NULL,
	[entry_point] [bit] NOT NULL,
	[validation_status] [char](1) NOT NULL,
	[last_validation_time] [datetimeoffset](7) NULL,
	[package_data] [varbinary](max) NULL,
 CONSTRAINT [PK_Packages] PRIMARY KEY CLUSTERED 
(
	[package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Packages_Name]    Script Date: 18/02/2025 2:36:18 PM ******/
CREATE NONCLUSTERED INDEX [IX_Packages_Name] ON [internal].[packages]
(
	[name] ASC
)
INCLUDE([package_id],[project_version_lsn],[project_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [internal].[packages]  WITH CHECK ADD  CONSTRAINT [FK_Packages_ProjectId_Projects] FOREIGN KEY([project_id])
REFERENCES [internal].[projects] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [internal].[packages] CHECK CONSTRAINT [FK_Packages_ProjectId_Projects]
GO
ALTER TABLE [internal].[packages]  WITH CHECK ADD  CONSTRAINT [FK_Packages_ProjectVersionLsn_ObjectVersions] FOREIGN KEY([project_version_lsn])
REFERENCES [internal].[object_versions] ([object_version_lsn])
ON DELETE CASCADE
GO
ALTER TABLE [internal].[packages] CHECK CONSTRAINT [FK_Packages_ProjectVersionLsn_ObjectVersions]
GO
