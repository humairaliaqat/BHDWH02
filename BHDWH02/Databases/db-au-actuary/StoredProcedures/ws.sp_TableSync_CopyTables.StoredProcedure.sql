USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_TableSync_CopyTables]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [ws].[sp_TableSync_CopyTables]
as

SET NOCOUNT ON


--Store tables in Cursor
declare CUR_Tables cursor for
select distinct TableName
from [db-au-actuary].ws.TableSync
where SyncStatus is null

--Cycle through cursor and copy each new table from ULDWH02
declare @TableName varchar(200)
declare @SQL varchar(8000)
declare @msg varchar(400)

open CUR_Tables
fetch next from CUR_Tables into @TableName

while @@FETCH_STATUS = 0
begin
	select @SQL = 'if object_id(''' + @TableName + ''') is not null drop table ' + @TableName + ' select * into ' + @TableName + ' from openquery(ULDWH02,''select * from ' + @TableName + ' with(nolock)'')'
	
	execute(@SQL)
	
	select @msg = 'Finished copying ' + @TableName
	raiserror(@msg,0,1) with nowait
	
	update [db-au-actuary].ws.TableSync
	set SyncStatus = 'Success'
	where TableName = @TableName

	fetch next from CUR_Tables into @TableName
end

close CUR_Tables
deallocate CUR_Tables
GO
