USE [SSISDB]
GO
/****** Object:  UserDefinedTableType [internal].[decrypted_data_table]    Script Date: 18/02/2025 2:36:18 PM ******/
CREATE TYPE [internal].[decrypted_data_table] AS TABLE(
	[id] [bigint] NOT NULL,
	[value] [varbinary](max) NULL
)
GO
