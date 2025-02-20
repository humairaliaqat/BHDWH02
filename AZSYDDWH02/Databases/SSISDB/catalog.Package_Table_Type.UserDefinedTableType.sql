USE [SSISDB]
GO
/****** Object:  UserDefinedTableType [catalog].[Package_Table_Type]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE TYPE [catalog].[Package_Table_Type] AS TABLE(
	[name] [nvarchar](260) NOT NULL,
	[package_data] [varbinary](max) NULL
)
GO
