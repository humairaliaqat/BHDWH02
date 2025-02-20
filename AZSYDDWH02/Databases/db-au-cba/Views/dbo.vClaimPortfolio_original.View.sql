USE [db-au-cba]
GO
/****** Object:  View [dbo].[vClaimPortfolio_original]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[vClaimPortfolio_original]
as


/****************************************************************************************************/
--  Name:          vClaimPortfolio
--  Author:        Leonardus Setyabudi
--  Date Created:  20150114
--  Description:   This view captures claims and e5 statistics
--
--  Change History: 20150114 - LS - Created
--                  20150527 - LT - TFS 16596 - Added [Is Reactivated] flag
--                                  Reactivation by ActivationEventProvider where the last event is
--                                  'Diarised - Awaiting Further Information'
--                                  Added [Group Type] column
--                                  Added [Declined Count] column
--                                  Added 'Medical Review' work type
--                                  Added FirstMedicalReviewer column
--                  20150603 - LT - TFS 16867 - Added the following columns/metrics:
--                                  AssignedDate,
--                                  PreviousAssignee,
--                                  ReAssignmentCount
--                  20150623 - LS - Absolute Age, change this to age as at completion date if completed
--                    20150609 - LT - TFS 16586 - Amended First Medical Review logic
--                  20150729 - LS - remove +1 from absolute age
--                                  check status for absolute age
--                                  active Medical Review
--                  20150804 - LS - remove +1 from TICS
--                  20150805 - LS - T18355, add last MR asignee
--                  20150825 - LS - check 'future' receipt date
--                  20150914 - LS - merge v3
--                  20151006 - LS - exclude artificial migration events
--                                  only take the first change work status (e.g. ignore active - active due to migration)
--                  20151009 - LS - e5 event went directly to active, cater this in cws
--                  20151019 - LS - new event detail for MR, Diarised - Referred to Medical
--                                  svc-e5-prd-services is another exception that changes status out of chronological order
--                  20151201 - LS - exclude e5 Launch Service, svc-e5-prd-services Merge/CWS activities from working days
--                  20151202 - LS - INC0000089, add online claim flag
--                                  combine [Approve Count] & [Denied Count] in one single sub-query
--                  20151207 - LS - Ryan K, [Active Medical Review] should be only active, not (active, diarised)
--                  20160801 - SD - Brad Pinkney, Addition of Claim type for each calim[Can be seen in e5 Work Properties in e5 system]
--                  20160808 - LL - experimental MDM code, this slows things a bit. will do a proper implementation later on
--                  20160818 - LL - replace experimental MDM code with enterprise MDM
--                  20160901 - LL - enterprise bit
--                  20170330 - LL - bring in enterprise score and comment
--					20171109 - LT - INC0048990, added Underwriter column to view.
--					20181029 - YY - REQ570, add Super Group Name column to view.
--
--
/****************************************************************************************************/


