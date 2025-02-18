USE [db-au-actuary]
GO
/****** Object:  View [cng].[Table_Size]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [cng].[Table_Size] AS

SELECT TOP 10000
    s.Name          AS SchemaName,
    t.Name          AS TableName,
	t.create_date   AS CreateDate,
    t.modify_date   AS ModifyDate,
    p.rows          AS RowCounts,
    'DROP TABLE [' + s.Name + '].[' + t.Name + ']; '                                                    AS DropTable,
    'SELECT * INTO [zzz].[' + s.Name + '.' + t.Name + '] FROM [' + s.Name + '].[' + t.Name + ']; '    AS CopyTable,
    ROUND(SUM(a.total_pages) * 8.00/1024,0)                         AS TotalSpaceMB, 
    ROUND(SUM(a.used_pages)  * 8.00/1024,0)                         AS UsedSpaceMB, 
    ROUND((SUM(a.total_pages) - SUM(a.used_pages)) * 8.00/1024,0)   AS UnusedSpaceMB
FROM 
    sys.tables t
INNER JOIN 
    sys.schemas s ON s.schema_id = t.schema_id
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
WHERE 
    t.Name NOT LIKE 'dt%'    -- filter out system tables for diagramming
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name, t.create_date, t.modify_date, p.Rows
ORDER BY SUM(a.total_pages) * 8 DESC
;
GO
