USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL106_SyncTablesFromULDWH02]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL106_SyncTablesFromULDWH02]
as

SET NOCOUNT ON

--20180928 - LT - Created
--20181011 - LT - Added clmClaimFlags and clmClaimTags tables
--20181029 - lT - Removed clmClaimFlags and clmClaimTags tables.
--20190329 - LL - add cisCalls
--20191126 - EV - add cisAgent, cisAgentState, cisCallData, cisOutboundCallData
--20191127 - EV - add [db-au-actuary].[ws].[CountryCurrency] & [db-au-actuary].[ws].[SASMapping]

if object_id('[db-au-stage].dbo.etl_TableSync') is not null drop table [db-au-stage].dbo.etl_TableSync

create table [db-au-stage].dbo.etl_TableSync
(
	SourceTableName varchar(200) null,
	TargetTableName varchar(200) null,
	SyncDate date null,
	SyncStatus varchar(50) null
)

--insert tables to be copied from ULDWH02 to AZSYDDWH02
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cdgBusinessUnit]','[db-au-cba].[dbo].[cdgBusinessUnit]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cdgProduct]','[db-au-cba].[dbo].[cdgProduct]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cdgRegion]','[db-au-cba].[dbo].[cdgRegion]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[usrABSData]','[db-au-cba].[dbo].[usrABSData]',convert(varchar(10),getdate(),120),null)

-- cis tables -Start
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cisAgent]','[db-au-cba].[dbo].[cisAgent]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cisAgentState]','[db-au-cba].[dbo].[cisAgentState]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cisCallData]','[db-au-cba].[dbo].[cisCallData]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[cisOutboundCallData]','[db-au-cba].[dbo].[cisOutboundCallData]',convert(varchar(10),getdate(),120),null)
-- cis tables -End

insert [db-au-stage].dbo.etl_TableSync values('[db-au-star].[dbo].[dimAgeBand]','[db-au-cba].[dbo].[dimAgeBand]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-star].[dbo].[DimDestination]','[db-au-cba].[dbo].[DimDestination]',convert(varchar(10),getdate(),120),null)

-- RPT0390 tables -Start
insert [db-au-stage].dbo.etl_TableSync values('[db-au-actuary].[ws].[CountryCurrency]','[db-au-actuary].[ws].[CountryCurrency]',convert(varchar(10),getdate(),120),null)
insert [db-au-stage].dbo.etl_TableSync values('[db-au-actuary].[ws].[SASMapping]','[db-au-actuary].[ws].[SASMapping]',convert(varchar(10),getdate(),120),null)
-- RPT0390 tables -End

-- usrCBCaseFee tables -Start
insert [db-au-stage].dbo.etl_TableSync values('[db-au-cmdwh].[dbo].[usrCBCaseFee]','[db-au-cba].[dbo].[usrCBCaseFee]',convert(varchar(10),getdate(),120),null)
-- usrCBCaseFee tables -End

--Store tables in Cursor
declare CUR_Tables cursor for
select distinct SourceTableName, TargetTableName
from [db-au-stage].dbo.etl_TableSync
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
	
	update [db-au-stage].dbo.etl_TableSync
	set SyncStatus = 'Success'
	where SourceTableName = @SourceTableName

	fetch next from CUR_Tables into @SourceTableName, @TargetTableName
end

close CUR_Tables
deallocate CUR_Tables


--create indices
create nonclustered index [idx_cdgBusinessUnit_id] on [db-au-cba].[dbo].[cdgBusinessUnit]([BusinessUnitID] asc) include ([BusinessUnit],[Domain])
create clustered index [idx_cdgBusinessUnit_main] on [db-au-cba].[dbo].[cdgBusinessUnit]([BIRowID] asc)

create nonclustered index [idx_cdgProduct_id] on [db-au-cba].[dbo].[cdgProduct]([ProductID] asc) include ([Product],[ProductCode],[PlanCode])
create clustered index [idx_cdgProduct_main] on [db-au-cba].[dbo].[cdgProduct]([BIRowID] asc)

create nonclustered index [idx_cdgRegion_id] on [db-au-cba].[dbo].[cdgRegion]([RegionID] asc) include ([Region])
create clustered index [idx_cdgRegion_main] on [db-au-cba].[dbo].[cdgRegion]([BIRowID] asc)

create clustered index idx_dimAgeBand_AgeBandSK on [db-au-cba].dbo.dimAgeBand(AgeBandSK)
create nonclustered index idx_dimAgeBand_Age on [db-au-cba].dbo.dimAgeBand(Age)
create nonclustered index idx_dimAgeBand_AgeBand on [db-au-cba].dbo.dimAgeBand(AgeBand)
create nonclustered index idx_dimAgeBand_ABSAgeBand on [db-au-cba].dbo.dimAgeBand(ABSAgeBand)
create nonclustered index idx_dimAgeBand_ABSAgeCategory on [db-au-cba].dbo.dimAgeBand(ABSAgeCategory)
create nonclustered index idx_dimAgeBand_HashKey on [db-au-cba].dbo.dimAgeBand(HashKey)