select
    w.Country,
	uw.Underwriter,
    w.ClaimKey,
    isnull(w.AssignedUser, 'Unassigned') [Assigned User],
    isnull([Team Leader], 'Unassigned') [Team Leader],
    w.StatusName [Status],
    cws.[Status Change Date],
    w.SLAExpiryDate [Due Date],
    convert(date, w.CompletionDate) [Completion Date],
    w.ClaimNumber [Claim Number],
    w.Reference [e5 Reference],
    w.WorkType [Work Type],
    w.GroupType [Group Type],
    cl.PolicyNo [Policy Number],
    o.GroupName [Client],
    [Customer Name],
    cl.ReceivedDate [Date Received],
    cl.CreateDate [Date Registered],
    case
        when w.StatusName = 'Complete' then datediff(day, crd.ReceiptDate, isnull(convert(date, w.CompletionDate), getdate()))
        else datediff(day, crd.ReceiptDate, convert(date, getdate()))
    end [Absolute Age],
    datediff(day, rd.[TICS Reference Date], getdate()) -
    (
        select
            count(d.[Date])
        from
            Calendar d
        where
            d.[Date] >= rd.[TICS Reference Date] and
            d.[Date] <  dateadd(day, 1, convert(date, getdate())) and
            (
                d.isHoliday = 1 or
                d.isWeekEnd = 1
            )
    ) [Time in current status],
    case
        when w.StatusName = 'Complete' then datediff(day, crd.ReceiptDate, convert(date, w.CompletionDate))
        else 0
    end [Claim Lifespan],
    isnull(cep.[Current Estimate], 0) [Current Estimate],
    isnull(cep.[Current Payment], 0) [Current Payment],
    isnull(cep.[Recovery Estimate], 0) [Recovery Estimate],
    case
        when ClaimCount > 0 then 'Y'
        else 'N'
    end [Check Existing Claims],
    isnull(ce.EventDesc, '') [Claim Description],
    case
        when isnull(ce.[Customer Care Case], '') = '' then 'N/A'
        else ce.[Customer Care Case]
    end [Customer Care Case],
    ro.[Reopen Count],
    dr.[Diarised Count],
    isnull(mr.[Medical Review], 0) [Medical Review],
    isnull(mr.[Active Medical Review], 0) [Active Medical Review],
    [Active Medical Review Reference],
    [Active Medical Review Asignee],
    case
        when isnull(ra.[Reactivated Count],0) = 0 then 'N'
        when isnull(ra.[Reactivated Count],0) > 0 then 'Y'
    end as [Is Reactivated],
    cd.[Declined Count] ,
    mrn.[First Medical Reviewer],
    w.AssignedDate as [Assigned Date],
    isnull(pa.[Previous Assignee], '') [Previous Assignee],
    isnull(rea.[ReAssignment Count], 0) [ReAssignment Count],
    cl.PolicyProduct ProductCode,
    wdays.ActiveDays,
    wdays.DiarisedDays,
    wdays.ActiveBusinessDays,
    wdays.DiarisedBusinessDays,
    cd.[Approved Count],
    case
        when cl.OnlineClaim = 1 then 'Online Claim'
        else 'Paper Form'
    end LodgementType,
    clmtyp.ClaimType [Claim Type],
    mdmc.CustomerID AssociatedCustomerID,

    --,
    --mdm.Association,
    --mdm.TotalClaimCount,
    --mdm.TotalPolicyCount,
    mdmc.Score,
    mdmc.Comment,
	o.SuperGroupName [Super Group]    --YY 20181029 add Super Group Name
