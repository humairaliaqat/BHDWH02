USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL008_e5Content_DeleteNonCBA]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL008_e5Content_DeleteNonCBA]
as
begin
	--20180928, LT, Created

    delete t
    from
		[db-au-cba].dbo.e5Work_v3 t
    where
		AgencyCode is null or
        not
        (
			Country = 'AU' and
			(
				AgencyCode like 'CB%' or
				AgencyCode like 'BW%'
			)
		)
		


    delete t
    from
        [db-au-cba].dbo.e5WorkActivity_v3 t
    where
        not exists
        (
            select
                null
            from
                [db-au-cba].dbo.e5Work_v3 r
            where
                r.Work_ID = t.Work_ID
        )

    delete t
    from
        [db-au-cba].dbo.e5WorkActivityProperties_v3 t
    where
        not exists
        (
            select
                null
            from
                [db-au-cba].dbo.e5Work_v3 r
            where
                r.Work_ID = t.Work_ID
        )


    delete t
    from
        [db-au-cba].dbo.e5WorkCaseNote_v3 t
    where
        not exists
        (
            select
                null
            from
                [db-au-cba].dbo.e5Work_v3 r
            where
                r.Work_ID = t.Work_ID
        )

    delete t
    from
        [db-au-cba].dbo.e5WorkEvent_v3 t
    where
        not exists
        (
            select
                null
            from
                [db-au-cba].dbo.e5Work_v3 r
            where
                r.Work_ID = t.Work_ID
        )

    delete t
    from
        [db-au-cba].dbo.e5WorkProperties_v3 t
    where
        not exists
        (
            select
                null
            from
                [db-au-cba].dbo.e5Work_v3 r
            where
                r.Work_ID = t.Work_ID
        )
end
GO
