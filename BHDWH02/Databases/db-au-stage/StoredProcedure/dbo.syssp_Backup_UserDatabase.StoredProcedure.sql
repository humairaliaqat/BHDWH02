USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_Backup_UserDatabase]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[syssp_Backup_UserDatabase]
as

SET NOCOUNT ON

declare @SQL varchar(8000)

select @SQL = 'BACKUP DATABASE [db-au-cmdwh] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\db-au-cmdwh.BAK'' WITH NOFORMAT, INIT, NAME = ''db-au-cmdwh'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)

select @SQL = 'BACKUP DATABASE [db-au-bobj] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\db-au-bobj.BAK'' WITH NOFORMAT, INIT, NAME = ''db-au-bobj'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)

select @SQL = 'BACKUP DATABASE [db-au-bobjaudit] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\db-au-bobjaudit.BAK'' WITH NOFORMAT, INIT, NAME = ''db-au-bobjaudit'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)

select @SQL = 'BACKUP DATABASE [db-au-log] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\db-au-log.BAK'' WITH NOFORMAT, INIT, NAME = ''db-au-log'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)

select @SQL = 'BACKUP DATABASE [db-au-star] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\db-au-star.BAK'' WITH NOFORMAT, INIT, NAME = ''db-au-star'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)

select @SQL = 'BACKUP DATABASE [SSISDB] TO DISK = ''\\bhbackup02.aust.covermore.com.au\SQL Backup\uldwh01\SSISDB.BAK'' WITH NOFORMAT, INIT, NAME = ''SSISDB'', SKIP, REWIND, NOUNLOAD, STATS = 10'
execute(@SQL)



GO
