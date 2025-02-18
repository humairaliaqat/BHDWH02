USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_TableSync_GetTables]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ws].[sp_TableSync_GetTables]	@Frequency varchar(100)
as

SET NOCOUNT ON

--20180904 - LT - This procedure gets new/amended and specific tables for synchronisation from ULDWH02 to BHDWH02
--20180925 - LT - Added @Frequency parameter to control the number of tables to synchronise

--uncomment to debug
/*
declare @Frequency varchar(100)
select @Frequency = 'Daily'
*/

if object_id('[db-au-actuary].ws.TableSync') is not null drop table [db-au-actuary].ws.TableSync

create table [db-au-actuary].ws.TableSync
(
	TableName varchar(200) null,
	SyncDate date null,
	SyncStatus varchar(50) null
)

--Get new tables on ULDWH02 to be copied 
insert [db-au-actuary].ws.TableSync
select 
	'[' + u.TABLE_CATALOG + '].' + u.TABLE_SCHEMA + '.' + u.TABLE_NAME as TableName,
	convert(varchar(10),getdate(),120) as SyncDate,
	null as SyncStatus
from 
	(
		select * 
		from [db-au-actuary].INFORMATION_SCHEMA.tables
	) b
	right join
	(
		select * 
		from openquery(ULDWH02,
		'
			select * 
			from [db-au-actuary].INFORMATION_SCHEMA.TABLES 
			where 
				TABLE_NAME not in (''EarningDataSet'',''EarningPatternDataMappingPost'',''EarningPatternDataMappingPP'',
									''EarningPatternDataMappingPre'',''EarningPatternsMapping'',''EarningPatternsMappingByDay'',
									''EarningPatternsDataSetByDay'',''EarningPatternsDataSet'',''EarningPatternDataClaimCost'')
		')
	) u on 
		b.TABLE_CATALOG = u.TABLE_CATALOG and
		b.TABLE_SCHEMA = u.TABLE_SCHEMA and
		b.TABLE_NAME = u.TABLE_NAME and
		b.TABLE_TYPE = u.TABLE_TYPE
where
	u.TABLE_TYPE = 'BASE TABLE' and
	b.TABLE_NAME is null

--recurring tables that needs to be copied and replaced
if @Frequency = 'Daily'
begin
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.ClaimIncurredMovement',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.ClaimPaymentMovement',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.ClaimEstimateMovement',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].[dbo].[fxHistory]',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].[dbo].[vClaimDataSet]',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.EMCGroupScore',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.DWHDataSetPremiumComponents',convert(varchar(10),getdate(),120),null)
end
else		--monthly
begin
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.DWHDataSetSummary',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.DWHDataSet',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].ws.DWHDataSetSummaryID',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].dbo.DWHDataSetSummary',convert(varchar(10),getdate(),120),null)
	insert [db-au-actuary].ws.TableSync values('[db-au-actuary].dbo.DWHDataSet',convert(varchar(10),getdate(),120),null)
end


GO
