USE [SSISDB]
GO
/****** Object:  UserDefinedTableType [internal].[decrypted_data_table]    Script Date: 20/02/2025 10:29:28 AM ******/
CREATE TYPE [internal].[decrypted_data_table] AS TABLE(
	[id] [bigint] NOT NULL,
	[value] [varbinary](max) NULL
)
GO