create clustered index idx_dimDestination_DestinationSK on [db-au-cba].dbo.dimDestination(DestinationSK)
create nonclustered index idx_dimDestination_DestinationID on [db-au-cba].dbo.dimDestination(DestinationID)
create nonclustered index idx_dimDestination_Destination on [db-au-cba].dbo.dimDestination(Destination)
create nonclustered index idx_dimDestination_ISO2Code on [db-au-cba].dbo.dimDestination(ISO2Code)
create nonclustered index idx_dimDestination_Continent on [db-au-cba].dbo.dimDestination(Continent)
create nonclustered index idx_dimDestination_HashKey on [db-au-cba].dbo.dimDestination(HashKey)

-- index for CISCO tables -Start
CREATE NONCLUSTERED INDEX [idx_cisAgent_AgentKey]	ON [db-au-cba].[dbo].[cisAgent] ([AgentKey] ASC)	INCLUDE([AgentLogin],[AgentID],[AgentName],[TeamName]) 
CREATE NONCLUSTERED INDEX [idx_cisAgent_AgentLogin] ON [db-au-cba].[dbo].[cisAgent] ([AgentLogin] ASC ) INCLUDE([AgentKey],[AgentID],[AgentName],[TeamName])
CREATE NONCLUSTERED INDEX [idx_cisAgent_Extension]	ON [db-au-cba].[dbo].[cisAgent] ([Extension] ASC, [DateInactive] ASC) INCLUDE([AgentLogin],[AgentID],[AgentName],[TeamName])
CREATE CLUSTERED INDEX [idx_cisAgent_BIRowID]		ON [db-au-cba].[dbo].[cisAgent] ([BIRowID] ASC)

CREATE NONCLUSTERED INDEX [idx_cisAgentState_EventTimes]	ON [db-au-cba].[dbo].[cisAgentState] ([EventDateTime] ASC,	[AgentKey] ASC,	[EventType] ASC) INCLUDE([EventDescription],[EventDuration])
CREATE CLUSTERED INDEX [idx_cisAgentState_BIRowID]			ON [db-au-cba].[dbo].[cisAgentState] ([BIRowID] ASC)

CREATE NONCLUSTERED INDEX [idx_cisCallData_CallTimes] ON [db-au-cba].[dbo].[cisCallData] ([CallStartDateTime] ASC, [CallEndDateTime] ASC)
							INCLUDE([SessionID],[AgentKey],[CSQKey],[Disposition],[OriginatorNumber],[DestinationNumber],[CalledNumber],[OrigCalledNumber],[CallsPresented],[CallsHandled],[CallsAbandoned],[RingTime],[TalkTime],[HoldTime],[WorkTime],[WrapUpTime],[QueueTime],[MetServiceLevel],[Transfer],[Redirect],[Conference],[EmployeeKey],[OrganisationKey],[ApplicationName],[ContactType]) 
CREATE NONCLUSTERED INDEX [idx_cisCallData_LoginID] ON [db-au-cba].[dbo].[cisCallData] ([LoginID] ASC,	[CallStartDateTime] DESC)
					INCLUDE([CallEndDateTime],[OriginatorNumber],[SessionID],[SessionKey],[Transfer],[CalledNumber],[OrigCalledNumber])
CREATE NONCLUSTERED INDEX [idx_cisCallData_OriginatorNumber] ON [db-au-cba].[dbo].[cisCallData] ([OriginatorNumber] ASC,[CallStartDateTime] DESC)
					INCLUDE([CallEndDateTime],[LoginID],[SessionID],[SessionKey])

CREATE NONCLUSTERED INDEX [idx_cisCallData_SessionKey]	ON [db-au-cba].[dbo].[cisCallData]([SessionKey] ASC)
CREATE CLUSTERED INDEX [idx_cisCallData_BIRowID]		ON [db-au-cba].[dbo].[cisCallData] ([BIRowID] ASC)

CREATE NONCLUSTERED INDEX [idx_cisOutboundCallData_CallTimes] ON [db-au-cba].[dbo].[cisOutboundCallData] ([CallStartDateTime] ASC,	[CallEndDateTime] ASC)
					INCLUDE([AgentKey],[CallDuration],[OutboundCallType],[TalkTime])
CREATE NONCLUSTERED INDEX [idx_cisOutboundCallData_SessionKey] ON [db-au-cba].[dbo].[cisOutboundCallData]([SessionKey] ASC)
CREATE CLUSTERED INDEX [idx_cisOutboundCallData_BIRowID] ON [db-au-cba].[dbo].[cisOutboundCallData] ([BIRowID] ASC)
-- index for CISCO tables -End

