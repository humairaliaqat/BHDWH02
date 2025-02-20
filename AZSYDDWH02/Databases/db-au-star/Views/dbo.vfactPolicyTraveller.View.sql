USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactPolicyTraveller]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[vfactPolicyTraveller]
as
select 
    ref.OutletReference,
    t.*,
    case
        when datediff([day], p.issuedate, p.tripstart) < -1 then -1
        when datediff([day], p.issuedate, p.tripstart) > 2000 then -1
        else datediff([day], p.issuedate, p.tripstart)
    end LeadTime
from
    factPolicyTraveller t
    --inner join factpolicytransaction as pt on
    --    pt.PolicyTransactionKey = t.PolicyTransactionKey
    inner join dimpolicy as p on 
        p.policysk = t.policysk
    cross apply
    (
        select 'Point in time' OutletReference
        union all
        select 'Latest alpha' OutletReference
    ) ref
where
    t.DateSK >= 20150101 and
    t.DateSK < (year(getdate()) + 2) * 10000 + 101






GO
