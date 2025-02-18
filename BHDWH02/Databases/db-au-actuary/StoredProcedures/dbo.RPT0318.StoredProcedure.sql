USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[RPT0318]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RPT0318] 
@ReportingPeriod varchar(30),
@StartDate date,
@EndDate date
as 

Begin

set nocount on

declare
    @rptStartDate datetime,
    @rptEndDate datetime

    if @ReportingPeriod = '_User Defined'
        select
            @rptStartDate = @StartDate,
            @rptEndDate = @EndDate

    else
        select
            @rptStartDate = StartDate,
            @rptEndDate = EndDate
        from
            [db-au-cmdwh].[dbo].vDateRange
        where
            DateRange = @ReportingPeriod


SELECT
  emcCompanies.CountryKey,
  case
    when emcCompanies.ParentCompanyName like 'Zurich%' or emcCompanies.CompanyName in ('Ace Insurance') then 'CC'
    else emcCompanies.CountryKey
end,
  emcCompanies.ParentCompanyName,
  emcCompanies.CompanyName,
  emcApplications.ApplicationID,
  emcApplications.AssessedDate,
  emcApplications.ApplicationType,
  emcApplicants.FirstName,
  emcApplicants.Surname,
  emcApplications.DepartureDate,
  emcApplications.ReturnDate,
  penOutlet.SuperGroupName,
  vpenOutletJV.JVCode,
  penOutlet.AlphaCode,
  isnull(emcApplicants.ApplicantHash, '') +
convert(varchar, emcCompanies.CompanyID) +
case
    when emcApplications.ApplicationType = 'Healix' then '1'
    else '0'
end +
isnull(vpenOutletJV.JVCode, '00') +
replace(isnull(convert(varchar(10), emcApplications.DepartureDate, 120), ''), '-', '') + 
replace(isnull(convert(varchar(10), emcApplications.ReturnDate, 120), ''), '-', '')
,
  Converted.Converted,
  case
    when emcApplications.AssessedDate is null then 'Not Assessed'
    when emcApplications.ApprovalStatus = 'Policy Denied' then  'Policy Denied'
    when emcApplications.AgeApprovalStatus = 'Denied' then  'Policy Denied'
    when emcApplications.ApprovalStatus = 'NotCovered' then 'All EMC Denied'
    when emcApplications.MedicalDeniedCount = 0 then 'All EMC Approved'
    when emcApplications.MedicalDeniedCount > 0 and emcApplications.MedicalApprovedCount > 0 then 'Approved & Denied'
    when emcApplications.MedicalApprovedCount = 0 then 'All EMC Denied'
    else 'Not Defined'
end
FROM
   [uldwh02].[db-au-cmdwh].[dbo].[emcApplicants] INNER JOIN [uldwh02].[db-au-cmdwh].[dbo].[emcApplications] ON (emcApplications.ApplicationKey=emcApplicants.ApplicationKey)
   LEFT OUTER JOIN [uldwh02].[db-au-cmdwh].[dbo].[emcCompanies] ON (emcApplications.CompanyKey = emcCompanies.CompanyKey)
   INNER JOIN [uldwh02].[db-au-cmdwh].[dbo].[Calendar] ON (emcApplications.AssessedDateOnly = Calendar.Date)
   LEFT OUTER JOIN [uldwh02].[db-au-cmdwh].[dbo].penOutlet ON (penOutlet.OutletAlphaKey=emcApplications.OutletAlphaKey)
   LEFT OUTER JOIN [uldwh02].[db-au-cmdwh].[dbo].vpenOutletJV ON (vpenOutletJV.OutletKey=penOutlet.OutletKey)
   INNER JOIN ( 
  select 
    ApplicationKey,
    isnull(ec.Converted, 0) as Converted
from
    [uldwh02].[db-au-cmdwh].[dbo].[emcApplications] e
    outer apply
    (
        select top 1
            1 Converted
        from
            [uldwh02].[db-au-cmdwh].[dbo].[penPolicyEMC] pe
        where
            pe.EMCApplicationKey = e.ApplicationKey
    ) ec

 

  )  Converted ON (emcApplications.ApplicationKey=Converted.ApplicationKey)

WHERE
  (
   Calendar.Date  > @rptStartDate and Calendar.Date < dateadd(day,1,@rptEndDate)
   AND
   emcApplicants.FirstName  NOT LIKE  '%test%'
   AND
   ( isnull(penOutlet.OutletStatus, 'Current') = 'Current'  )
  )
End

GO
