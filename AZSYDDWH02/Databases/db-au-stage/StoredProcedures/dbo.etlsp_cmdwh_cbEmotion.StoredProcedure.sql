USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbEmotion]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbEmotion]
as
begin
/*
20140715, LS,   TFS12109
                enlarge column width
                use transaction (as carebase has intra-day refreshes)

20160624, PZ,	TFS25277
				Change the merge method. 
				Current method will delete hostirical emotions outside of data refresh period window (currently set to last 7 days).
				Now change to "merge on Case_No and Emotion_Date".
*/

    set nocount on

    exec etlsp_StagingIndex_Carebase

    if object_id('[db-au-cba].dbo.cbEmotion') is null
    begin

        create table [db-au-cba].dbo.cbEmotion
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [CaseNo] nvarchar(15) not null,
            [EmotionDate] datetime null,
            [EmotionTimeUTC] datetime null,
            [Emotion] nvarchar(50) null,
            [Comments] nvarchar(100) null
        )

        create clustered index idx_cbEmotion_BIRowID on [db-au-cba].dbo.cbEmotion(BIRowID)
        create nonclustered index idx_cbEmotion_CaseKey on [db-au-cba].dbo.cbEmotion(CaseKey)
        create nonclustered index idx_cbEmotion_CaseNo on [db-au-cba].dbo.cbEmotion(CaseNo,CountryKey)
        create nonclustered index idx_cbEmotion_EmotionDate on [db-au-cba].dbo.cbEmotion(EmotionDate)

    end


    begin transaction cbEmotion

    begin try

		delete e
		from [db-au-cba].dbo.cbEmotion e
		inner join [db-au-stage].dbo.carebase_CST_EMOTION_aucm se on 
			e.EmotionTimeUTC = se.EM_DATE and 
			e.CaseNo collate database_default = se.CASE_NO collate database_default
        where
            CaseKey in
            (
                select
                    left('AU-' + CASE_NO, 20) collate database_default
                from
                    carebase_CMN_MAIN_aucm
            )


        insert into [db-au-cba].dbo.cbEmotion with(tablock)
        (
            CountryKey,
            CaseKey,
            CaseNo,
            EmotionDate,
            EmotionTimeUTC,
            Emotion,
            Comments
        )

        select
            'AU' as CountryKey,
            left('AU-' + CASE_NO, 20) as CaseKey,
            CASE_NO as CaseNo,
            dbo.xfn_ConvertUTCtoLocal(EM_DATE, 'AUS Eastern Standard Time') as EmotionDate,
            EM_DATE as EmotionTimeUTC,
            EM_DESC as Emotion,
            Comments
        from
            carebase_CST_EMOTION_aucm cem
            inner join carebase_EMOTIONS_aucm em on
                em.EM_ID = cem.EM_ID


    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbEmotion

        exec syssp_genericerrorhandler 'cbEmotion data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbEmotion


end


GO
