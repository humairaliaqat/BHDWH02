USE [db-au-star]
GO
/****** Object:  View [dbo].[vAccountDescendants]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vAccountDescendants] 
/*
    20130701, LS, create
    20141030, LS, add account order
*/
as
    with cte_account
    as
    (
        select
            Account_SK,
            Account_SK Ancestor_SK,
            Account_Desc Ancestor,
            Account_Code,
            Account_CODE Ancestor_Code,
            Account_Desc,
            Account_Order,
            0 Level
        from
            Dim_Account

        union all

        select
            a.Account_SK,
            Ancestor_SK,
            Ancestor,
            a.Account_CODE,
            p.Ancestor_Code,
            a.Account_Desc,
            p.Account_Order,
            Level + 1
        from
            cte_account p
            inner join Dim_Account a on
                p.Account_SK = a.Parent_Account_SK
    )
    select *
    from
        cte_account

GO
