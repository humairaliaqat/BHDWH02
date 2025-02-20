USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactClaimActivity]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vfactClaimActivity] as
select --top 1000
    f.ActivityID, 
    convert(date, d.[Date]) DateSK, 
    f.DomainSK, 
    f.OutletSK, 
    f.AreaSK, 
    f.ProductSK, 
    f.ClaimSK, 
    f.ClaimEventSK, 
    f.ClaimKey, 
    f.PolicyTransactionKey, 
    f.e5Reference, 
    f.Activity, 
    f.CompletionDate, 
    f.CompletionUser, 
    f.ActivityOutcome, 
    f.CreateBatchID,
    isnull(ao.Name, '') Outcome
from
    factClaimActivity f 
    inner join Dim_Date as d on 
        d.Date_SK = f.Date_SK
    outer apply
    (
        select top 1 
            wi.Name
        from
            [db-au-cba]..e5WorkItems wi
        where
            wi.ID = f.ActivityOutcome
    ) ao


GO
