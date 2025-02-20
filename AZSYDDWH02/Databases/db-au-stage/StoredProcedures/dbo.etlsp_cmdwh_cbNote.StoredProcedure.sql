USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbNote]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbNote]
as
begin
/*
20140715, LS,   TFS12109
                change column type
                use transaction (as carebase has intra-day refreshes)
20150202, LS,   F22438, add NoteTime
*/

    set nocount on

    exec etlsp_StagingIndex_Carebase

    if object_id('[db-au-cba].dbo.cbNote') is null
    begin

        create table [db-au-cba].dbo.cbNote
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [UserKey] nvarchar(35) null,
            [NoteKey] nvarchar(20) not null,
            [CaseNo] nvarchar(15) null,
            [UserID] nvarchar(30) null,
            [NoteID] int not null,
            [UserName] nvarchar(55) null,
            [CreateDate] datetime null,
            [CreateTime] datetime null,
            [CreateTimeUTC] datetime null,
            [NoteType] nvarchar(20) null,
            [IsIncluded] bit null,
            [IsMBFSent] bit null,
            [Notes] nvarchar(max) null,
            [NoteCode] nvarchar(5) null,
            [IsDeleted] bit null,
            [NoteTime] datetime null,
            [NoteTimeUTC] datetime null
        )

        create clustered index idx_cbNote_BIRowID on [db-au-cba].dbo.cbNote(BIRowID)
        create nonclustered index idx_cbNote_CaseKey on [db-au-cba].dbo.cbNote(CaseKey) include(NoteCode,NoteKey,CreateDate,CreateTime,NoteTime)
        create nonclustered index idx_cbNote_CaseNo on [db-au-cba].dbo.cbNote(CaseNo,CountryKey)
        create nonclustered index idx_cbNote_CreateDate on [db-au-cba].dbo.cbNote(CreateDate,CountryKey)
        create nonclustered index idx_cbNote_NoteCode on [db-au-cba].dbo.cbNote(NoteCode,CaseNo) include (UserID,UserName,CreateDate,CreateTimeUTC,CaseKey,CreateTime)
        create nonclustered index idx_cbNote_NoteID on [db-au-cba].dbo.cbNote(NoteID)
        create nonclustered index idx_cbNote_NoteKey on [db-au-cba].dbo.cbNote(NoteKey)
        create nonclustered index idx_cbNote_NoteType on [db-au-cba].dbo.cbNote(NoteType,CaseNo)

    end

    if object_id('tempdb..#cbNote') is not null
        drop table #cbNote

    select
        'AU' CountryKey,
        isnull(left('AU-' + CASE_NO, 20), '') CaseKey,
        left('AU-' + AC, 35) UserKey,
        left('AU-' + convert(varchar, ROWID), 20) NoteKey,
        CASE_NO CaseNo,
        AC UserID,
        ROWID NoteID,
        UserName,
        convert(date, dbo.xfn_ConvertUTCtoLocal(CREATED_DT, 'AUS Eastern Standard Time')) CreateDate,
        dbo.xfn_ConvertUTCtoLocal(CREATED_DT, 'AUS Eastern Standard Time') CreateTime,
        CREATED_DT CreateTimeUTC,
        nt.DESCRIPTION NoteType,
        cn.TYPE NoteCode,
        case
            when INCLUDE = 'Y' then 1
            else 0
        end IsIncluded,
        case
            when MBFSENT = 'Y' then 1
            else 0
        end IsMBFSent,
        Notes,
        dbo.xfn_ConvertUTCtoLocal(NOTE_DATE, 'AUS Eastern Standard Time') NoteTime,
        NOTE_DATE NoteTimeUTC
    into #cbNote
    from
        carebase_CCN_CASENOTE_aucm cn
        left join carebase_UNT_NOTETYPE_aucm nt on
            nt.CODE = cn.TYPE
        outer apply
        (
            select top 1
                PREF_NAME + ' ' + SURNAME UserName
            from
                carebase_ADM_USER_aucm u
            where
                u.USERID = cn.AC
        ) o

    begin transaction cbNote

    begin try

        delete
        from
            [db-au-cba].dbo.cbNote
        where
            NoteKey in
            (
                select
                    left('AU-' + convert(varchar, ROWID), 20) collate database_default
                from
                    carebase_CCN_CASENOTE_aucm
            )

        insert into [db-au-cba].dbo.cbNote with(tablock)
        (
            CountryKey,
            CaseKey,
            UserKey,
            NoteKey,
            CaseNo,
            UserID,
            NoteID,
            UserName,
            CreateDate,
            CreateTime,
            CreateTimeUTC,
            NoteType,
            NoteCode,
            IsIncluded,
            IsMBFSent,
            Notes,
            NoteTime,
            NoteTimeUTC
        )
        select
            CountryKey,
            CaseKey,
            UserKey,
            NoteKey,
            CaseNo,
            UserID,
            NoteID,
            UserName,
            CreateDate,
            CreateTime,
            CreateTimeUTC,
            NoteType,
            NoteCode,
            IsIncluded,
            IsMBFSent,
            Notes,
            NoteTime,
            NoteTimeUTC
        from
            #cbNote

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbNote

        exec syssp_genericerrorhandler 'cbNote data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbNote

end


GO
