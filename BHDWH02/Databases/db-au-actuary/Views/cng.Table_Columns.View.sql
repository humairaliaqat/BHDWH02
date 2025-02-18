USE [db-au-actuary]
GO
/****** Object:  View [cng].[Table_Columns]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Table_Columns] AS 

SELECT TOP 1000000
    schema_name(tab.schema_id) as schema_name,
    tab.name as table_name, 
    col.column_id,
    col.name as column_name, 
    t.name as data_type,    
    col.max_length,
    col.precision
FROM       sys.tables  AS tab
INNER JOIN sys.columns AS col ON tab.object_id    = col.object_id
 LEFT JOIN sys.types   AS t   ON col.user_type_id = t.user_type_id
ORDER BY 
    schema_name,
    table_name, 
    column_id
;
GO
