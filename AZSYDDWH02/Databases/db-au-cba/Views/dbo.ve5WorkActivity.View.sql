USE [db-au-cba]
GO
/****** Object:  View [dbo].[ve5WorkActivity]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[ve5WorkActivity] as
select --top 1000
    wa.Work_ID,
    wa.ID,
    wa.CategoryActivityName,
    wa.StatusName,
    wa.CreationDate,
    wa.CreationUser,
    wa.CompletionDate,
    wa.CompletionUser,
    wa.AssignedDate,
    wa.AssignedUser,
    wa.DueDate SLAExpiryDate,
    wp.ClaimNumber ClaimNumberEntry,
    w.WorkType,
    w.GroupType,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.IsPolicyCancelled) IsPolicyCancelled,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.ClaimNumberAvailable) ClaimNumberAvailable,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.ClaimUnclassSuffInfo) ClaimUnclassSuffInfo,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.CorroIsExistingClaim) CorroIsExistingClaim,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.CorroDeterminedWorkType) CorroDeterminedWorkType,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.CorroExistingClaimLocated) CorroExistingClaimLocated,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.HaveSentCorrespondence) HaveSentCorrespondence,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.DenialDetails) DenialDetails,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.ClaimOutcome) ClaimOutcome,
    wap.ComplaintDescriptionEnter,
    wap.ComplaintsClaimNumber,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.ComplaintResponseType) ComplaintResponseType,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wap.ComplaintOutcome) ComplaintOutcome,
    (select top 1 wi.Name from e5WorkItems wi where wi.Domain = wi.Domain and wi.ID = wa.AssessmentOutcome) AssessmentOutcome
from 
    e5WorkActivity_v3 wa
    inner join e5work_v3 w on
        w.Work_ID = wa.Work_ID
    outer apply
    (
        select 
            try_convert(int, PropertyValue) ClaimNumber
        from
            e5WorkProperties_v3 wp
        where
            wp.Work_ID = w.Work_ID and
            wp.Property_ID = 'ClaimNumber'
    ) wp
    outer apply
    (
        select 
            max(case when Property_ID = 'IsPolicyCancelled' then try_convert(int, PropertyValue) else null end) IsPolicyCancelled,
            max(case when Property_ID = 'ClaimNumberAvailable' then try_convert(int, PropertyValue) else null end) ClaimNumberAvailable,
            max(case when Property_ID = 'ClaimUnclassSuffInfo' then try_convert(int, PropertyValue) else null end) ClaimUnclassSuffInfo,
            max(case when Property_ID = 'CorroIsExistingClaim' then try_convert(int, PropertyValue) else null end) CorroIsExistingClaim,
            max(case when Property_ID = 'CorroDetermineWorkType' then try_convert(int, PropertyValue) else null end) CorroDeterminedWorkType,
            max(case when Property_ID = 'CorroExistingClaimLocated' then try_convert(int, PropertyValue) else null end) CorroExistingClaimLocated,
            max(case when Property_ID = 'HaveSentCorrespondence' then try_convert(int, PropertyValue) else null end) HaveSentCorrespondence,
            max(case when Property_ID = 'DenialDetails' then try_convert(int, PropertyValue) else null end) DenialDetails,
            max(case when Property_ID = 'ClaimOutcome' then try_convert(int, PropertyValue) else null end) ClaimOutcome,
            max(case when Property_ID = 'ComplaintDescriptionEnter' then try_convert(nvarchar(255), PropertyValue) else null end) ComplaintDescriptionEnter,
            max(case when Property_ID = 'ComplaintsClaimNumber' then try_convert(nvarchar(255), PropertyValue) else null end) ComplaintsClaimNumber,
            max(case when Property_ID = 'ComplaintResponseType' then try_convert(int, PropertyValue) else null end) ComplaintResponseType,
            max(case when Property_ID = 'ComplaintOutcome' then try_convert(int, PropertyValue) else null end) ComplaintOutcome,
            max(case when Property_ID = 'AssessmentOutcome' then try_convert(int, PropertyValue) else null end) AssessmentOutcome,
            max(case when Property_ID = 'GeneralClaimAssessOutcome' then try_convert(int, PropertyValue) else null end) GeneralClaimAssessOutcome
        from
            e5WorkActivityProperties_v3 wap
        where
            wap.WorkActivity_ID = wa.ID and
            wap.Property_ID in
            (
                'IsPolicyCancelled',
                'ClaimNumberAvailable',
                'ClaimUnclassSuffInfo',
                'CorroIsExistingClaim',
                'CorroDetermineWorkType',
                'CorroExistingClaimLocated',
                'HaveSentCorrespondence',
                'DenialDetails',
                'ClaimOutcome',
                'ComplaintDescriptionEnter',
                'ComplaintsClaimNumber',
                'ComplaintResponseType',
                'ComplaintOutcome',
                'AssessmentOutcome',
                'GeneralClaimAssessOutcome'
            )
    ) wap
GO