-- Build index for RPT0390 report tables - Start
CREATE NONCLUSTERED INDEX [iso3]		ON [db-au-actuary].[ws].[CountryCurrency] ([CountryISO3Code] ASC)	INCLUDE([CurrencyCode],[CurrencyName],[CountryName])
CREATE UNIQUE CLUSTERED INDEX [cidx]	ON [db-au-actuary].[ws].[CountryCurrency] ([BIRowID] ASC )

CREATE NONCLUSTERED INDEX [idxf]		ON [db-au-actuary].[ws].[SASMapping] ([FieldName] ASC,[OriginalValue] ASC) INCLUDE([MappedValue])
CREATE UNIQUE CLUSTERED INDEX [cidx]	ON [db-au-actuary].[ws].[SASMapping] ([BIRowID] ASC)
-- Build index for RPT0390 report tables - End

CREATE NONCLUSTERED INDEX [idx_usrCBCaseFee_ClientCode] ON [db-au-cba].[dbo].[usrCBCaseFee] ([ClientCode] ASC,	[ProgramCode] ASC,	[CountryKey] ASC)
	INCLUDE([DebtorsCode],[SimpleMedicalCaseFee],[SimpleTechnicalCaseFee],[MediumMedicalCaseFee],[MediumTechnicalCaseFee],[ComplexMedicalCaseFee],[ComplexTechnicalCaseFee],[EvacuationCaseFee],[GST])


--cisCalls
delete [db-au-cba]..cisCalls
where
    CallStartDateTime >= dateadd(day, -14, convert(date, getdate()))

insert into [db-au-cba]..cisCalls with (tablock)
(
    SessionKey,
    SessionID,
    SessionSequence,
    NodeID,
    ProfileID,
    ContactType,
    ContactDisposition,
    DispositionReason,
    OriginatorTypeID,
    OriginatorType,
    OriginatorID,
    OriginatorAgent,
    OriginatorExt,
    OriginatorNumber,
    DestinationTypeID,
    DestinationType,
    DestinationID,
    DestinationAgent,
    DestinationExt,
    DestinationNumber,
    CallResult,
    CallStartDateTime,
    CallEndDateTime,
    CallStartDateTimeUTC,
    CallEndDateTimeUTC,
    GatewayNumber,
    DialedNumber,
    Transfer,
    Redirect,
    Conference,
    ConnectTime,
    RingTime,
    TalkTime,
    HoldTime,
    WorkTime,
    WrapUpTime,
    TargetType,
    TargetID,
    QueueDisposition,
    QueueHandled,
    QueueAbandoned,
    QueueTime,
    CSQName,
    ServiceLevelPercentage,
    MetServiceLevel,
    Agent,
    Team,
    LoginID ,
    SupervisorFlag,
    VarCSQName,
    VarEXT,
    VarClassification,
    VarIVROption,
    VarIVRReference,
    VarWrapUp,
    WrapUpData,
    AccountNumber,
    CallerEnteredDigits,
    BadCallTag,
    ApplicationID,
    ApplicationName,
    CampaignID,
    DialinglistID,
    OriginProtocol,
    DestinationProtocol,
    UpdateDateTime
)
select 
    SessionKey,
    SessionID,
    SessionSequence,
    NodeID,
    ProfileID,
    ContactType,
    ContactDisposition,
    DispositionReason,
    OriginatorTypeID,
    OriginatorType,
    OriginatorID,
    OriginatorAgent,
    OriginatorExt,
    OriginatorNumber,
    DestinationTypeID,
    DestinationType,
    DestinationID,
    DestinationAgent,
    DestinationExt,
    DestinationNumber,
    CallResult,
    CallStartDateTime,
    CallEndDateTime,
    CallStartDateTimeUTC,
    CallEndDateTimeUTC,
    GatewayNumber,
    DialedNumber,
    Transfer,
    Redirect,
    Conference,
    ConnectTime,
    RingTime,
    TalkTime,
    HoldTime,
    WorkTime,
    WrapUpTime,
    TargetType,
    TargetID,
    QueueDisposition,
    QueueHandled,
    QueueAbandoned,
    QueueTime,
    CSQName,
    ServiceLevelPercentage,
    MetServiceLevel,
    Agent,
    Team,
    LoginID ,
    SupervisorFlag,
    VarCSQName,
    VarEXT,
    VarClassification,
    VarIVROption,
    VarIVRReference,
    VarWrapUp,
    WrapUpData,
    AccountNumber,
    CallerEnteredDigits,
    BadCallTag,
    ApplicationID,
    ApplicationName,
    CampaignID,
    DialinglistID,
    OriginProtocol,
    DestinationProtocol,
    getdate()
from
    [ULDWH02].[db-au-cmdwh].[dbo].[cisCalls] with(nolock)
where
    CallStartDateTime >= dateadd(day, -14, convert(date, getdate())) and
    ApplicationName not in ('AUDTC') and
    (
        CSQName like '%cba%' or
        VarClassification like '%cba%' or
        CSQName like '%bankwest%' or
        VarClassification like '%bankwest%'
    )
GO
