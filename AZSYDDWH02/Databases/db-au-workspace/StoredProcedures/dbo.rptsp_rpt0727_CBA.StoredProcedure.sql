USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0727_CBA]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[rptsp_rpt0727_CBA]
AS

SET NOCOUNT ON

/****************************************************************************************************/    
-- Name:   dbo.rptsp_rpt0727    
-- Author:   Atit Wajanasomboonkul    
-- Date Created: 20151208    
-- Description: This stored procedure lists missing claims from e5.    
--     Reporting period is based on job StartTime    
-- Change History: 20151208 - AW - Created    
/****************************************************************************************************/    

declare @rptStartDate smalldatetime    
declare @rptEndDate smalldatetime    

/* Hardcoding start and end dates */
set @rptStartDate = '2024-07-01'  -- Hardcoded Start Date as 1st July 2024
set @rptEndDate = GETDATE()        -- Hardcoded End Date as current date

/* Check if the temporary table exists, if so drop it */
if object_id('tempdb..#rpt0727_missingclaims') is not null 
    drop table #rpt0727_missingclaims    

/* Select data into temporary table */
select    
    ol.OnlineClaimID,    
    [db-au-cba].dbo.xfn_ConvertUTCtoLocal(ol.OnlineCreateDate,'AUS Eastern Standard Time') OnlineClaimCreateDate,    
    c.ClaimNo,    
    c.CreateDate,    
    c.PolicyNo,    
    c.DomainID,    
    e.e5Reference,    
    e.e5CreateDate,    
    e.e5Status,    
    case when c.ClaimNo is not null then 'Y' else 'N' end as inNet,    
    case when e.e5Reference is not null then 'Y' else 'N' end as ine5    
into #rpt0727_missingclaims    
from     
    [db-au-cba]..clmClaim c with(nolock)
    outer apply (
        select OnlineClaimID, UpdatedOn as OnlineCreateDate
        from [DB-CBA-PENGUINSHARP.AUST.COVERMORE.COM.AU].[CBA_CLAIMS].dbo.tblOnlineClaims
        where ClaimID = c.ClaimNo and DomainID = c.DomainID
    ) ol
    outer apply (
        select 
            Reference as e5Reference,
            CreationDate as e5CreateDate,
            StatusName as e5Status
        from
            [db-au-cba]..e5Work_v3  with(nolock)
        where ClaimKey = c.ClaimKey
    ) e
where 
    c.CreateDate >= @rptStartDate and
    c.CreateDate < dateadd(day,1,@rptEndDate) and
    c.OnlineClaim = 1 and
    e.e5Reference is null

if (select count(*) from #rpt0727_missingclaims) = 0 
    select
        convert(int,null) as OnlineClaimID,
        convert(datetime,null) as OnlineClaimCreateDate,
        convert(int,null) as ClaimNo,
        convert(datetime,null) as CreateDate,
        convert(varchar(50),null) as PolicyNo,
        convert(int,null) as DomainID,
        convert(int,null) as e5Reference,
        convert(datetime,null) as e5CreateDate,
        convert(varchar(100),null) as e5Status,
        convert(varchar(1),null) as inNet,
        convert(varchar(1),null) as ine5,        
        @rptStartDate as StartDate,
        @rptEndDate as EndDate    
else
    select
        OnlineClaimID,
        OnlineClaimCreateDate,
        ClaimNo,
        CreateDate,
        PolicyNo,
        DomainID,
        e5Reference,
        e5CreateDate,
        e5Status,
        inNet,
        ine5,            
        @rptStartDate as StartDate,
        @rptEndDate as EndDate    
from
    #RPT0727_MissingClaims


GO
