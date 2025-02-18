USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_DelimitedSplit8K]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_DelimitedSplit8K]
(
    @pString nvarchar(max),
    @pDelimiter char(1)
)
/*
    20120720, LS

    modification of 8K csv splitter
    http://www.sqlservercentral.com/articles/Tally+Table/72993/

    add e5 to allow up to 100,000 rows
    change varchar(8000) to varchar(max)
    change substring to 100000

    20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)

*/
returns @output table
(
    ItemNumber bigint,
    Item nvarchar(max)
) with schemabinding
as
begin

    --===== "Inline" CTE Driven "Tally Table" produces values from 0 up to 10,000...
    -- enough to cover varchar(8000)
    ;with
    e1(n) as
    (
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
        union all
        select 1
    ),  --10e+1 or 10 rows
    e2(n) as
    (
        select 1
        from e1 a, e1 b
    ),  --10e+2 or 100 rows
    e4(n) as
    (
        select 1
        from e2 a, e2 b
    ),  --10e+4 or 10,000 rows max
    e5(n) as
    (
        select 1
        from e1 a, e4 b
    ),  --10e+5 or 100,000 rows max
    cteTally(n) as
    (
        --==== This provides the "zero base" and limits the number of rows right up front
        -- for both a performance gain and prevention of accidental "overruns"
        select 0
        union all
        select top (datalength(isnull(@pString,1))) row_number() over (order by (select null)) from e5
    ),
    cteStart(n1) as
    (
        --==== This returns N+1 (starting position of each "element" just once for each delimiter)
        select t.n+1
        from cteTally t
        where (substring(@pString, t.n, 1) = @pDelimiter or t.n = 0)
    )
    --===== Do the actual split. The ISNULL/NULLIF combo handles the length for the final element when no delimiter is found.
    insert into @output
    (
        ItemNumber,
        Item
    )
    select
        ItemNumber = row_number() over(order by s.n1),
        Item       = substring(@pString, s.n1, isnull(nullif(charindex(@pDelimiter, @pString, s.n1), 0) - s.n1, 100000))
    from
        cteStart s

    return

end


GO
