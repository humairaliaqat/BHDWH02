USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[cba_dns_activation]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cba_dns_activation]
as
begin

    truncate table tmp_cba_dns_impact

    insert into tmp_cba_dns_impact
    select 
        datename(dw, convert(datetime, [Date] + ':00:00')) [Day of Week],
        datename(hh, convert(datetime, [Date] + ':00:00')) + ':00' [Hour],
        convert(datetime, [Date] + ':00:00') [Date Time],
        [Session Count],
        [Policy Count]
    from
        openquery
        (
            IMPULSE,
            '
            SELECT 
	            (sessioncreateddatetime + interval ''10h'')::char(13) "Date",
	            count(sessionid) "Session Count",
	            sum
	            (
		            case
			            when policynumber is not null then 1
			            else 0
		            end 
	            ) "Policy Count"
            FROM cba.cba_sessions
            where
	            businessunitid = 104 and
	            sessioncreateddatetime >= ''2019-07-31''
            group by
	            (sessioncreateddatetime + interval ''10h'')::char(13)
            order by 
	            (sessioncreateddatetime + interval ''10h'')::char(13) desc
            '
        ) 
    where
        convert(datetime, [Date] + ':00:00') >= dateadd(week, -4, convert(date, getdate()))

end
GO
