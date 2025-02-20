USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimCustomer]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_ic_dimCustomer] as
select top 100 
    ec.CustomerID,
    p.FirstPolicyDate,

    '' RiskProfile, --last
    getdate() DOB, --last
    1 DyOB, 
    'January' MOB, 
    2008 YOB,
    
    '' ProductPreference, --mode
    '' ChannelPreference, --mode
    '' DestinationGroup, --mode
    '' MarketingPreference, --last

    '' FamilyStatus, --last

    0 TotalPolicy,
    0 TotalClaim,
    0 LTMPolicy,
    0 LTMClaim,

    '' Suburb, --last
    '' PostCode, --last
    '' [State] --last
from
    [db-au-cba]..entCustomer ec
    cross apply
    (
        select top 1 
            p.IssueDate FirstPolicyDate
        from
            [db-au-cba]..entPolicy ep
            inner join [db-au-cba]..penPolicy p on
                p.PolicyKey = ep.PolicyKey
        where
            ep.CustomerID = ec.CustomerID
    ) p
GO
