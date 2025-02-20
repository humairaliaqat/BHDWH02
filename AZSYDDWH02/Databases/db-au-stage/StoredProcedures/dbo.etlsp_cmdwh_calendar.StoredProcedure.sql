USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_calendar]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_cmdwh_calendar]
    @RunMode varchar(10) = 'AUTO',
    @StartDate varchar(10) = null,
    @EndDate varchar(10) = null

as
begin
--uncomment to debug
/*
declare @RunMode varchar(10)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select @RunMode = 'MANUAL', @StartDate = '2012-01-01', @EndDate = '2012-12-31'
*/

    set nocount on

    declare @rptStartDate datetime
    declare @rptEndDate datetime

    if @RunMode = 'AUTO'            --add dates for next full year
        select
            @rptStartDate = convert(datetime,convert(varchar(5),dateadd(year,1,getdate()),120)+'01-01'),
            @rptEndDate = convert(datetime,convert(varchar(5),dateadd(year,1,getdate()),120)+'12-31')

    else
        select
            @rptStartDate = convert(datetime,@StartDate),
            @rptEndDate = convert(datetime,@EndDate)


    if object_id('[db-au-cmdwh].dbo.Calendar') is null
    begin

        create table [db-au-cmdwh].dbo.Calendar
        (
            [Date] smalldatetime not null,              --calendar date
            Last7DaysStart smalldatetime null,          --last 7 days start date
            Last7DaysEnd smalldatetime null,            --last 7 days end date
            LastWeekNum int null,                       --last week number
            LastWeekStart smalldatetime null,           --last week start date (Mon-Sun)
            LastWeekEnd smalldatetime null,             --last week end date (Mon-Sun)
            Last14DaysStart smalldatetime null,         --last 14 days start date
            Last14DaysEnd smalldatetime null,           --last 14 days end date
            Last30DaysStart smalldatetime null,         --last 30 days start date
            Last30DaysEnd smalldatetime null,           --last 30 days end date
            LastMonthNum int null,                      --last month number
            LastFiscalMonthNum int null,                --last fiscal month number
            LastMonthStart smalldatetime null,          --last month start date
            LastFiscalMonthStart smalldatetime null,    --last fiscal month start date
            LastMonthEnd smalldatetime null,            --last month end date
            LastFiscalMonthEnd smalldatetime null,      --last fiscal month end date
            LastQuarterNum int null,                    --last quarter number
            LastFiscalQuarterNum int null,              --last fiscal quarter number
            LastQuarterStart smalldatetime null,        --last quarter start date
            LastFiscalQuarterStart smalldatetime null,  --last fiscal quarter start date
            LastQuarterEnd smalldatetime null,          --last quarter end date
            LastFiscalQuarterEnd smalldatetime null,    --last fiscal quarter end date
            LastYearNum int null,                       --last year number
            LastFiscalYearNum int null,                 --last fiscal year number
            LastYearStart smalldatetime null,           --last year start date
            LastFiscalStart smalldatetime null,         --last fiscal year start date
            LastYearEnd smalldatetime null,             --last year end date
            LastFiscalYearEnd smalldatetime null,       --last fiscal year end date
            Next7DaysStart smalldatetime null,          --next 7 days start date
            Next7DaysEnd smalldatetime null,            --next 7 days end date
            NextWeekNum int null,                       --next week number
            NextWeekStart smalldatetime,                --next week start date (Mon-Sun)
            NextWeekEnd smalldatetime,                  --next week end date (Mon-Sun)
            Next14DaysStart smalldatetime null,         --next 14 days start date
            Next14DaysEnd smalldatetime null,           --next 14 days end date
            Next30DaysStart smalldatetime null,         --next 30 days start date
            Next30DaysEnd smalldatetime null,           --next 30 days end date
            NextMonthNum int null,                      --next month number
            NextFiscalMonthNumber int null,             --next fiscal month number
            NextMonthStart smalldatetime null,          --next month start date
            NextFiscalMonthStart smalldatetime null,    --next fiscal month start date
            NextMonthEnd smalldatetime null,            --next month end date
            NextFiscalMonthEnd smalldatetime null,      --next fiscal month end date
            NextQuarterNum int null,                    --next quarter number
            NextFiscalQuarterNum int null,              --next fiscal quarter number
            NextQuarterStart smalldatetime null,        --next quarter start date
            NextFiscalQuarterStart smalldatetime null,  --next fiscal quarter start date
            NextQuarterEnd smalldatetime null,          --next quarter end date
            NextFiscalQuarterEnd smalldatetime null,    --next fiscal quarter end date
            NextYearNum int null,                       --next year number
            NextFiscalYearNum int null,                 --next fiscal year number
            NextYearStart smalldatetime null,           --next year start date
            NextFiscalYearStart smalldatetime null,     --next fiscal year start date
            NextYearEnd smalldatetime null,             --next year end date
            NextFiscalYearEnd smalldatetime null,       --next fiscal year end date
            PreviousDay smalldatetime null,             --previous day date
            CurWeekNum int null,                        --current week number
            CurWeekStart smalldatetime null,            --current week start date (Mon-Sun)
            CurWeekEnd smalldatetime null,              --current week end date (Mon-Sun)
            CurMonthNum int null,                       --current month number
            CurFiscalMonthNum int null,                 --current fiscal month number
            CurMonthStart smalldatetime null,           --current month start date
            CurFiscalMonthStart smalldatetime null,     --current fiscal month start date
            CurMonthEnd smalldatetime null,             --current month end date
            CurFiscalMonthEnd smalldatetime null,       --current fiscal month end date
            CurQuarterNum int null,                     --current quarter number
            CurFiscalQuarterNum int null,               --current fiscal quarter number
            CurQuarterStart smalldatetime null,         --current quarter start date
            CurFiscalQuarterStart smalldatetime null,   --current fiscal quarter start date
            CurQuarterEnd smalldatetime null,           --current quarter end date
            CurFiscalQuarterEnd smalldatetime null,     --current fiscal quarter end date
            CurYearNum int null,                        --current year number
            CurFiscalYearNum int null,                  --current fiscal year number
            CurYearStart smalldatetime null,            --current year start date
            CurFiscalYearStart smalldatetime null,      --current fiscal year start date
            CurYearEnd smalldatetime null,              --current year end date
            CurFiscalYear smalldatetime null,           --current fiscal year end date
            MTDNum int null,                            --month-to-date number
            MTDFiscalNum int null,                      --month-to-date fiscal number
            MTDStart smalldatetime null,                --month-to-date start date
            MTDFiscalStart smalldatetime null,          --month-to-date fiscal start date
            MTDEnd smalldatetime null,                  --month-to-date end date
            MTDFiscalEnd smalldatetime null,            --month-to-date fiscal end date
            WTDNum int null,                            --week-to-date number
            WTDStart smalldatetime null,                --week-to-date start date (Mon-Sun)
            WTDEnd smalldatetime null,                  --week-to-date end date    (Mon-Sun)
            QTDNum int null,                            --quarter-to-date number
            QTDFiscalNumber int null,                   --quarter-to-date fiscal number
            QTDStart smalldatetime null,                --quarter-to-date start date
            QTDFiscalStart smalldatetime null,          --quarter-to-date fiscal start date
            QTDEnd smalldatetime null,                  --quarter-to-date end date
            QTDFiscalEnd smalldatetime null,            --quarter-to-date fiscal end date
            YTDNum int null,                            --year-to-date number
            YTDFiscalNum int null,                      --year-to-date fiscal number
            YTDStart smalldatetime null,                --year-to-date start date
            YTDFiscalStart smalldatetime null,          --year-to-date fiscal start date
            YTDEnd smalldatetime null,                  --year-to-date end date
            YTDFiscalEndDate smalldatetime null,        --year-to-date fiscal end date
            LYCurMonthNum int null,                     --last year current month number
            LYCurFiscalMonthNum int null,               --last year current fiscal month number
            LYCurMonthStart smalldatetime null,         --last year current month start date
            LYCurFiscalMonthStart smalldatetime null,   --last year current fiscal month start date
            LYCurMonthEnd smalldatetime null,           --last year current month end date
            LYCurFiscalMonthEnd smalldatetime null,     --last year current fiscal month end
            LYYearNum int null,                         --last year year number
            LYFiscalYearNum int null,                   --last year fiscal year number
            LYYeartStart smalldatetime null,            --last year year start date
            LYFiscalYearStart smalldatetime null,       --last year fiscal year start date
            LYYearEnd smalldatetime null,               --last year year end date
            LYFiscalYearEnd smalldatetime null,         --last year fiscal year end date
            LYQuarterNum int null,                      --last year quarter number
            LYFiscalQuarterNum int null,                --last year fiscal quarter number
            LYQuarterStart smalldatetime null,          --last year quarter start date
            LYFiscalQuarterStart smalldatetime null,    --last year fiscal quarter start date
            LYQuarterEnd smalldatetime null,            --last year quarter end date
            LYFiscalQuarterEnd smalldatetime null,      --last year fiscal quarter end date
            LYWeekNum int null,                         --last year week number
            LYWeekStart smalldatetime null,             --last year week start date
            LYWeekEnd smalldatetime null,               --last year week end date
            LYMTDNum int null,                          --last year month-to-date number
            LYFiscalMTDNum int null,                    --last year fiscal month-to-date number
            LYMTDStart smalldatetime null,              --last year month-to-date start date
            LYFiscalMTDStart smalldatetime null,        --last year fiscal month-to-date start date
            LYMTDEnd smalldatetime null,                --last year month-to-date end date
            LYFiscalMTDEnd smalldatetime null,          --last year fiscal month-to-date end date
            LYQTDNum int null,                          --last year quarter-to-date number
            LYFiscalQTDNum int null,                    --last year fiscal quarter-to-date number
            LYQTDStart smalldatetime null,              --last year quarter-to-date start date
            LYFiscalQTDStart smalldatetime null,        --last year fiscal quarter-to-date start date
            LYQTDEnd smalldatetime null,                --last year quarter-to-date end date
            LYFiscalQTDEnd smalldatetime null,          --last year fiscal quarter-to-date end date
            LYYTDNum int null,                          --last year year-to-date number
            LYFiscalYTDNum int null,                    --last year fiscal year-to-date number
            LYYTDStart smalldatetime null,              --last year year-to-date start date
            LYFiscalYTDStart smalldatetime null,        --last year fiscal year-to-date start date
            LYYTDEnd smalldatetime null,                --last year year-to-date end date
            LYFiscalYTDEnd smalldatetime null,          --last year fiscal year-to-date end date
            isHoliday int null,
            isWeekDay int null,
            isWeekEnd int null,
            SUNPeriod int null
        )

        create clustered index idx_calendar_date on [db-au-cmdwh].dbo.Calendar([Date])

    end
    else
    begin

        delete [db-au-cmdwh].dbo.Calendar
        where
            [Date] between @rptStartDate and @rptEndDate

    end


    set datefirst 1                                                                                                         --set Monday to Sunday Week

    declare @date smalldatetime
    select @date = @rptStartDate

    while @date <= @rptEndDate
    begin

        insert [db-au-cmdwh].dbo.Calendar
        select
        @date as [Date],                                                                                                    --calendar date
        Last7DaysStart = [db-au-cmdwh].dbo.fn_dtLast7DaysStart(@date),                                                      --last 7 days start date
        Last7DaysEnd = [db-au-cmdwh].dbo.fn_dtLast7DaysEnd(@date),                                                          --last 7 days end date
        LastWeekNum = [db-au-cmdwh].dbo.fn_dtLastWeekNum(@date),                                                            --last week number
        LastWeekStart = [db-au-cmdwh].dbo.fn_dtLastWeekStart(@date),                                                        --last week start date (Mon-Sun)
        LastWeekEnd = [db-au-cmdwh].dbo.fn_dtLastWeekEnd(@date),                                                            --last week end date (Mon-Sun)
        Last14DaysStart = [db-au-cmdwh].dbo.fn_dtLast14DaysStart(@date),                                                    --last 14 days start date
        Last14DaysEnd = [db-au-cmdwh].dbo.fn_dtLast14DaysEnd(@date),                                                        --last 14 days end date
        Last30DaysStart = [db-au-cmdwh].dbo.fn_dtLast30DaysStart(@date),                                                    --last 30 days start date
        Last30DaysEnd = [db-au-cmdwh].dbo.fn_dtLast30DaysEnd(@date),                                                        --last 30 days end date
        LastMonthNum = [db-au-cmdwh].dbo.fn_dtLastMonthNum(@date),                                                          --last month number
        LastFiscalMonthNum = [db-au-cmdwh].dbo.fn_dtLastFiscalMonthNum(@date),                                              --last fiscal month number
        LastMonthStart = [db-au-cmdwh].dbo.fn_dtLastMonthStart(@date),                                                      --last month start date
        LastFiscalMonthStart = [db-au-cmdwh].dbo.fn_dtLastFiscalMonthStart(@date),                                          --last fiscal month start date
        LastMonthEnd = [db-au-cmdwh].dbo.fn_dtLastMonthEnd(@date),                                                          --last month end date
        LastFiscalMonthEnd = [db-au-cmdwh].dbo.fn_dtLastFiscalMonthEnd(@date),                                              --last fiscal month end date
        LastQuarterNum = [db-au-cmdwh].dbo.fn_dtLastQuarterNum(@date),                                                      --last quarter number
        LastFiscalQuarterNum = [db-au-cmdwh].dbo.fn_dtLastFiscalQuarterNum(@date),                                          --last fiscal quarter number
        LastQuarterStart = [db-au-cmdwh].dbo.fn_dtLastQuarterStart(@date),                                                  --last quarter start date
        LastFiscalQuarterStart = [db-au-cmdwh].dbo.fn_dtLastFiscalQuarterStart(@date),                                      --last fiscal quarter start date
        LastQuarterEnd = [db-au-cmdwh].dbo.fn_dtLastQuarterEnd(@date),                                                      --last quarter end date
        LastFiscalQuarterEnd = [db-au-cmdwh].dbo.fn_dtLastFiscalQuarterEnd(@date),                                          --last fiscal quarter end date
        LastYearNum = [db-au-cmdwh].dbo.fn_dtLastYearNum(@date),                                                            --last year number
        LastFiscalYearNum = [db-au-cmdwh].dbo.fn_dtLastFiscalYearNum(@date),                                                --last fiscal year number
        LastYearStart = [db-au-cmdwh].dbo.fn_dtLastYearStart(@date),                                                        --last year start date
        LastFiscalYearStart = [db-au-cmdwh].dbo.fn_dtLastFiscalYearStart(@date),                                            --last fiscal year start date
        LastYearEnd = [db-au-cmdwh].dbo.fn_dtLastYearEnd(@date),                                                            --last year end date
        LastFiscalYearEnd = [db-au-cmdwh].dbo.fn_dtLastFiscalYearEnd(@date),                                                --last fiscal year end date
        Next7DaysStart = [db-au-cmdwh].dbo.fn_dtNext7DaysStart(@date),                                                      --next 7 days start date
        Next7DaysEnd = [db-au-cmdwh].dbo.fn_dtNext7DaysEnd(@date),                                                          --next 7 days end date
        NextWeekNum = [db-au-cmdwh].dbo.fn_dtNextWeekNum(@date),                                                            --next week number
        NextWeekStart = [db-au-cmdwh].dbo.fn_dtNextWeekStart(@date),                                                        -- Next week start date (Mon-Sun)
        NextWeekEnd = [db-au-cmdwh].dbo.fn_dtNextWeekEnd(@date),                                                            -- Next week end date (Mon-Sun)
        Next14DaysStart = [db-au-cmdwh].dbo.fn_dtNext14DaysStart(@date),                                                    --next 14 days start date
        Next14DaysEnd = [db-au-cmdwh].dbo.fn_dtNext14DaysEnd(@date),                                                        --next 14 days end date
        Next30DaysStart = [db-au-cmdwh].dbo.fn_dtNext30DaysStart(@date),                                                    --next 30 days start date
        Next30DaysEnd = [db-au-cmdwh].dbo.fn_dtNext30DaysEnd(@date),                                                        --next 30 days end date
        NextMonthNum = [db-au-cmdwh].dbo.fn_dtNextMonthNum(@date),                                                          --next month number
        NextFiscalMonthNum = [db-au-cmdwh].dbo.fn_dtNextFiscalMonthNum(@date),                                              --next fiscal month number
        NextMonthStart = [db-au-cmdwh].dbo.fn_dtNextMonthStart(@date),                                                      --next month start date
        NextFiscalMonthStart = [db-au-cmdwh].dbo.fn_dtNextFiscalMonthStart(@date),                                          --next fiscal month start date
        NextMonthEnd = [db-au-cmdwh].dbo.fn_dtNextMonthEnd(@date),                                                          --next month end date
        NextFiscalMonthEnd = [db-au-cmdwh].dbo.fn_dtNextFiscalMonthEnd(@date),                                              --next fiscal month end date
        NextQuarterNum = [db-au-cmdwh].dbo.fn_dtNextQuarterNum(@date),                                                      --next quarter number
        NextFiscalQuarterNum = [db-au-cmdwh].dbo.fn_dtNextFiscalQuarterNum(@date),                                          --next fiscal quarter number
        NextQuarterStart = [db-au-cmdwh].dbo.fn_dtNextQuarterStart(@date),                                                  --next quarter start date
        NextFiscalQuarterStart = [db-au-cmdwh].dbo.fn_dtNextFiscalQuarterStart(@date),                                      --next fiscal quarter start date
        NextQuarterEnd = [db-au-cmdwh].dbo.fn_dtNextQuarterEnd(@date),                                                      --next quarter end date
        NextFiscalQuarterEnd = [db-au-cmdwh].dbo.fn_dtNextFiscalQuarterEnd(@date),                                          --next fiscal quarter end date
        NextYearNum = [db-au-cmdwh].dbo.fn_dtNextYearNum(@date),                                                            --next year number
        NextFiscalYearNum = [db-au-cmdwh].dbo.fn_dtNextFiscalYearNum(@date),                                                --next fiscal year number
        NextYearStart = [db-au-cmdwh].dbo.fn_dtNextYearStart(@date),                                                        --next year start date
        NextFiscalYearStart = [db-au-cmdwh].dbo.fn_dtNextFiscalYearStart(@date),                                            --next fiscal year start date
        NextYearEnd = [db-au-cmdwh].dbo.fn_dtNextYearEnd(@date),                                                            --next year end date
        NextFiscalYearEnd = [db-au-cmdwh].dbo.fn_dtNextFiscalYearEnd(@date),                                                --next fiscal year end date
        PreviousDay = [db-au-cmdwh].dbo.fn_dtPreviousDay(@date),                                                            --previous day date
        CurWeekNum = [db-au-cmdwh].dbo.fn_dtCurWeekNum(@date),                                                              --current week number
        CurWeekStart = [db-au-cmdwh].dbo.fn_dtCurWeekStart(@date),                                                          --current week start date (Mon-Sun)
        CurWeekEnd = [db-au-cmdwh].dbo.fn_dtCurWeekEnd(@date),                                                              --current week end date (Mon-Sun)
        CurMonthNum = [db-au-cmdwh].dbo.fn_dtCurMonthNum(@date),                                                            --current month number
        CurFiscalMonthNum = [db-au-cmdwh].dbo.fn_dtCurFiscalMonthNum(@date),                                                --current fiscal month number
        CurMonthStart = [db-au-cmdwh].dbo.fn_dtCurMonthStart(@date),                                                        --current month start date
        CurFiscalMonthStart = [db-au-cmdwh].dbo.fn_dtCurFiscalMonthStart(@date),                                            --current fiscal month start date
        CurMonthEnd = [db-au-cmdwh].dbo.fn_dtCurMonthEnd(@date),                                                            --current month end date
        CurFiscalMonthEnd = [db-au-cmdwh].dbo.fn_dtCurFiscalMonthEnd(@date),                                                --current fiscal month end date
        CurQuarterNum = [db-au-cmdwh].dbo.fn_dtCurQuarterNum(@date),                                                        --current quarter number
        CurFiscalQuarterNum = [db-au-cmdwh].dbo.fn_dtCurFiscalQuarterNum(@date),                                            --current fiscal quarter number
        CurQuarterStart = [db-au-cmdwh].dbo.fn_dtCurQuarterStart(@date),                                                    --current quarter start date
        CurFiscalQuarterStart = [db-au-cmdwh].dbo.fn_dtCurFiscalQuarterStart(@date),                                        --current fiscal quarter start date
        CurQuarterEnd = [db-au-cmdwh].dbo.fn_dtCurQuarterEnd(@date),                                                        --current quarter end date
        CurFiscalQuarterEnd = [db-au-cmdwh].dbo.fn_dtCurFiscalQuarterEnd(@date),                                            --current fiscal quarter end date
        CurYearNum = [db-au-cmdwh].dbo.fn_dtCurYearNum(@date),                                                              --current year number
        CurFiscalYearNum = [db-au-cmdwh].dbo.fn_dtCurFiscalYearNum(@date),                                                  --current fiscal year number
        CurYearStart = [db-au-cmdwh].dbo.fn_dtCurYearStart(@date),                                                          --current year start date
        CurFiscalYearStart = [db-au-cmdwh].dbo.fn_dtCurFiscalYearStart(@date),                                              --current fiscal year start date
        CurYearEnd = [db-au-cmdwh].dbo.fn_dtCurFiscalYearStart(@date),                                                      --current year end date
        CurFiscalYearEnd = [db-au-cmdwh].dbo.fn_dtCurFiscalYearEnd(@date),                                                  --current fiscal year end date
        MTDNum = [db-au-cmdwh].dbo.fn_dtMTDNum(@date),                                                                      --month-to-date number
        MTDFiscalNum = [db-au-cmdwh].dbo.fn_dtMTDFiscalNum(@date),                                                          --month-to-date fiscal number
        MTDStart = [db-au-cmdwh].dbo.fn_dtMTDStart(@date),                                                                  --month-to-date start date
        MTDFiscalStart = [db-au-cmdwh].dbo.fn_dtMTDFiscalStart(@date),                                                      --month-to-date fiscal start date
        MTDEnd = [db-au-cmdwh].dbo.fn_dtMTDEnd(@date),                                                                      --month-to-date end date
        MTDFiscalEnd = [db-au-cmdwh].dbo.fn_dtMTDFiscalEnd(@date),                                                          --month-to-date fiscal end date
        WTDNum = [db-au-cmdwh].dbo.fn_dtWTDNum(@date),                                                                      --week-to-date number
        WTDStart = [db-au-cmdwh].dbo.fn_dtWTDStart(@date),                                                                  --week-to-date start date (Mon-Sun)
        WTDEnd = [db-au-cmdwh].dbo.fn_dtWTDEnd(@date),                                                                      --week-to-date end date      (Mon-Sun)
        QTDNum = [db-au-cmdwh].dbo.fn_dtQTDNum(@date),                                                                      --quarter-to-date number
        QTDFiscalNum = [db-au-cmdwh].dbo.fn_dtQTDFiscalNum(@date),                                                          --quarter-to-date fiscal number
        QTDStart = [db-au-cmdwh].dbo.fn_dtQTDStart(@date),                                                                  --quarter-to-date start date
        QTDFiscalStart = [db-au-cmdwh].dbo.fn_dtQTDFiscalStart(@date),                                                      --quarter-to-date fiscal start date
        QTDEnd = [db-au-cmdwh].dbo.fn_dtQTDEnd(@date),                                                                      --quarter-to-date end date
        QTDFiscalEnd = [db-au-cmdwh].dbo.fn_dtQTDFiscalEnd(@date),                                                          --quarter-to-date fiscal end date
        YTDNum = [db-au-cmdwh].dbo.fn_dtYTDNum(@date),                                                                      --year-to-date number
        YTDFiscalNum = [db-au-cmdwh].dbo.fn_dtYTDFiscalNum(@date),                                                          --year-to-date fiscal number
        YTDStart = [db-au-cmdwh].dbo.fn_dtYTDStart(@date),                                                                  --year-to-date start date
        YTDFiscalStart = [db-au-cmdwh].dbo.fn_dtYTDFiscalStart(@date),                                                      --year-to-date fiscal start date
        YTDEnd = [db-au-cmdwh].dbo.fn_dtYTDEnd(@date),                                                                      --year-to-date end date
        YTDFiscalEnd = [db-au-cmdwh].dbo.fn_dtYTDFiscalEnd(@date),                                                          --year-to-date fiscal end date
        LYCurMonthNum = [db-au-cmdwh].dbo.fn_dtLYCurMonthNum(@date),                                                        --last year current month number
        LYCurFiscalMonthNum = [db-au-cmdwh].dbo.fn_dtLYCurFiscalMonthNum(@date),                                            --last year current fiscal month number
        LYCurMonthStart = [db-au-cmdwh].dbo.fn_dtLYCurMonthStart(@date),                                                    --last year current month start date
        LYCurFiscalMonthStart = [db-au-cmdwh].dbo.fn_dtLYCurFiscalMonthStart(@date),                                        --last year current fiscal month start date
        LYCurMonthEnd = [db-au-cmdwh].dbo.fn_dtLYCurMonthEnd(@date),                                                        --last year current month end date
        LYCurFiscalMonthEnd = [db-au-cmdwh].dbo.fn_dtCurFiscalMonthEnd(@date),                                              --last year current fiscal month end
        LYYearNum = [db-au-cmdwh].dbo.fn_dtLYYearNum(@date),                                                                --last year year number
        LYFiscalYearNum = [db-au-cmdwh].dbo.fn_dtLYFiscalYearNum(@date),                                                    --last year fiscal year number
        LYYeartStart = [db-au-cmdwh].dbo.fn_dtLYYearStart(@date),                                                           --last year year start date
        LYFiscalYearStart = [db-au-cmdwh].dbo.fn_dtLYFiscalYearStart(@date),                                                --last year fiscal year start date
        LYYearEnd = [db-au-cmdwh].dbo.fn_dtLYYearEnd(@date),                                                                --last year year end date
        LYFiscalYearEnd = [db-au-cmdwh].dbo.fn_dtLYFiscalYearEnd(@date),                                                    --last year fiscal year end date
        LYQuarterNum = [db-au-cmdwh].dbo.fn_dtLYQuarterNum(@date),                                                          --last year quarter number
        LYFiscalQuarterNum = [db-au-cmdwh].dbo.fn_dtLYFiscalQuarterNum(@date),                                              --last year fiscal quarter number
        LYQuarterStart = [db-au-cmdwh].dbo.fn_dtLYQuarterStart(@date),                                                      --last year quarter start date
        LYFiscalQuarterStart = [db-au-cmdwh].dbo.fn_dtLYFiscalQuarterStart(@date),                                          --last year fiscal quarter start date
        LYQuarterEnd = [db-au-cmdwh].dbo.fn_dtLYQuarterEnd(@date),                                                          --last year quarter end date
        LYFiscalQuarterEnd = [db-au-cmdwh].dbo.fn_dtLYFiscalQuarterEnd(@date),                                              --last year fiscal quarter end date
        LYWeekNum = [db-au-cmdwh].dbo.fn_dtLYWeekNum(@date),                                                                --last year week number
        LYWeekStart = [db-au-cmdwh].dbo.fn_dtLYWeekStart(@date),                                                            --last year week start date
        LYWeekEnd = [db-au-cmdwh].dbo.fn_dtLYWeekEnd(@date),                                                                --last year week end date
        LYMTDNum = [db-au-cmdwh].dbo.fn_dtLYMTDNum(@date),                                                                  --last year month-to-date number
        LYFiscalMTDNum = [db-au-cmdwh].dbo.fn_dtLYFiscalMTDNum(@date),                                                      --last year fiscal month-to-date number
        LYMTDStart = [db-au-cmdwh].dbo.fn_dtLYMTDStart(@date),                                                              --last year month-to-date start date
        LYFiscalMTDStart = [db-au-cmdwh].dbo.fn_dtLYFiscalMTDStart(@date),                                                  --last year fiscal month-to-date start date
        LYMTDEnd = [db-au-cmdwh].dbo.fn_dtLYMTDEnd(@date),                                                                  --last year month-to-date end date
        LYFiscalMTDEnd = [db-au-cmdwh].dbo.fn_dtLYFiscalMTDEnd(@date),                                                      --last year fiscal month-to-date end date
        LYQTDNum = [db-au-cmdwh].dbo.fn_dtLYQTDNum(@date),                                                                  --last year quarter-to-date number
        LYFiscalQTDNum = [db-au-cmdwh].dbo.fn_dtLYFiscalQTDNum(@date),                                                      --last year fiscal quarter-to-date number
        LYQTDStart = [db-au-cmdwh].dbo.fn_dtLYQTDStart(@date),                                                              --last year quarter-to-date start date
        LYFiscalQTDStart = [db-au-cmdwh].dbo.fn_dtLYFiscalQTDStart(@date),                                                  --last year fiscal quarter-to-date start date
        LYQTDEnd = [db-au-cmdwh].dbo.fn_dtLYQTDEnd(@date),                                                                  --last year quarter-to-date end date
        LYFiscalQTDEnd = [db-au-cmdwh].dbo.fn_dtLYFiscalQTDEnd(@date),                                                      --last year fiscal quarter-to-date end date
        LYYTDNum = [db-au-cmdwh].dbo.fn_dtLYYTDNum(@date),                                                                  --last year year-to-date number
        LYFiscalYTDNum = [db-au-cmdwh].dbo.fn_dtLYFiscalYTDNum(@date),                                                      --last year fiscal year-to-date number
        LYYTDStart = [db-au-cmdwh].dbo.fn_dtLYYTDStart(@date),                                                              --last year year-to-date start date
        LYFiscalYTDStart = [db-au-cmdwh].dbo.fn_dtLYFiscalYTDStart(@date),                                                  --last year fiscal year-to-date start date
        LYYTDEnd = [db-au-cmdwh].dbo.fn_dtLYYTDEnd(@date),                                                                  --last year year-to-date end date
        LYFiscalYTDEnd = [db-au-cmdwh].dbo.fn_dtLYFiscalYTDEnd(@date),                                                      --last year fiscal year-to-date end date
        0 as isHoliday,
        case when datepart(dw,@date) in (1,2,3,4,5) then 1 else 0 end as isWeekDay,
        case when datepart(dw,@date) in (6,7) then 1 else 0 end as isWeekEnd,
        [db-au-cmdwh].dbo.fn_GetSUNFiscalPeriod(@date)

        select @date = dateadd(d,1,@date)

    end



    /********************************************************************************/
    -- NOTE THE FOLLOWING ARE STANDARD NSW PUBLIC HOLIDAYS
    -- IF THERE ARE NON-STANDARD NSW PUBLIC HOLIDAYS, YOU NEED TO MANUALLY UPDATE THEM
    /********************************************************************************/

    /********************************************************************************/
    --Easter Holidays
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    set isHoliday = 1
    where
    [Date] between @rptStartDate and @rptEndDate and
    [Date] = DATEADD(dd,-2,CONVERT(datetime,[db-au-cmdwh].dbo.fn_GetEasterDate(DATEPART(yy,[Date]))))

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE
    [Date] between @rptStartDate and @rptEndDate and
    [Date] = DATEADD(dd,+1,CONVERT(datetime,[db-au-cmdwh].dbo.fn_GetEasterDate(DATEPART(yy,[Date]))))

    /********************************************************************************/
    --New Year Day
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET    isHoliday = 1
    WHERE [Date] IN (SELECT CASE WHEN DATEPART(dw,[Date]) IN (6) THEN
    DATEADD(dd,+2,[Date])
    WHEN DATEPART(dw,[Date]) IN (7) THEN
    DATEADD(dd,+1,[Date]) ELSE [Date] END
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 1 AND DATEPART(dd,[Date]) IN (1))

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 1 AND DATEPART(dd,[Date]) IN (1)

    /********************************************************************************/
    --Australia Day
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT CASE WHEN DATEPART(dw,[Date]) IN (6) THEN
    DATEADD(dd,+2,[Date])
    WHEN DATEPART(dw,[Date]) IN (7) THEN
    DATEADD(dd,+1,[Date]) ELSE [Date] END
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 1 AND DATEPART(dd,[Date]) IN (26))

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 1 AND DATEPART(dd,[Date]) IN (26)

    /********************************************************************************/
    --ANZAC Day
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 0
    WHERE [Date] IN (SELECT CASE WHEN DATEPART(dw,[Date]) IN (6) THEN
    DATEADD(dd,+2,[Date])
    WHEN DATEPART(dw,[Date]) IN (7) THEN
    DATEADD(dd,+1,[Date]) ELSE [Date] END
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 4 AND DATEPART(dd,[Date]) IN (25))

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 4 AND DATEPART(dd,[Date]) IN (25)

    /********************************************************************************/
    --Queens Birthday
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT (MIN([Date]) + 7) FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 6 AND DATEPART(dw,[Date]) = 1
    GROUP BY DATEPART(yy,[Date]))

    /********************************************************************************/
    --Bank Holiday
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT MIN([Date]) FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 8 AND DATEPART(dw,[Date]) = 1
    GROUP BY DATEPART(yy,[Date]))

    /********************************************************************************/
    --Labour Day
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT MIN([Date]) FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 10 AND DATEPART(dw,[Date]) = 1
    GROUP BY DATEPART(yy,[Date]))

    /********************************************************************************/
    --Christmas & Boxing Day
    /********************************************************************************/
    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT CASE WHEN DATEPART(dw,[Date]) IN (7,6) THEN
    DATEADD(dd,+2,[Date]) ELSE [Date] END
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 12 AND DATEPART(dd,[Date]) IN (25,26))

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    WHERE [Date] IN (SELECT CASE WHEN DATEPART(dw,[Date]) IN (6) THEN
    DATEADD(dd,+2,[Date])
    WHEN DATEPART(dw,[Date]) IN (7) THEN
    DATEADD(dd,+1,[Date]) ELSE [Date] END
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 12 AND DATEPART(dd,[Date]) IN (25,26))


    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 12 AND DATEPART(dd,[Date]) IN (25)

    update [db-au-cmdwh].dbo.Calendar
    SET isHoliday = 1
    FROM [db-au-cmdwh].dbo.Calendar
    WHERE [Date] between @rptStartDate and @rptEndDate and DATEPART(mm,[Date]) = 12 AND DATEPART(dd,[Date]) IN (26)

end

GO
