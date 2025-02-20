USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0600]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rptsp_rpt0600] 
    @Country varchar(2) = 'AU',
    @GroupName varchar(50) = '',
    @EndOfDateRange varchar(30) = 'Today',
    @PointInTime date = null,
    @OutstandingBase varchar(20) = 'Estimate'

as
begin
/****************************************************************************************************/
--  Name:           rptsp_rpt0600
--  Author:         Leonardus S
--  Date Created:   20141117
--  Description:    This stored procedure returns outstanding claims at specified date.
--  Parameters:    
--                  @CountryKey
--                  @GroupName
--                  @EndOfDateRange
--                  @PointInTime
--                  @OutstandingBase
--  
--  Change History: 20141117 - LS - Created
--                  20141118 - LS - claims.net <-> e5 bug, a section may have a missing estimate history
--                  20141119 - LS - filter creation date to be prior to reference date
--                                  reinstate estimate cross apply
--                  20141205 - LS - make e5 work type filter the same as corrected estimate
--                  20150114 - LS - add DiariseToDate & Group
--                  20150209 - LS - F22937, add assigned user
--                  20150217 - LS - F23177, enable sensing non claims.net deleted data
--                  20150424 - LS - F24207, add option to based the outstanding status (Estimate/Recovery)
--                  20151006 - LS - e5 v3, change work tpe filter
--                  20160412 - LS - T22358
--                                  use clmClaimEstimateMovement & clmClaimPaymentMovement to replace estimate & payment
--
/****************************************************************************************************/
--uncomment to debug
--declare
--    @Country varchar(3),
--    @GroupName varchar(50),
--    @EndOfDateRange varchar(30),
--    @PointInTime date,
--    @OutstandingBase varchar(20)
--select
--    @Country = 'AU',
--    @EndOfDateRange = 'Today'

    set nocount on
    
    /* get date */
    if @EndOfDateRange <> '_User Defined' or @PointInTime is null
        select 
            @PointInTime = EndDate
        from 
            vDateRange
        where 
            DateRange = @EndOfDateRange

    set @PointInTime = isnull(@PointInTime, getdate())

    if object_id('tempdb..#claimwithestimate') is not null
        drop table #claimwithestimate

    select distinct
        cl.ClaimKey
    into #claimwithestimate
    from
        clmClaim cl
        cross apply
        (
            select 
                sum(EstimateMovement) Estimate,
                sum(RecoveryEstimateMovement) RecoveryEstimate
            from
                clmClaimEstimateMovement cem
            where
                cem.ClaimKey = cl.ClaimKey and
                EstimateDate < dateadd(day, 1, @PointInTime)
        ) cem
        left join penOutlet o on
            o.OutletKey = cl.OutletKey and
            o.OutletStatus = 'Current'
    where
        (
            (
                @OutstandingBase = 'Estimate' and
                isnull(cem.Estimate, 0) <> 0 
            ) or
            (
                @OutstandingBase = 'Recovery' and
                (
                    isnull(cem.Estimate, 0) <> 0 or
                    isnull(cem.RecoveryEstimate, 0) <> 0 
                )
            )
        ) and
        cl.CountryKey = @Country and
        cl.CreateDate < dateadd(day, 1, @PointInTime) and
        (
            isnull(@GroupName, '') = '' or
            o.OutletKey is null or
            o.GroupName = @GroupName
        )

    if object_id('tempdb..#claimoutstanding') is not null
        drop table #claimoutstanding

    select 
        cl.OutletKey,
        cl.ClaimKey,
        cl.ClaimNo,
        cl.CreateDate RegisterDate,
        cl.ReceivedDate,
        cl.PolicyNo PolicyNumber,
        cl.PolicyIssuedDate IssueDate,
        cs.SectionKey,
        isnull(cs.SectionDescription, cs.SectionCode) Section,
        cem.EstimateDate,
        isnull(cem.EstimateValue, 0) EstimateValue,
        isnull(cem.RecoveryEstimateValue, 0) RecoveryEstimateValue
    into #claimoutstanding
    from
        clmClaim cl
        inner join #claimwithestimate t on
            t.ClaimKey = cl.ClaimKey
        inner join clmSection cs on
            cs.ClaimKey = cl.ClaimKey
        cross apply
        (
            select
                max(cem.EstimateDate) EstimateDate,
                sum(cem.EstimateMovement) EstimateValue,
                sum(cem.RecoveryEstimateMovement) RecoveryEstimateValue
            from
                clmClaimEstimateMovement cem
            where
                cem.SectionKey = cs.SectionKey and
                EstimateDate < dateadd(day, 1, @PointInTime)
        ) cem
        
    if object_id('tempdb..#claim') is not null
        drop table #claim

    select 
        cl.OutletKey,
        cl.ClaimKey,
        cl.ClaimNo,
        cl.RegisterDate,
        cl.ReceivedDate,
        cl.PolicyNumber,
        cl.IssueDate,
        pcl.ClaimStatus,
        pcls.StatusChangeDate,
        cl.Section,
        cl.EstimateValue,
        cl.RecoveryEstimateValue,
        isnull(cpm.Paid, 0) Paid,
        isnull(cpm.Recovered, 0) Recovered,
        cl.EstimateDate,
        cpm.LastPayment,
        datediff(day, pcls.StatusChangeDate, @PointInTime) + 1 ClaimStatusElapsed
    into #claim
    from
        #claimoutstanding cl
        outer apply 
        (
            select top 1 
                pcl.StatusDesc ClaimStatus
            from
                clmAuditClaim pcl
            where
                pcl.ClaimKey = cl.ClaimKey and
                pcl.AuditDateTime < dateadd(day, 1, @PointInTime)
            order by
                pcl.AuditDateTime desc
        ) pcl
        outer apply
        (
            select 
                min(pcls.AuditDateTime) StatusChangeDate
            from
                clmAuditClaim pcls
            where
                pcls.ClaimKey = cl.ClaimKey and
                pcls.AuditDateTime < dateadd(day, 1, @PointInTime) and
                pcls.StatusDesc = pcl.ClaimStatus and
                pcls.AuditDateTime >= 
                isnull(
                    (
                        select top 1 
                            r.AuditDateTime
                        from 
                            clmAuditClaim r
                        where 
                            r.ClaimKey = cl.ClaimKey and
                            r.StatusDesc <> pcl.ClaimStatus
                        order by 
                            r.AuditDateTime desc
                    ),
                    pcls.AuditDateTime
                )
        ) pcls
        cross apply
        (
            select
                max(cpm.PaymentDate) LastPayment,
                sum(cpm.PaymentMovement) Paid,
                sum(cpm.RecoveryPaymentMovement) Recovered
            from
                clmClaimPaymentMovement cpm
            where
                cpm.SectionKey = cl.SectionKey and
                PaymentDate < dateadd(day, 1, @PointInTime)
        ) cpm

    --break down e5 queries to smaller chunks
    if object_id('tempdb..#claime5') is not null
        drop table #claime5

    select 
        cl.OutletKey,
        cl.ClaimNo,
        cl.RegisterDate,
        cl.ReceivedDate,
        cl.PolicyNumber,
        cl.IssueDate,
        cl.ClaimStatus,
        cl.StatusChangeDate,
        cl.Section,
        cl.EstimateValue,
        cl.RecoveryEstimateValue,
        cl.Paid,
        cl.Recovered,
        cl.EstimateDate,
        cl.LastPayment,
        cl.ClaimStatusElapsed,
        e5.e5ID,
        e5.e5Reference,
        e5.e5Status,
        e5.e5DiariseToDate,
        e5.e5AssignedUser
    into #claime5
    from
        #claim cl
        outer apply
        (
            select top 1 
                w.Work_ID e5ID,
                w.Reference e5Reference,
                w.DiarisedToDate e5DiariseToDate,
                we.StatusName e5Status,
                w.AssignedUser e5AssignedUser
            from
                e5Work_v3 w
                inner join e5WorkEvent_v3 we on
                    we.Work_Id = w.Work_ID
            where
                w.ClaimKey = cl.ClaimKey and
                --make filter the same as corrected estimate
                w.WorkType like '%claim%' and
                --(
                --    w.WorkType like '%claim%' or
                --    w.WorkType like 'RN Review%' or
                --    w.WorkType like 'CO Medical%'
                --) and
                w.CreationDate < dateadd(day, 1, @PointInTime) and
                we.EventDate < dateadd(day, 1, @PointInTime)
            order by
                we.EventDate desc
        ) e5
        
    select
        ClaimNo,
        RegisterDate,
        ReceivedDate,
        PolicyNumber,
        IssueDate,
        ClaimStatus,
        StatusChangeDate,
        Section,
        EstimateValue,
        RecoveryEstimateValue,
        Paid,
        Recovered,
        EstimateDate,
        LastPayment,
        ClaimStatusElapsed,
        e5Reference,
        e5AssignedUser,
        e5Status,
        e5DiariseToDate,
        ce5.e5StatusDate,
        pe5.e5PreviousStatus,
        @PointInTime ReferenceDate,
        jv.JVCode,
        jv.JVDescription
    from
        #claime5 cl
        outer apply
        (
            select top 1 
                min(we.EventDate) e5StatusDate
            from
                e5WorkEvent_v3 we 
            where
                we.Work_Id = cl.e5ID and
                we.EventDate < dateadd(day, 1, @PointInTime) and
                we.EventDate >=
                isnull(
                    (
                        select top 1 
                            r.EventDate
                        from 
                            e5WorkEvent_v3 r
                        where 
                            r.Work_Id = we.Work_Id and
                            r.StatusName <> we.StatusName
                        order by 
                            r.EventDate desc
                    ),
                    we.EventDate
                )
        ) ce5
        outer apply
        (
            select top 1 
                we.StatusName e5PreviousStatus
            from
                e5WorkEvent_v3 we 
            where
                we.Work_Id = cl.e5ID and
                we.EventDate < ce5.e5StatusDate
            order by
                we.EventDate desc
        ) pe5
        outer apply
        (
            select top 1 
                jv.JVCode,
                jv.JVDescription
            from
                vpenOutletJV jv
            where
                jv.OutletKey = cl.OutletKey 
        ) jv

end
GO