from
    e5Work w
    inner join clmClaim cl on
        cl.ClaimKey = w.ClaimKey
    cross apply
    (
        select
            case
                when cl.ReceivedDate is null then cl.CreateDate
                when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
                else cl.ReceivedDate
            end ReceiptDate
    ) crd
    left join penOutlet o on
        o.OutletKey = cl.OutletKey and
        o.OutletStatus = 'Current'
    outer apply
    (
        select top 1
            convert(varchar, CaseID) [Customer Care Case],
            EventDesc
        from
            clmEvent ce
        where
            ce.ClaimKey = cl.ClaimKey
    ) ce
    outer apply
    (
        select top 1
            case
                when isnull(cn.Title, '') <> '' then cn.Title + ' '
                else ''
            end +
            case
                when isnull(cn.Firstname, '') <> '' then cn.Firstname + ' '
                else ''
            end +
            case
                when isnull(cn.Surname, '') <> '' then cn.Surname
                else ''
            end [Customer Name],
            isnull(cn.Firstname, '') [Customer First Name]
        from
            clmName cn
        where
            cn.ClaimKey = cl.ClaimKey
        order by
            cn.isPrimary desc
    ) cn
    outer apply
    (
        select top 1
            we.EventDate [Status Change Date]
        from
            e5WorkEvent we
            outer apply
            (
                select top 1
                    pwe.StatusName PreviousStatus
                from
                    e5WorkEvent pwe
                where
                    pwe.Work_ID = w.Work_ID and
                    pwe.EventDate < we.EventDate
                order by
                    pwe.EventDate desc
            ) pwe
        where
            we.Work_Id = w.Work_ID and
            (
                we.EventName = 'Changed Work Status'
                or
                (
                    we.EventName = 'Saved Work' and
                    we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                )
            )

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            ) and
            we.StatusName <> isnull(PreviousStatus, '')

        order by
            we.EventDate desc
    ) cws
    outer apply
    (
        select
            sum(EstimateValue) [Current Estimate],
            sum(RecoveryEstimateValue) [Recovery Estimate],
            sum(isnull([Current Payment], 0)) [Current Payment]
        from
            clmSection cs
            outer apply
            (
                select
                    sum(PaymentAmount) [Current Payment]
                from
                    clmPayment cp
                where
                    cp.ClaimKey = cl.ClaimKey and
                    cp.SectionKey = cs.SectionKey and
                    cp.isDeleted = 0 and
                    cp.PaymentStatus = 'PAID'
            ) cp
        where
            cs.ClaimKey = cl.ClaimKey and
            cs.isDeleted = 0
    ) cep
    outer apply
    (
        select
            count(distinct ecl.ClaimKey) - 1 ClaimCount,
            min(pt.PolicyKey) PolicyKey
        from
            penPolicyTransSummary pt
            inner join penPolicyTransSummary opt on
                opt.PolicyKey = pt.PolicyKey
            inner join clmClaim ecl on
                ecl.PolicyTransactionKey = opt.PolicyTransactionKey
        where
            pt.PolicyTransactionKey = cl.PolicyTransactionKey
    ) ecl
	outer apply					--get underwriter
	(
		select top 1
					case 
						when pt.CompanyKey = 'TIP' and (p.IssueDate < '2017-06-01' OR (o.AlphaCode in ('APN0004', 'APN0005') and p.IssueDate < '2017-07-01')) then 'TIP-GLA'
						when pt.CompanyKey = 'TIP' and (p.IssueDate >= '2017-06-01' OR (o.AlphaCode in ('APN0004','APN0005') and p.IssueDate >= '2017-07-01')) then 'TIP-ZURICH'
						when pt.CountryKey in ('AU', 'NZ') and p.IssueDate >= '2009-07-01' and p.IssueDate < '2017-06-01' then 'GLA'
						when pt.CountryKey in ('AU', 'NZ') and p.IssueDate >= '2017-06-01' then 'ZURICH' 
						when pt.CountryKey in ('AU', 'NZ') and pt.IssueDate <= '2009-06-30' then 'VERO' 
						when pt.CountryKey in ('UK') and p.IssueDate >= '2009-09-01' and p.IssueDate < '2017-07-01' then 'ETI' 
						when pt.CountryKey in ('UK') and p.IssueDate >= '2017-07-01' then 'ERV'
						when pt.CountryKey in ('UK') and p.IssueDate < '2009-09-01' then 'UKU' 
						when pt.CountryKey in ('MY', 'SG') then 'ETIQA' 
						when pt.CountryKey in ('CN') then 'CCIC' 
						when pt.CountryKey in ('ID') then 'Simas Net' 
						when pt.CountryKey in ('US') then 'AON'
						else 'OTHER' 
					end as Underwriter
		from
			penPolicy p
			inner join penPolicyTransSummary pt on p.PolicyKey = pt.PolicyKey
			inner join penOutlet o on p.OutletAlphaKey = o.OutletAlphaKey and o.OutletStatus = 'Current'
		where
			pt.PolicyTransactionKey = cl.PolicyTransactionKey
	) uw
    outer apply
    (
        select top 1
            count(we.ID) [Reopen Count]
        from
            e5WorkEvent we
            cross apply
            (
                select top 1
                    r.StatusName PreviousStatus
                from
                    e5WorkEvent r
                where
                    r.Work_Id = w.Work_ID and
                    r.EventDate < we.EventDate
                order by
                    r.EventDate desc
            ) r
        where
            we.Work_Id = w.Work_ID and
            (
                we.EventName in ('Changed Work Status', 'Merged Work')
                or
                (
                    we.EventName = 'Saved Work' and
                    we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                )
            ) and
            we.StatusName = 'Active' and
            r.PreviousStatus = 'Complete'

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

    ) ro
    outer apply
    (
        select top 1
            count(we.ID) [Diarised Count]
        from
            e5WorkEvent we
        where
            we.Work_Id = w.Work_ID and
            (
                we.EventName = 'Changed Work Status'
            ) and
            we.StatusName = 'Diarised'

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

    ) dr
    outer apply                                        --re-activated count
    (
        select top 1
            count(we.ID) [Reactivated Count]
        from
            e5WorkEvent we
            cross apply
            (
                select top 1
                    r.Detail as PreviousDetail
                from
                    e5WorkEvent r
                where
                    r.Work_Id = w.Work_ID and
                    r.EventDate < we.EventDate and
                    r.EventName = 'Changed Work Status' and
                    r.Detail = 'Diarised - Awaiting Further Information'
                order by
                    r.EventDate desc
            ) r
        where
            we.Work_Id = w.Work_ID and
            we.EventUser is null and
            we.EventName = 'Changed Work Status' and
            we.StatusName = 'Active' and
            we.Detail = 'Activated' and
            r.PreviousDetail = 'Diarised - Awaiting Further Information'

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

    ) ra
    outer apply
    (
        select
            count(mr.Work_ID) [Medical Review],
            count(
                distinct
                case
                    when mr.StatusName in ('Active') then mr.Work_ID
                    else null
                end
            ) [Active Medical Review],
            min(
                case
                    when mr.StatusName in ('Active') then mr.Reference
                    else null
                end
            ) [Active Medical Review Reference]
        from
            e5Work mr
        where
            mr.WorkType = 'Medical Review' and
            mr.Parent_ID = w.Work_ID
    ) mr
    outer apply
    (
        select top 1
            we.EventUser [Active Medical Review Asignee]
        from
            e5Work w
            inner join e5WorkEvent we on
                we.Work_Id = w.Work_ID
        where
            w.Reference = mr.[Active Medical Review Reference] and
            we.EventName = 'Opened Work' and
            we.Detail = 'GetNext'

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

        order by
            we.EventDate desc
    ) mra
    outer apply
    (
        select top 1
            r.FirstMedicalReviewer [First Medical Reviewer]
        from
            e5Work mr
            cross apply
            (
                select top 1
                    r.EventUser FirstMedicalReviewer
                from
                    e5WorkEvent r
                where
                    r.Work_Id = mr.Work_ID and
                    r.Detail = 'Medical Review Decision'
                order by
                    r.EventDate
            ) r
         where
            mr.WorkType = 'Medical Review' and
            mr.ClaimKey = w.ClaimKey
        order by
            mr.CompletionDate
    ) mrn
    outer apply
    (
        select top 1
            we.EventDate [Last Status Change],
            we.Detail [Last Status Detail],
            case
                when exists
                (
                    select
                        null
                    from
                        e5WorkEvent mwe
                    where
                        mwe.Work_Id = w.Work_ID and
                        mwe.EventName = 'Merged Work' and
                        mwe.EventDate > we.EventDate and
                        mwe.EventDate < cws.[Status Change Date]

                        --migration events
                        and not
                        (
                            mwe.EventDate >= '2015-10-03' and
                            mwe.EventDate <  '2015-10-04' and
                            mwe.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
                        )

                ) then 1
                else 0
            end [Merged]
        from
            e5WorkEvent we
            outer apply
            (
                select top 1
                    pwe.StatusName PreviousStatus
                from
                    e5WorkEvent pwe
                where
                    pwe.Work_ID = w.Work_ID and
                    pwe.EventDate < we.EventDate
                order by
                    pwe.EventDate desc
            ) pwe
        where
            w.StatusName = 'Active' and
            we.Work_Id = w.Work_ID and
            (
                we.EventName = 'Changed Work Status'
                or
                (
                    we.EventName = 'Saved Work' and
                    we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                )
            ) and
            we.EventDate < cws.[Status Change Date] and
            we.StatusName <> isnull(PreviousStatus, '')

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )
        order by
            we.EventDate desc
    ) lsc
    outer apply
    (
        select
            case
                when lsc.[Last Status Detail] = 'Diarised - Referred for Medical Review' then lsc.[Last Status Change]
                when lsc.[Last Status Detail] = 'Diarised - Referred to Medical' then lsc.[Last Status Change]
                when lsc.Merged = 1 then isnull(w.SLAStartDate, cws.[Status Change Date])
                else isnull(cws.[Status Change Date], cl.CreateDate)
            end [TICS Reference Date]
    ) rd
    outer apply
    (
        select top 1
            tl.DisplayName [Team Leader]
        from
            usrLDAPTeam t
            inner join usrLDAP u on
                u.UserID = t.UserID
            inner join usrLDAP tl on
                tl.UserID = t.TeamLeaderID
        where
            u.DisplayName = w.AssignedUser
    ) tl
    outer apply
    (
        select
            count(
                distinct
                case
                    when wa.AssessmentOutcomeDescription = 'Approve' then wa.Work_ID
                    else null
                end
            ) as [Approved Count],
            count(
                distinct
                case
                    when wa.AssessmentOutcomeDescription = 'Deny' then wa.Work_ID
                    else null
                end
            ) as [Declined Count]
        from
            e5WorkActivity wa
        where
            wa.Work_Id = w.Work_ID and
            wa.CategoryActivityName = 'Assessment Outcome' and
            wa.AssessmentOutcomeDescription in ('Deny', 'Approve')
    ) cd
    outer apply
    (
        select top 1
            we.Detail [Previous Assignee]
        from
            e5WorkEvent we
        where
            we.Work_ID = w.Work_ID and
            we.EventDate < w.AssignedDate and
            we.EventName = 'Assigned Work To User' and
            w.StatusName in ('Active', 'Diarised') and
            we.Detail is not null and
            we.Detail <> w.AssignedUser

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

        order by
            EventDate desc
    ) pa
    outer apply
    (
        select
            count(we.ID) [ReAssignment Count]
        from
            e5WorkEvent we
        where
            we.Work_ID = w.Work_ID and
            we.EventDate < w.AssignedDate and
            we.EventName = 'Assigned Work To User' and
            w.StatusName in ('Active', 'Diarised') and
            w.AssignedUser is not null

            --migration events
            and not
            (
                we.EventDate >= '2015-10-03' and
                we.EventDate <  '2015-10-04' and
                we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
            )

    ) rea
    outer apply
    (
        select
            sum(
                case
                    when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
                    else 0
                end
            ) ActiveDays,
            sum(
                case
                    when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
                    else 0
                end
            ) DiarisedDays,
            sum(
                case
                    when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
                    else 0
                end
            ) ActiveBusinessDays,
            sum(
                case
                    when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
                    else 0
                end
            ) DiarisedBusinessDays
        from
            e5WorkEvent we
            outer apply
            (
                select top 1
                    r.EventDate NextChangeDate
                from
                    e5WorkEvent r
                where
                    r.Work_Id = w.Work_ID and
                    r.EventDate > we.EventDate and
                    (
                        (
                            r.EventName in ('Changed Work Status', 'Merged Work') and
                            isnull(r.EventUser, r.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
                        )
                        or
                        (
                            --e5 Launch Service may cause a case to have total (Active Days + Diarised Days) > Absolute Age
                            --this is due to [Saved Work] events with multiple [Status] occuring in same timestamp to ms
                            --part of known issue revolving online claims in e5 v2
                            r.EventName = 'Saved Work' and
                            r.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                        )
                    )
                order by
                    r.EventDate
            ) nwe
            outer apply
            (
                select
                    count(d.[Date]) OffDays
                from
                    Calendar d
                where
                    d.[Date] >= convert(date, we.EventDate) and
                    d.[Date] <  convert(date, isnull(nwe.NextChangeDate, getdate())) and
                    (
                        d.isHoliday = 1 or
                        d.isWeekEnd = 1
                    )
            ) phd
        where
            we.Work_ID = w.Work_ID and
            (
                (
                    we.EventName in ('Changed Work Status', 'Merged Work') and
                    isnull(we.EventUser, we.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
                )
                or
                (
                    we.EventName = 'Saved Work' and
                    we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                )
            ) and
            we.StatusName in ('Active', 'Diarised')
    ) wdays
    outer apply
	(
		select top 1 
			ew.CreationUser as CreatedBy,
			ew.CreationDate,
			ew.AssignedUser,
			ew.AssignedDate,
			ew.CompletionUser,
			ew.CompletionDate,
			ew.ClaimNumber,
			claimtype.ClaimType
		from
			e5Work ew
			outer apply
			(
				select top 1 
					witem.ClaimType
				from
					e5Work_v3 e5w
					inner join e5WorkProperties_v3 e5wp on e5w.Work_ID = e5wp.Work_ID
					outer apply
					(
						select top 1 Name as ClaimType
						from 
							e5WorkItems_v3
						where
							ID = e5wp.PropertyValue
					) witem
				where 
					e5wp.Property_ID = 'ClaimType' and
					e5w.Work_ID = ew.Work_ID
			) claimtype
		where
			ew.WorkType like '%claim%'
			and ew.ClaimKey = cl.ClaimKey
	) clmtyp
    outer apply
    (
        select top 1 
            mdm.CustomerID,
            isnull(mdm.ClaimScore, mdm.PrimaryScore) + isnull(mdm.SecondarySCore, 0) - isnull(bl.BlockScore, 0) Score,
            case
                when isnull(bl.BlockScore, 0) > 0 then 'BLOCKED! ' + char(10) + char(10)
                else ''
            end +
            case

                when mdm.ClaimScore >= 3000 then 'Very high risk.' + char(10)
                when mdm.ClaimScore >= 500 then 'High risk.' + char(10)
                when mdm.ClaimScore >= 10 then 'Medium risk.' + char(10)

                when mdm.PrimaryScore - isnull(bl.BlockScore, 0) >= 5000 then 'Very high risk. ' + char(10)
                when mdm.SecondaryScore >= 5000 then 'Very high risk by association. ' + char(10)
                when mdm.PrimaryScore - isnull(bl.BlockScore, 0) >= 2000 then 'High risk. ' + char(10)
                when mdm.SecondaryScore >= 2000 then 'High risk by association. ' + char(10)
                when mdm.PrimaryScore - isnull(bl.BlockScore, 0) > 750 then 'Medium risk. ' + char(10)
                when mdm.SecondaryScore > 750 then 'Medium risk by association. ' + char(10)
                else ''--'Low Risk'
            end Comment
        from
            penPolicyTransSummary pt with(nolock)
            inner join entPolicy mdmc with(nolock) on
                mdmc.PolicyKey = pt.PolicyKey
            inner join entCustomer mdm with(nolock) on
                mdm.CustomerID = mdmc.CustomerID
            outer apply
            (
                select top 1 
                    REASON,
                    9001 BlockScore
                from
                    entBlacklist bl with(nolock)
                where
                    bl.CustomerID = mdm.CustomerID
            ) bl
        where
            --don't retrieve completed claims
            w.StatusName in ('Active', 'Diarised') and
            pt.PolicyTransactionKey = cl.PolicyTransactionKey
        order by
            case
                when soundex(cn.[Customer First Name]) = soundex(mdm.CUstomerName) then -2
                when left(soundex(cn.[Customer First Name]), 2) = left(soundex(mdm.CUstomerName), 2) then -1
                else mdm.CustomerID
            end
    ) mdmc
    --outer apply
    --(
    --    select top 1 
    --        cf.CustomerID
    --    from
    --        clmClaimFlags cf
    --    where
    --        --only active AU claims
    --        cl.CountryKey = 'AU' and
    --        w.StatusName in ('Active') and
    --        mdmc.CustomerID is null and
    --        cf.ClaimKey = cl.ClaimKey
    --) cf
    --outer apply
    --(
    --    select top 1
    --        ec.CustomerID
    --    from
    --        entCustomer ec
    --    where
    --        --only active AU claims
    --        cl.CountryKey = 'AU' and
    --        w.StatusName in ('Active') and
    --        cf.CustomerID is null and
    --        ec.CustomerID in
    --        (
    --            select distinct
    --                ep.CustomerID
    --            from
    --                entPolicy ep
    --            where
    --                ep.PolicyKey = ecl.PolicyKey
    --        )
    --    order by
    --        case
    --            when ec.FirstName = [Customer First Name] then 0
    --            else 1
    --        end
    --) mdmp
    --outer apply
    --(
    --    select top 1
    --        epv.CustomerID AssociatedCustomerID,
    --        case
    --            when mdmp.CustomerID is not null then 'Policy'
    --            else 'Claim'
    --        end Association,
    --        epv.ClaimCount TotalClaimCount,
    --        epv.PolicyCount TotalPolicyCount,
    --        case
    --            when epv.SellPrice = 0 then 0.00
    --            else epv.ClaimValue / epv.SellPrice
    --        end LossRatio,
    --        isnull(epp.Comment, '') Comment
    --    from
    --        vEnterpriseProfileValue epv
    --        outer apply
    --        (
    --            select top 1 
    --                epp.Comment
    --            from
    --                vEnterpriseProfile epp
    --            where
    --                epp.CustomerID = epv.CustomerID
    --        ) epp
    --    where
    --        --only active AU claims
    --        cl.CountryKey = 'AU' and
    --        w.StatusName in ('Active') and
    --        CustomerID = coalesce(mdmc.CustomerID, cf.CustomerID, mdmp.CustomerID)
    --) mdm
where
    (
        w.WorkType like '%claim%'

        --additional child items, not sure what's the impact yet
        or w.WorkType in ('Phone Call', 'Complaints', 'Recovery', 'Investigation')

    ) and
    w.StatusName in ('Active', 'Diarised', 'Complete')















GO
