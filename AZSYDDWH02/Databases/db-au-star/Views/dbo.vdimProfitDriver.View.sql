USE [db-au-star]
GO
/****** Object:  View [dbo].[vdimProfitDriver]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vdimProfitDriver] as
select
    coalesce(
        l8.ProfitDriverSK,
        l7.ProfitDriverSK,
        l6.ProfitDriverSK,
        l5.ProfitDriverSK,
        l4.ProfitDriverSK,
        l3.ProfitDriverSK,
        l2.ProfitDriverSK,
        l1.ProfitDriverSK
    ) ProfitDriverSK,
    l1.ProfitDriverDescription [Level 1],
    coalesce(
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 2],
    coalesce(
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 3],
    coalesce(
        l3.SortOrder,
        l2.SortOrder,
        l1.SortOrder
    ) [Level 3 Sort],
    coalesce(
        l4.ProfitDriverDescription,
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 4],
    coalesce(
        l4.SortOrder,
        l3.SortOrder,
        l2.SortOrder,
        l1.SortOrder
    ) [Level 4 Sort],
    coalesce(
        l5.ProfitDriverDescription,
        l4.ProfitDriverDescription,
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 5],
    coalesce(
        l5.SortOrder,
        l4.SortOrder,
        l3.SortOrder,
        l2.SortOrder,
        l1.SortOrder
    ) [Level 5 Sort],
    coalesce(
        l6.ProfitDriverDescription,
        l5.ProfitDriverDescription,
        l4.ProfitDriverDescription,
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 6],
    coalesce(
        l6.SortOrder,
        l5.SortOrder,
        l4.SortOrder,
        l3.SortOrder,
        l2.SortOrder,
        l1.SortOrder
    ) [Level 6 Sort],
    coalesce(
        l7.ProfitDriverDescription,
        l6.ProfitDriverDescription,
        l5.ProfitDriverDescription,
        l4.ProfitDriverDescription,
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 7],
    coalesce(
        l8.ProfitDriverDescription,
        l7.ProfitDriverDescription,
        l6.ProfitDriverDescription,
        l5.ProfitDriverDescription,
        l4.ProfitDriverDescription,
        l3.ProfitDriverDescription,
        l2.ProfitDriverDescription,
        l1.ProfitDriverDescription
    ) [Level 8],
    coalesce(
        l8.SortOrder,
        l7.SortOrder,
        l6.SortOrder,
        l5.SortOrder,
        l4.SortOrder,
        l3.SortOrder,
        l2.SortOrder,
        l1.SortOrder
    ) SortOrder
from
    dimProfitDriver l1
    left join dimProfitDriver l2 on
        l2.ProfitDriverParentSK = l1.ProfitDriverSK
    left join dimProfitDriver l3 on
        l3.ProfitDriverParentSK = l2.ProfitDriverSK
    left join dimProfitDriver l4 on
        l4.ProfitDriverParentSK = l3.ProfitDriverSK
    left join dimProfitDriver l5 on
        l5.ProfitDriverParentSK = l4.ProfitDriverSK
    left join dimProfitDriver l6 on
        l6.ProfitDriverParentSK = l5.ProfitDriverSK
    left join dimProfitDriver l7 on
        l7.ProfitDriverParentSK = l6.ProfitDriverSK
    left join dimProfitDriver l8 on
        l8.ProfitDriverParentSK = l7.ProfitDriverSK
where
    l1.ProfitDriverParentSK = 0 and
    
    coalesce(
        l8.ProfitDriverSK,
        l7.ProfitDriverSK,
        l6.ProfitDriverSK,
        l5.ProfitDriverSK,
        l4.ProfitDriverSK,
        l3.ProfitDriverSK,
        l2.ProfitDriverSK,
        l1.ProfitDriverSK
    ) not in (60, 61)
GO
