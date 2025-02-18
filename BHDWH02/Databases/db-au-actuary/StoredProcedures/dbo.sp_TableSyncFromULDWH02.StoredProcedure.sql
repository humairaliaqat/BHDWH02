USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[sp_TableSyncFromULDWH02]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_TableSyncFromULDWH02]
as

SET NOCOUNT ON

--20181002 - LT - Created


if object_id('[db-au-actuary].dbo.etl_TableSync') is not null drop table [db-au-actuary].dbo.etl_TableSync

create table [db-au-actuary].dbo.etl_TableSync
(
	SourceTableName varchar(200) null,
	TargetTableName varchar(200) null,
	SyncDate date null,
	SyncStatus varchar(50) null
)

--insert tables to be copied from ULDWH02 to BHDWH02
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-star].[dbo].[dimOutlet]','[db-au-actuary].[dbo].[dimOutlet]',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-star].[dbo].[dimProduct]','[db-au-actuary].[dbo].[dimProduct]',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[penOutlet]','[db-au-actuary].[dbo].[penOutlet]',convert(varchar(10),getdate(),120),null)

insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.ClaimIncurredMovement','[db-au-actuary].ws.ClaimIncurredMovement',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.ClaimPaymentMovement','[db-au-actuary].ws.ClaimPaymentMovement',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.ClaimEstimateMovement','[db-au-actuary].ws.ClaimEstimateMovement',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.EMCGroupScore','[db-au-actuary].ws.EMCGroupScore',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[fxHistory]','[db-au-actuary].[dbo].[fxHistory]',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].[dbo].[vClaimDataSet]','[db-au-actuary].[dbo].[vClaimDataSet]',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.DWHDataSet','[db-au-actuary].ws.DWHDataSet',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.DWHDataSetSummary','[db-au-actuary].ws.DWHDataSetSummary',convert(varchar(10),getdate(),120),null)
insert [db-au-actuary].dbo.etl_TableSync values('[db-au-actuary].ws.DWHDataSetPremiumComponents','[db-au-actuary].ws.DWHDataSetPremiumComponents',convert(varchar(10),getdate(),120),null)


--Store tables in Cursor
declare CUR_Tables cursor for
select distinct SourceTableName, TargetTableName
from [db-au-actuary].dbo.etl_TableSync
where SyncStatus is null

--Cycle through cursor and copy each new table from ULDWH02
declare @SourceTableName varchar(200)
declare @TargetTableName varchar(200)
declare @SQL varchar(8000)
declare @msg varchar(400)

open CUR_Tables
fetch next from CUR_Tables into @SourceTableName, @TargetTableName

