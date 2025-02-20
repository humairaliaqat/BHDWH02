USE [db-au-cba]
GO
/****** Object:  View [dbo].[vCBAuditCaseFirstFlag]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vCBAuditCaseFirstFlag] 
as
select 
    CaseKey,
    FirstClosedID,
    FirstReopenedID
from
    cbCase cc
    outer apply
    (
        select
            min(BIRowID) FirstClosedID
        from
            cbAuditCase acc
        where
            acc.CaseKey = cc.CaseKey and
            isClosed = 1
    ) fc
    outer apply
    (
        select
            min(BIRowID) FirstReopenedID
        from
            cbAuditCase acc
        where
            acc.CaseKey = cc.CaseKey and
            isReopened = 1
    ) fr
GO
