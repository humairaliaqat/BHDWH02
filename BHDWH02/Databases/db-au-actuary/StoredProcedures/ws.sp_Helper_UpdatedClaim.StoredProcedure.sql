USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_Helper_UpdatedClaim]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [ws].[sp_Helper_UpdatedClaim]
    @BatchMode bit = 0,
    @StartDate date,
    @EndDate date

as

SET NOCOUNT ON

--20181003 - LT - Migrated from ULDWH02


--uncomment to debug
/*
declare @BatchMode bit
declare @StartDate date
declare @EndDate date
select @BatchMode = 0, @StartDate = '2018-10-02', @EndDate = '2018-10-03'
*/

declare @SQL varchar(8000)

select @SQL = 'if object_id(''[db-au-actuary].ws.UpdatedClaim'') is not null  drop table [db-au-actuary].ws.UpdatedClaim select ClaimKey into [db-au-actuary].ws.UpdatedClaim from openquery(uldwh02,''select ClaimKey from [db-au-cmdwh].dbo.clmClaim where CreateDate >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and CreateDate < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''''
select @SQL = @SQL + ' union select ClaimKey from [db-au-cmdwh].dbo.clmAuditClaim where ' + convert(varchar,@BatchMode) + ' = 0 and AuditDateTime >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and AuditDateTime < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''''
select @SQL = @SQL + ' union select ClaimKey from [db-au-cmdwh].dbo.clmAuditPayment where ' + convert(varchar,@BatchMode) + ' = 0 and AuditDateTime >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and AuditDateTime < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''''
select @SQL = @SQL + ' union select ClaimKey from [db-au-cmdwh].dbo.clmPayment where ' + convert(varchar,@BatchMode) + ' = 0 and ModifiedDate >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and ModifiedDate < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''''
select @SQL = @SQL + ' union select ClaimKey from [db-au-cmdwh].dbo.clmAuditSection where ' + convert(varchar,@BatchMode) + ' = 0 and AuditDateTime >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and AuditDateTime < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''''
select @SQL = @SQL + ' union select ClaimKey from [db-au-cmdwh].dbo.clmEstimateHistory eh where ' + convert(varchar,@BatchMode) + ' = 0 and EHCreateDate >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and EHCreateDate < ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + ''''' '')'

execute
(
	@SQL
) at BHDWH02


GO
