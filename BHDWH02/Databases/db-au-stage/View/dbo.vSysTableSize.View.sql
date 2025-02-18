USE [db-au-stage]
GO
/****** Object:  View [dbo].[vSysTableSize]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vSysTableSize] as
select 
    getdate() TimeStamp,
    '[db-au-cmdwh]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-cmdwh].sys.tables t
    inner join [db-au-cmdwh].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-cmdwh].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-cmdwh].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-cmdwh].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-stage]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-stage].sys.tables t
    inner join [db-au-stage].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-stage].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-stage].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-stage].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-star]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-star].sys.tables t
    inner join [db-au-star].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-star].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-star].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-star].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-workspace]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-workspace].sys.tables t
    inner join [db-au-workspace].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-workspace].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-workspace].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-workspace].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-bobj]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-bobj].sys.tables t
    inner join [db-au-bobj].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-bobj].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-bobj].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-bobj].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-bobjaudit]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-bobjaudit].sys.tables t
    inner join [db-au-bobjaudit].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-bobjaudit].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-bobjaudit].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-bobjaudit].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

union all

select 
    getdate() TimeStamp,
    '[db-au-actuary]' DatabaseName,
    t.name TableName,
    p.rows RowCounts,
    sum(a.total_pages) * 8.0 / 1024 TotalSpaceMB, 
    sum(a.used_pages) * 8.0 / 1024 UsedSpaceMB,
    sum(
        case
            when i.index_id in (0, 1) then a.used_pages * 8.0 / 1024
            else 0
        end
    ) DataSpaceMB,
    sum(
        case
            when i.index_id > 1 then a.used_pages * 8.0 / 1024
            else 0
        end
    ) IndexSpaceMB
from 
    [db-au-bobjaudit].sys.tables t
    inner join [db-au-bobjaudit].sys.indexes i on 
        t.object_id = i.object_id
    inner join [db-au-bobjaudit].sys.partitions p on 
        i.object_id = p.object_id and 
        i.index_id = p.index_id
    inner join [db-au-bobjaudit].sys.allocation_units a on 
        p.partition_id = a.container_id
    left outer join [db-au-bobjaudit].sys.schemas s on 
        t.schema_id = s.schema_id
where 
    t.name not like 'dt%' and 
    t.is_ms_shipped = 0 and 
    i.object_id > 255 
group by 
    t.name, 
    s.name, 
    p.rows

--create table [dbo].[sysTableGrowth]
--(
--    [BIRowID] bigint not null identity(1,1),
--	[TimeStamp] [datetime] not null,
--	[DatabaseName] [varchar](255) not null,
--	[TableName] [varchar](255) not null,
--	[RowCounts] [bigint] not null,
--	[TotalSpaceMB] [numeric](38, 6) null,
--	[UsedSpaceMB] [numeric](38, 6) null,
--	[DataSpaceMB] [numeric](38, 6) null,
--	[IndexSpaceMB] [numeric](38, 6) null
--)

--create clustered index idx on [sysTableGrowth](BIRowID)
--create nonclustered index idx_date on [sysTableGrowth]([TimeStamp])
--create nonclustered index idx_table on [sysTableGrowth]([TableName])
--create nonclustered index idx_database on [sysTableGrowth]([DatabaseName])


GO
