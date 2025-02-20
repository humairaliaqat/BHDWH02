USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_fxscraper_average]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_fxscraper_average]
as
begin

    set nocount on

    if object_id('[db-au-cba]..fxHistoryAverage') is null
    begin

        create table [db-au-cba]..fxHistoryAverage
        (
            BIRowID bigint not null identity(1,1),
            LocalCode varchar(5),
            ForeignCode varchar(5),
            FXStartDate date,
            FXEndDate date,
            FXRate decimal(25,10),
            FXSource varchar(50),
            FXPeriod date,
            isHyperinflationPeriod bit
        )

        create unique clustered index cidx_fxHistory on [db-au-cba]..fxHistoryAverage(BIRowID)
        create nonclustered index idx_fxHistory_FX on [db-au-cba]..fxHistoryAverage(LocalCode,ForeignCode,FXStartDate) include(FXEndDate,FXRate,FXSource,isHyperinflationPeriod)

    end

    declare @local table (FX varchar(5))
    declare @fx table (FX varchar(max))

    insert into @local (FX) values ('AUD')
    insert into @local (FX) values ('CNY')
    insert into @local (FX) values ('NZD')
    insert into @local (FX) values ('GBP')
    insert into @local (FX) values ('EUR')
    insert into @local (FX) values ('USD')
    insert into @local (FX) values ('INR')
    insert into @local (FX) values ('SGD')
    insert into @local (FX) values ('MYR')
    insert into @local (FX) values ('IDR')

    insert into @fx (FX)
    select 
        --t.GroupID,
        --r.ItemNumber - 1 PosID,
        r.Item
    from
        (
            select 0 GroupID,  'AUD,USD,NZD,EUR,GBP,THB,IDR,CAD,SGD,FJD' FXs union all
            select 1 GroupID,  'ADF,ADP,AED,AFA,AFN,ALL,AMD,ANG,AOA,AON' FXs union all
            select 2 GroupID,  'ARS,ATS,AWG,AZM,AZN,BAM,BBD,BDT,BEF,BGL' FXs union all
            select 3 GroupID,  'BGN,BHD,BIF,BMD,BND,BOB,BRL,BSD,BTN,BWP' FXs union all
            select 4 GroupID,  'BYR,BZD,CDF,CHF,CLP,CNY,COP,CRC,CSD,CUC' FXs union all
            select 5 GroupID,  'CUP,CVE,CYP,CZK,DEM,DJF,DKK,DOP,DZD,ECS' FXs union all
            select 6 GroupID,  'EEK,EGP,ESP,ETB,FIM,FKP,FRF,GEL,GHC,GHS' FXs union all
            select 7 GroupID,  'GIP,GMD,GNF,GRD,GTQ,GYD,HKD,HNL,HRK,HTG' FXs union all
            select 8 GroupID,  'HUF,IEP,ILS,INR,IQD,IRR,ISK,ITL,JMD,JOD' FXs union all
            select 9 GroupID,  'JPY,KES,KGS,KHR,KMF,KPW,KRW,KWD,KYD,KZT' FXs union all
            select 10 GroupID, 'LAK,LBP,LKR,LRD,LSL,LTL,LUF,LVL,LYD,MAD' FXs union all
            select 11 GroupID, 'MDL,MGA,MGF,MKD,MMK,MNT,MOP,MRO,MTL,MUR' FXs union all
            select 12 GroupID, 'MVR,MWK,MXN,MYR,MZM,MZN,NAD,NGN,NIO,NLG' FXs union all
            select 13 GroupID, 'NOK,NPR,OMR,PAB,PEN,PGK,PHP,PKR,PLN,PTE' FXs union all
            select 14 GroupID, 'PYG,QAR,ROL,RON,RUB,RWF,SAR,SBD,SCR,SDD' FXs union all
            select 15 GroupID, 'SDG,SDP,SEK,SHP,SIT,SKK,SLL,SOS,SRD,SRG' FXs union all
            select 16 GroupID, 'STD,SVC,SYP,SZL,TJS,TMM,TMT,TND,TOP,TRL' FXs union all
            select 17 GroupID, 'TRY,TTD,TWD,TZS,UAH,UGS,UGX,UYP,UYU,UZS' FXs union all
            select 18 GroupID, 'VEB,VEF,VND,VUV,WST,XAF,XAG,XAU,XCD,XEU' FXs union all
            select 19 GroupID, 'XOF,XPD,XPF,XPT,YER,YUN,ZAR,ZMK,ZWD' FXs
        ) t
        cross apply dbo.fn_DelimitedSplit8K(t.FXs, ',') r

    declare @SQL varchar(max)
    declare @CLOB table (string varchar(max), xmlstring XML)

    declare c_pair cursor local for
        select
            l.FX LocalCode,
            f.FX ForeignCode
        from
            @local l,
            @FX f

    declare 
        @LocalCode varchar(3), 
        @ForeignCodes varchar(max),
        @start date,
        @end date

    select 
        @start = convert(varchar(7), dateadd(month, -1, getdate()), 120) + '-01',
        @end = getdate()

    open c_pair

    fetch next from c_pair into @LocalCode, @ForeignCodes

    while @@fetch_status = 0
    begin

        set @SQL = 
        '
        E:\ETL\Tool\wget64.exe 
            --method GET
            --tries=1
            --read-timeout=60
            --header "accept: */*" 
            --header "referer: https://www.oanda.com/solutions-for-business/historical-rates/main.html"
            --output-document=e:\etl\data\oanda-average.html
            "https://www.oanda.com/currency/average?amount=1&start_month=' + convert(varchar, datepart(month, @start)) + '&start_year=' + convert(varchar, datepart(year, @start)) + '&end_month=' + convert(varchar, datepart(month, @end)) + '&end_year=' + convert(varchar, datepart(year, @end)) + '&base=' + @LocalCode + '&avg_type=Week&Submit=1&interbank=0&format=CSV&exchange=' + @ForeignCodes + '"
        '

        set @SQL = 'exec xp_cmdshell ''' + replace(replace(replace(@SQL, '''', ''''''), char(10), ''), char(13), '') + ''''
        print @SQL
        exec(@SQL)

        set @SQL =
            '
            select
                BulkColumn
            from
                openrowset
                (
                    bulk ''e:\etl\data\oanda-average.html'',
                    single_clob
                ) t
            '

        delete from @CLOB

        insert into @CLOB (string)
        exec (@sql)

        if object_id('tempdb..#parsed') is not null
            drop table #parsed

        select 
            @LocalCode LocalCode,
            @ForeignCodes ForeignCode,
            try_convert
            (
                date, 
                max
                (
                    case
                        when r.ItemNumber = 2 then r.Item
                        else null
                    end
                ),
                106
            ) FXStartDate,
            dateadd
            (
                day,
                6,
                try_convert
                (
                    date, 
                    max
                    (
                        case
                            when r.ItemNumber = 2 then r.Item
                            else null
                        end
                    ),
                    106
                ) 
            ) FXEndDate,
            max
            (
                case
                    when r.ItemNumber = 4 then r.Item
                    else null
                end
            ) FXRate,
            'Oanda' FXSource
        into #parsed
        from
            (
                select 
                    substring(
                        string, 
                        patindex('%week [0-9]%', string), 
                        charindex('</pre>', string, patindex('%week [0-9]%', string) + 1) - patindex('%week [0-9]%', string)
                    ) strings
                from
                    @CLOB
            ) t
            cross apply dbo.fn_DelimitedSplit8K(t.strings, char(10)) l
            cross apply dbo.fn_DelimitedSplit8K(l.Item, ',') r
        where
            l.Item <> ''
        group by
            l.ItemNumber


        delete t
        from
            #parsed r
            inner join [db-au-cba]..fxHistoryAverage t on
                t.LocalCode = r.LocalCode and
                t.ForeignCode = r.ForeignCode and
                t.FXStartDate = r.FXStartDate
        where
            t.FXSource = 'Oanda'

        insert into [db-au-cba]..fxHistoryAverage
        (
            LocalCode,
            ForeignCode,
            FXStartDate,
            FXEndDate,
            FXRate,
            FXSource,
            FXPeriod
        )
        select
            LocalCode,
            ForeignCode,
            FXStartDate,
            FXEndDate,
            FXRate,
            FXSource,
            convert(date, convert(varchar(8), FXStartDate, 120) + '01')
        from
            #parsed

        fetch next from c_pair into @LocalCode, @ForeignCodes

    end

    close c_pair
    deallocate c_pair

end
GO