while @@FETCH_STATUS = 0
begin
	select @SQL = 'if object_id(''' + @TargetTableName + ''') is not null drop table ' + @TargetTableName + ' select * into ' + @TargetTableName + ' from openquery(ULDWH02,''select * from ' + @SourceTableName + ' with(nolock)'')'
	
	execute(@SQL)
		
	select @msg = 'Finished copying ' + @SourceTableName
	raiserror(@msg,0,1) with nowait
	
	update [db-au-actuary].dbo.etl_TableSync
	set SyncStatus = 'Success'
	where SourceTableName = @SourceTableName

	fetch next from CUR_Tables into @SourceTableName, @TargetTableName
end

close CUR_Tables
deallocate CUR_Tables


--create indices
create clustered index idx_dimOutlet_OutletSK on [db-au-actuary].dbo.dimOutlet(OutletSK,isLatest)
create nonclustered index idx_dimOutlet_Country on [db-au-actuary].dbo.dimOutlet(Country)
create nonclustered index idx_dimOutlet_OutletKey on [db-au-actuary].dbo.dimOutlet (OutletKey,isLatest) include (OutletSK,JV,JVDesc,Distributor,Channel)
create nonclustered index idx_dimOutlet_OutletAlphaKey on [db-au-actuary].dbo.dimOutlet(OutletAlphaKey) include(OutletSK,ValidStartDate,ValidEndDate)
create nonclustered index idx_dimOutlet_BDMName on [db-au-actuary].dbo.dimOutlet(BDMName)
create nonclustered index idx_dimOutlet_OutletType on [db-au-actuary].dbo.dimOutlet(OutletType)
create nonclustered index idx_dimOutlet_AlphaCode on [db-au-actuary].dbo.dimOutlet(AlphaCode)
create nonclustered index idx_dimOutlet_TradingStatus on [db-au-actuary].dbo.dimOutlet(TradingStatus)
create nonclustered index idx_dimOutlet_GroupName on [db-au-actuary].dbo.dimOutlet(GroupName)
create nonclustered index idx_dimOutlet_SubGroupName on [db-au-actuary].dbo.dimOutlet(SubGroupName)
create nonclustered index idx_dimOutlet_StateSalesArea on [db-au-actuary].dbo.dimOutlet(StateSalesArea)
create nonclustered index idx_dimOutlet_SuperGroupName on [db-au-actuary].dbo.dimOutlet(SuperGroupName)
create nonclustered index idx_dimOutlet_Distributor on [db-au-actuary].dbo.dimOutlet(Distributor)

create clustered index idx_dimProduct_ProductSK on [db-au-actuary].dbo.dimProduct(ProductSK)
create nonclustered index idx_dimProduct_Country on [db-au-actuary].dbo.dimProduct(Country)
create nonclustered index idx_dimProduct_ProductKey on [db-au-actuary].dbo.dimProduct(ProductKey) include (Country,ProductSK)
create nonclustered index idx_dimProduct_ProductCode on [db-au-actuary].dbo.dimProduct(ProductCode)

create clustered index idx_penOutlet_OutletKey on [db-au-actuary].dbo.penOutlet(OutletKey,OutletStatus)
create nonclustered index idx_penOutlet_AlphaCode on [db-au-actuary].dbo.penOutlet(AlphaCode,CountryKey,OutletStatus) include (CompanyKey,OutletAlphaKey,DomainKey,DomainID,OutletKey)
create nonclustered index idx_penOutlet_CountryKey on [db-au-actuary].dbo.penOutlet(CountryKey,OutletStatus) include (AlphaCode,SuperGroupName,GroupName,GroupCode,SubGroupName,SubGroupCode,OutletName,ABN,ContactStreet,ContactSuburb,ContactState,ContactPostCode,PaymentType)
create nonclustered index idx_penOutlet_group on [db-au-actuary].dbo.penOutlet(CountryKey,SuperGroupName) include (GroupName)
create nonclustered index idx_penOutlet_GroupCode on [db-au-actuary].dbo.penOutlet(GroupCode)
create nonclustered index idx_penOutlet_OutletAlphaKey on [db-au-actuary].dbo.penOutlet(OutletAlphaKey,OutletStatus,CountryKey) include (OutletSKey,OutletKey,GroupCode,AlphaCode,SuperGroupName)
create nonclustered index idx_penOutlet_OutletSKey on [db-au-actuary].dbo.penOutlet(OutletSKey)
create nonclustered index idx_penOutlet_StateSalesArea on [db-au-actuary].dbo.penOutlet(StateSalesArea)
create nonclustered index idx_penOutlet_StatusValue on [db-au-actuary].dbo.penOutlet(StatusValue)
create nonclustered index idx_penOutlet_SubGroupCode on [db-au-actuary].dbo.penOutlet(SubGroupCode)
create nonclustered index idx_penOutlet_PreviousAlpha on [db-au-actuary].dbo.penOutlet(PreviousAlpha,CountryKey,CompanyKey) include(AlphaCode,OutletStatus)
create nonclustered index idx_penOutlet_LatestOutletKey on [db-au-actuary].dbo.penOutlet(LatestOutletKey) include(OutletKey,OutletStatus)

create unique clustered index idx_fxHistory on [db-au-actuary].dbo.fxHistory(BIRowID)
create nonclustered index idx_fxHistory_FX on [db-au-actuary].dbo.fxHistory(LocalCode, ForeignCode, FXDate) include(FXRate, FXSource)
GO
