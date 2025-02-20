USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0544]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[rptsp_rpt0544]
    @Country varchar(3),
    @ReportingPeriod varchar(30),
    @StartDate varchar(10) = null,
    @EndDate varchar(10) = null
    
as
begin

/****************************************************************************************************/
--  Name:           rptsp_rpt0544
--  Author:         Leonardus S
--  Date Created:   20140417
--  Description:    This stored procedure returns claims received during a specified period 
--                  with their online claim & e5 classification
--  Parameters:    
--                  @Country, only relevant to AU at the moment
--                  @ReportingPeriod
--                  @StartDate
--                  @EndDate
--  
--  Change History: 20140417 - LS - Created
--                  20140428 - LS - clean up, fix classificaion criterias
--                                  fix lodged by, CRM info have higher precedence than B2B login
--                  20140811 - LS - add agency code and policy no
--                                  lookup corporate too
--                  20141022 - LS - F22221, add product
--                  20150807 - LS - T18340, add pending document flags
--					20151211 - LT - bug fix, added convert(varchar(50),q.PolicyNo) to the corpQuotes join with clmClaim.PolicyNo
--
/****************************************************************************************************/

--uncomment to debug  
--declare 
--    @Country varchar(3),
--    @ReportingPeriod varchar(30),
--    @StartDate varchar(10),
--    @EndDate varchar(10)  
--select   
--    @Country = 'AU',
--    @ReportingPeriod = 'Current Month',
--    @StartDate = null,   
--    @EndDate = null  

    set nocount on  
  
    declare @rptStartDate datetime  
    declare @rptEndDate datetime  
  
    /* get reporting dates */  
    if @ReportingPeriod = '_User Defined'  
        select   
            @rptStartDate = @StartDate,   
            @rptEndDate = @EndDate  
  
    else  
        select   
            @rptStartDate = StartDate,   
            @rptEndDate = EndDate  
        from   
            dbo.vDateRange  
        where   
            DateRange = @ReportingPeriod  

    select 
        cl.ClaimNo,
        isnull(p.JVCode, co.JVCode) JVCode,
		--F27201 - Adjust to show the Group Name instead of JV when the JV = 'AAA'
        CASE isnull(p.JVDescription, co.JVDescription) WHEN 'AAA' THEN isnull(p.GroupName, co.GroupName) ELSE isnull(p.JVDescription, co.JVDescription) END JV,
        cl.ReceivedDate,
        cb.BenefitDesc,
        cs.EstimateValue,
        isnull(cp.Paid, 0) Paid,
        cl.OnlineClaim,
        case
            when cl.OnlineClaim = 0 then 'Offline'
            when isnull(cl.OnlineAlpha, '') = '' then 'Customer'
            else isnull(crm.CRMUser, cl.OnlineAlpha + isnull(' (' + u.Consultant + ')', ''))
        end OnlineBy,
        case
            when w.StatusName in ('Active', 'Diarised') then 1
            else 0
        end ActiveOrDiarised,
        case
            when FirstWorkType = 'Fast Track Claim' then 1
            else 0
        end FastTrack,
        case
            when isnull(FirstWorkType, '') not in ('Fast Track Claim', 'CO Medical') then 1
            else 0
        end GeneralClaim,
        case
            when FirstWorkType in ('CO Medical') then 1
            else 0
        end COMedical,
        case
            when FirstWorkType = 'Fast Track Claim' and w.WorkType = 'Fast Track Claim' and w.StatusName not in ('Active', 'Diarised') then 1
            else 0
        end FTAssessed,
        case
            when FirstWorkType = 'Fast Track Claim' and w.WorkType = 'Fast Track Claim' and w.StatusName in ('Active', 'Diarised') then 1
            else 0
        end FTDiarised,
        case
            when FirstWorkType = 'Fast Track Claim' and w.WorkType not in ('Fast Track Claim', 'CO Medical') then 1
            else 0
        end FTGeneral,
        case
            when FirstWorkType = 'Fast Track Claim' and w.WorkType in ('CO Medical') then 1
            else 0
        end FTCOMedical,
        case
            when FirstWorkType = 'Fast Track Claim' and w.WorkType not in ('Fast Track Claim') then LastClassify
            else ''
        end Reindex,
        isnull(HadPendingDocument, 0) HadPendingDocument,
        case
            when isnull(HadPendingDocument, 0) = 1 and isnull(HadAssessmentOutcome, 0) = 1 then 1
            else 0
        end PendingDocumentAssessed,
        w.StatusName,
        @rptStartDate StartDate,
        @rptEndDate EndDate,
        cl.AgencyCode,
        cl.PolicyNo,
        cl.PolicyProduct
    from
        clmClaim cl
        outer apply
        (
            select top 1 
                pt.PolicyNumber,
                jv.JVCode,
                jv.JVDescription,
				o.GroupName
            from
                penPolicyTransSummary pt
                inner join penOutlet o on
                    o.OutletAlphaKey = pt.OutletAlphaKey and
                    o.OutletStatus = 'Current'
                inner join vpenOutletJV jv on
                    jv.OutletKey = o.OutletKey
            where
                pt.PolicyTransactionKey = cl.PolicyTransactionKey
        ) p
        outer apply
        (
            select top 1 
                jv.JVCode,
                jv.JVDescription,
				O.GroupName
            from
                corpQuotes q
                inner join penOutlet o on
                    o.CountryKey = cl.CountryKey and
                    o.AlphaCode = q.AgencyCode and
                    o.OutletStatus = 'Current'
                inner join vpenOutletJV jv on
                    jv.OutletKey = o.OutletKey
            where
                convert(varchar(50),q.PolicyNo) = cl.PolicyNo and
                q.CountryKey = cl.CountryKey
        ) co
        left join clmSection cs on
            cs.ClaimKey = cl.ClaimKey
        left join clmBenefit cb on
            cb.BenefitSectionKey = cs.BenefitSectionKey
        outer apply
        (
            select 
                sum(PaymentAmount) Paid
            from
                clmPayment cp
            where
                cp.PaymentStatus in ('PAID', 'RECY') and
                cp.SectionKey = cs.SectionKey
        ) cp
        outer apply
        (
            select top 1 
                u.FirstName + ' ' + u.LastName Consultant
            from
                penUser u
                inner join penOutlet o on
                    o.OutletStatus = 'Current' and
                    o.OutletKey = u.OutletKey
            where
                u.UserStatus = 'Current' and
                u.Login = cl.OnlineConsultant and
                o.AlphaCode = cl.OnlineAlpha
        ) u
        outer apply
        (
            select top 1 
                cu.FirstName + ' ' + cu.LastName CRMUser
            from
                penCRMUser cu
            where
                cu.CountryKey = cl.CountryKey and
                cu.UserName = cl.OnlineConsultant
        ) crm
        outer apply
        (
            select top 1 
                1 HadPendingDocument
            from
                clmUploadedDocuments ud
            where
                ud.ClaimKey = cl.ClaimKey and
                MissingReason = 'Will provide later'
        ) ud
        outer apply
        (
            select top 1 
                w.WorkType,
                isnull(FirstWorkType, w.WorkType) FirstWorkType,
                w.StatusName,
                LastClassify,
                HadAssessmentOutcome
            from
                e5Work w
                outer apply
                (
                    select top 1 
                        c.Name FirstWorkType
                    from
                        e5WorkActivity wa
                        inner join e5WorkActivityProperties wap on
                            wap.WorkActivity_ID = wa.ID
                        inner join [db-au-stage]..e5_Category2_v3 c on
                            c.Id = convert(int, wap.PropertyValue)
                    where
                        wa.Work_ID = w.Work_ID and
                        CategoryActivityName = 'Classify Claim' and
                        wap.Property_ID = 'Category2_Id'
                    order by 
                        wa.SortOrder
                ) fwa
                outer apply
                (
                    select top 1 
                        wa.CompletionUser LastClassify
                    from
                        e5WorkActivity wa
                    where
                        wa.Work_ID = w.Work_ID and
                        CategoryActivityName = 'Classify Claim'
                    order by SortOrder desc
                ) lwa
                outer apply
                (
                    select top 1 
                        1 HadAssessmentOutcome
                    from
                        e5WorkActivity wa
                    where
                        wa.Work_ID = w.Work_ID and
                        CategoryActivityName = 'Assessment Outcome' and
                        wa.CompletionDate is not null
                ) ao
            where
                w.ClaimKey = cl.ClaimKey and
                (
                    w.WorkType like '%claim%'
                )
            order by w.CreationDate
        ) w
    where
        cl.CountryKey = @Country and
        cl.ReceivedDate >= @rptStartDate and
        cl.ReceivedDate <  dateadd(day, 1, @rptEndDate) 

end
GO
