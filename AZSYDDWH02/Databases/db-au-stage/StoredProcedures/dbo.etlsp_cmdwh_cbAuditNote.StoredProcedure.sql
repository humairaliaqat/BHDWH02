USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbAuditNote]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbAuditNote]
as
begin
/*
20140714, LS,   TFS12109
                drop AuditKey & AuditID
20140715, LS,   use transaction (as carebase has intra-day refreshes)
*/
    set nocount on

    exec etlsp_StagingIndex_Carebase

    if object_id('[db-au-cba].dbo.cbAuditNote') is null
    begin

        create table [db-au-cba].dbo.cbAuditNote
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(17) null,
            [UserKey] nvarchar(33) null,
            [NoteKey] nvarchar(20) null,
            [AuditUserName] nvarchar(255) null,
            [AuditDateTime] datetime null,
            [AuditDateTimeUTC] datetime null,
            [AuditDate] datetime null,
            [AuditAction] nvarchar(10) null,
            [CaseNo] nvarchar(14) null,
            [UserID] nvarchar(30) null,
            [isIncluded] nvarchar(1) null,
            [NoteDate] datetime null,
            [NoteType] nvarchar(2) null,
            [MBFSent] nvarchar(1) null,
            [Note] nvarchar(max) null,
            [CreateDate] datetime null,
            [NoteTime] datetime null,
            [NoteTimeUTC] datetime null,
            [NoteID] int not null,
            [DeleteDate] datetime null,
            [AuditCount] int null
        )

        create clustered index idx_cbAuditNote_BIRowID on [db-au-cba].dbo.cbAuditNote(BIRowID)
        create nonclustered index idx_cbAuditNote_AuditDate on [db-au-cba].dbo.cbAuditNote(AuditDate,CountryKey)
        create nonclustered index idx_cbAuditNote_CaseKey on [db-au-cba].dbo.cbAuditNote(CaseKey)
        create nonclustered index idx_cbAuditNote_CaseNo on [db-au-cba].dbo.cbAuditNote(CaseNo,CountryKey)

    end

    if object_id('tempdb..#cbAuditNote') is not null
        drop table #cbAuditNote

    select
        'AU' CountryKey,
        left('AU-' + c.CASE_NO, 20) CaseKey,
        left('AU-' + c.AC, 35) UserKey,
        left('AU-' + convert(varchar, c.ROWID), 20) NoteKey,
        c.AUDIT_USERNAME AuditUserName,
        dbo.xfn_ConvertUTCtoLocal(c.AUDIT_DateTime, 'AUS Eastern Standard Time') AuditDateTime,
        c.AUDIT_DateTime AuditDateTimeUTC,
        convert(date, dbo.xfn_ConvertUTCtoLocal(c.AUDIT_DateTime, 'AUS Eastern Standard Time')) AuditDate,
        c.AUDIT_ACTION AuditAction,
        c.Case_No CaseNo,
        c.AC UserID,
        c.[INCLUDE] isIncluded,
        convert(date, convert(date, dbo.xfn_ConvertUTCtoLocal(c.NOTE_DATE, 'AUS Eastern Standard Time'))) NoteDate,
        c.[TYPE] NoteType,
        c.MBFSENT MBFSent,
        c.NOTES Note,
        convert(date, dbo.xfn_ConvertUTCtoLocal(c.CREATED_DT, 'AUS Eastern Standard Time')) CreateDate,
        convert(date, dbo.xfn_ConvertUTCtoLocal(c.NOTE_DATE, 'AUS Eastern Standard Time')) NoteTime,
        c.NOTE_DATE NoteTimeUTC,
        c.ROWID NoteID,
        convert(date, dbo.xfn_ConvertUTCtoLocal(c.DELETE_DATE, 'AUS Eastern Standard Time')) DeleteDate,
        c.AUDIT_COUNT AuditCount
    into #cbAuditNote
    from
        dbo.carebase_AUDIT_CCN_CASENOTE_aucm c

    begin transaction cbAuditNote

    begin try

        delete n
        from
            [db-au-cba].dbo.cbAuditNote n
            inner join carebase_AUDIT_CCN_CASENOTE_aucm r on
                n.NoteKey = left('AU-' + convert(varchar, r.ROWID), 20) collate database_default and
                n.AuditDateTimeUTC = r.AUDIT_DATETIME

        insert into [db-au-cba].dbo.cbAuditNote with(tablockx)
        (
            [CountryKey],
            [CaseKey],
            [UserKey],
            [NoteKey],
            [AuditUserName],
            [AuditDateTime],
            [AuditDateTimeUTC],
            [AuditDate],
            [AuditAction],
            [CaseNo],
            [UserID],
            [isIncluded],
            [NoteDate],
            [NoteType],
            [MBFSent],
            [Note],
            [CreateDate],
            [NoteTime],
            [NoteTimeUTC],
            [NoteID],
            [DeleteDate],
            [AuditCount]
        )
        select
            [CountryKey],
            [CaseKey],
            [UserKey],
            [NoteKey],
            [AuditUserName],
            [AuditDateTime],
            [AuditDateTimeUTC],
            [AuditDate],
            [AuditAction],
            [CaseNo],
            [UserID],
            [isIncluded],
            [NoteDate],
            [NoteType],
            [MBFSent],
            [Note],
            [CreateDate],
            [NoteTime],
            [NoteTimeUTC],
            [NoteID],
            [DeleteDate],
            [AuditCount]
        from
            #cbAuditNote

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbAuditNote

        exec syssp_genericerrorhandler 'cbAuditNote data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbAuditNote

end


GO
