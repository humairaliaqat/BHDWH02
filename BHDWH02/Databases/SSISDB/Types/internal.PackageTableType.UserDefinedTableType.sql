USE [SSISDB]
GO
/****** Object:  UserDefinedTableType [internal].[PackageTableType]    Script Date: 18/02/2025 2:36:18 PM ******/
CREATE TYPE [internal].[PackageTableType] AS TABLE(
	[name] [nvarchar](260) NOT NULL,
	[package_guid] [uniqueidentifier] NOT NULL,
	[description] [nvarchar](1024) NULL,
	[package_format_version] [int] NOT NULL,
	[version_major] [int] NOT NULL,
	[version_minor] [int] NOT NULL,
	[version_build] [int] NOT NULL,
	[version_comments] [nvarchar](1024) NULL,
	[version_guid] [uniqueidentifier] NOT NULL,
	[entry_point] [bit] NOT NULL,
	[validation_status] [char](1) NOT NULL,
	[last_validation_time] [datetimeoffset](7) NULL,
	[package_data] [varbinary](max) NULL
)
GO
