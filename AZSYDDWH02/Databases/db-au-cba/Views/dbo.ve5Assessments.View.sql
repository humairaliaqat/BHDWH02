USE [db-au-cba]
GO
/****** Object:  View [dbo].[ve5Assessments]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[ve5Assessments]
as
select 
    Work_ID,
    FirstAssessmentID, 
    FirstAssessmentDate, 
    FirstAssessmentBy, 
    FirstAssessmentOutcome, 
    LastAssessmentID, 
    LastAssessmentDate, 
    LastAssessmentBy, 
    LastAssessmentOutcome, 
    FirstCompleteStatus, 
    FirstCompletedAssessmentID, 
    FirstCompletedAssessmentDate, 
    FirstCompletedAssessmentBy, 
    FirstCompletedAssessmentOutcome,
    isnull(AssessmentCount, 0) AssessmentCount
from
    e5Work w
    outer apply
    (
        select 
            count(distinct wa.ID) AssessmentCount
        from
            e5WorkActivity wa
        where
            wa.Work_ID = w.Work_ID and
            wa.CategoryActivityName = 'Assessment Outcome' and
            wa.CompletionDate is not null
    ) aoc
    outer apply
    (
        select top 1
            wa.ID FirstAssessmentID,
            wa.CompletionDate FirstAssessmentDate,
            wa.CompletionUser FirstAssessmentBy,
            ao.Name FirstAssessmentOutcome
        from
            e5WorkActivity wa
            outer apply
            (
                select top 1 
                    Name
                from
                    e5WorkItems wi
                where
                    wi.ID = wa.AssessmentOutcome
            ) ao 
        where
            wa.Work_ID = w.Work_ID and
            wa.CategoryActivityName = 'Assessment Outcome' and
            wa.CompletionDate is not null
        order by
            wa.CompletionDate
    ) fao
    outer apply
    (
        select top 1
            wa.ID LastAssessmentID,
            wa.CompletionDate LastAssessmentDate,
            wa.CompletionUser LastAssessmentBy,
            ao.Name LastAssessmentOutcome
        from
            e5WorkActivity wa 
            outer apply
            (
                select top 1 
                    Name
                from
                    e5WorkItems wi
                where
                    wi.ID = wa.AssessmentOutcome
            ) ao 
        where
            wa.Work_ID = w.Work_ID and
            wa.CategoryActivityName = 'Assessment Outcome' and
            wa.CompletionDate is not null
        order by
            wa.CompletionDate desc
    ) lao
    outer apply
    (
        select top 1 
            we.EventDate FirstCompleteStatus
        from
            e5WorkEvent we
        where
            we.Work_Id = w.Work_ID and
            we.EventName = 'Changed Work Status' and
            we.StatusName = 'Complete'
        order by
            we.EventDate
    ) fcs
    outer apply
    (
        select top 1
            wa.ID FirstCompletedAssessmentID,
            wa.CompletionDate FirstCompletedAssessmentDate,
            wa.CompletionUser FirstCompletedAssessmentBy,
            ao.Name FirstCompletedAssessmentOutcome
        from
            e5WorkActivity wa 
            outer apply
            (
                select top 1 
                    Name
                from
                    e5WorkItems wi
                where
                    wi.ID = wa.AssessmentOutcome
            ) ao 
        where
            wa.Work_ID = w.Work_ID and
            wa.CategoryActivityName = 'Assessment Outcome' and
            wa.CompletionDate is not null and
            wa.CompletionDate <= fcs.FirstCompleteStatus
        order by
            wa.CompletionDate desc
    ) fcao



GO
