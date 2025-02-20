USE [db-au-cba]
GO
/****** Object:  View [dbo].[vCBLastUWAuditInMonth]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vCBLastUWAuditInMonth] as
select 
    cac.BIRowID,
    d.CurMonthStart,
    case
        when cac.AuditDateTime = max(cac.AuditDateTime) over (partition by d.CurMonthStart, cac.CaseKey) then 1
        else 0
    end *
    datediff(hh, cac.CreateDate, cac.AuditDateTime) / 24.00 DaysElapsed,
    case
        when cac.AuditDateTime = max(cac.AuditDateTime) over (partition by d.CurMonthStart, cac.CaseKey) then cac.UWCoverStatus
        else null
    end LastUWCoverStatusInMonth,
    case
        when cac.AuditDateTime = max(cac.AuditDateTime) over (partition by d.CurMonthStart, cac.CaseKey) then 1
        else 0
    end CaseCount,
    cn.NoteTime,
    datediff(hh, cac.CreateDate, isnull(cn.NoteTime, cac.AuditDateTime)) / 24.00 NoteDaysElapsed
from
    cbAuditCase cac
    cross apply
    (
        select
            convert(date, convert(varchar(7), cac.AuditDateTime,120) + '-01') CurMonthStart
    ) d
    outer apply
    (
        select top 1 
            cn.CreateTime NoteTime
        from
            cbNote cn
        where
            cn.CaseKey = cac.CaseKey and
            (
                (
                    cac.UWCoverStatus in ('Cover Declined', 'Limited Cover') and
                    cn.NoteCode = 'UD'
                ) or
                (
                    cac.UWCoverStatus in ('Covered', 'Limited Cover', 'Without Prejudice') and
                    cn.NoteCode = 'UC'
                )
            )
        order by
            cn.CreateTime
    ) cn
where
    cac.isUWCoverChanged = 1 and
    cac.UWCoverStatus not in ('ACCOUNTS')



GO
