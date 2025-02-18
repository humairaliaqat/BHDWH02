USE [SSISDB]
GO
/****** Object:  UserDefinedTableType [internal].[adt_event_data]    Script Date: 18/02/2025 2:36:18 PM ******/
CREATE TYPE [internal].[adt_event_data] AS TABLE(
	[event_data_type_name] [internal].[adt_name] NOT NULL,
	[event_data_value] [sql_variant] NULL
)
GO
