USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_fxscraper]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_fxscraper]
    @StartDate date = null,
    @EndDate date = null

as
begin

--20170517, OANDA changed their API
--20180503, OANDA changed their API again

    set nocount on


    if object_id('[db-au-cba]..fxHistory') is null
    begin

        create table [db-au-cba]..fxHistory
        (
            BIRowID bigint not null identity(1,1),
            LocalCode varchar(5),
            ForeignCode varchar(5),
            FXDate date,
            FXRate decimal(25,10),
            FXSource varchar(50)
        )

        create unique clustered index cidx_fxHistory on [db-au-cba]..fxHistory(BIRowID)
        create nonclustered index idx_fxHistory_FX on [db-au-cba]..fxHistory(LocalCode,ForeignCode,FXDate) include(FXRate,FXSource)

    end

    if object_id('[db-au-cba]..fxHistoryJSON') is null
    begin

        create table [db-au-cba]..fxHistoryJSON
        (
            BIRowID bigint not null identity(1,1),
            LocalCode varchar(5),
            FXStartDate date,
            FXEndDate date,
            FXJSON nvarchar(max),
            FXSource varchar(50)
        )

        create unique clustered index cidx_fxHistory on [db-au-cba]..fxHistoryJSON(BIRowID)

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

    ;with cte_pairs
    as
    (
        select 
            t.GroupID,
            r.ItemNumber - 1 PosID,
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
    )
    insert into @fx (FX)
    select 
        --GroupID,
        replace
        (
            (
                select
                    '&quote_currency_' + convert(varchar, PosID) + '=' + Item
                from
                    cte_pairs r
                where
                    r.GroupID = t.GroupID
                for xml path('')
            ),
            '&amp;',
            '&' 
        ) FXs
    from
        (
            select distinct 
                GroupID
            from
                cte_pairs t
        ) t
    order by
        t.GroupID

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
        @ForeignCodes varchar(max)

    set @StartDate = isnull(@StartDate, dateadd(day, -7, getdate()))
    set @EndDate = isnull(@EndDate, getdate())


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
            --output-document=e:\etl\data\oanda.json
            "https://www.oanda.com/fx-for-business/historical-rates/api/data/update/?&source=OANDA&adjustment=0&base_currency=' + @LocalCode + '&start_date=' + convert(varchar(10), @StartDate) + '&end_date=' + convert(varchar(10), @EndDate) + '&period=daily&price=ask&view=table' + @ForeignCodes + '"
        '

        set @SQL = 'exec xp_cmdshell ''' + replace(replace(replace(@SQL, '''', ''''''), char(10), ''), char(13), '') + ''''
        print @SQL
        exec(@SQL)


        delete from @CLOB

        --set @SQL =
        --    '
        --    select
        --        BulkColumn
        --    from
        --        openrowset
        --        (
        --            bulk ''e:\etl\data\oanda.json'',
        --            single_clob
        --        ) t
        --    '
        ----print @sql

        --2017-04-10, oanda changed their result string
        --insert into @CLOB (string)
        --exec (@sql)

        insert into @CLOB (string)
        select
            --BulkColumn,
            --charindex('{', BulkColumn, charindex('''data''', BulkColumn)),
            --charindex('{},{}', BulkColumn, charindex('params', BulkColumn)),
            --substring(BulkColumn, charindex('{', BulkColumn, charindex('''data''', BulkColumn)), charindex('{},{}', BulkColumn, charindex('params', BulkColumn)) - charindex('{', BulkColumn, charindex('''data''', BulkColumn)) - 1)
            BulkColumn
        from
            openrowset
            (
                bulk 'e:\etl\data\oanda.json',
                single_clob
            ) t

        insert into [db-au-cba]..fxHistoryJSON
        (
            LocalCode,
            FXStartDate,
            FXEndDate,
            FXJSON,
            FXSource
        )
        select
            @LocalCode,
            @StartDate,
            @EndDate,
            BulkColumn,
            'OANDA'
        from
            openrowset
            (
                bulk 'e:\etl\data\oanda.json',
                single_clob
            ) t




        if object_id('tempdb..#parsed') is not null
            drop table #parsed

        select 
            json_value(w.value, '$.baseCurrency') LocalCode,
            json_value(w.value, '$.quoteCurrency') ForeignCode,
            dateadd(second, try_convert(bigint, json_value(d.value, '$[0]')) / 1000, '1970-01-01') FXDate,
            try_convert(decimal(25,10), json_value(d.value, '$[1]')) FXRate,
            'Oanda' FXSource
        into #parsed
        from
            @CLOB t
            cross apply openjson(t.string, '$.widget') w
            cross apply openjson(w.value, '$.data') d

        delete t
        from
            #parsed r
            inner join [db-au-cba]..fxHistory t on
                t.LocalCode = r.LocalCode and
                t.ForeignCode = r.ForeignCode and
                t.FXDate = r.FXDate
        where
            t.FXSource = 'Oanda'

        insert into [db-au-cba]..fxHistory
        (
            LocalCode,
            ForeignCode,
            FXDate,
            FXRate,
            FXSource
        )
        select
            LocalCode,
            ForeignCode,
            FXDate,
            FXRate,
            FXSource
        from
            #parsed
        where
            FXDate is not null

        fetch next from c_pair into @LocalCode, @ForeignCodes

    end


    close c_pair
    deallocate c_pair




--    declare @local table (FX varchar(5))
--    declare @fx table (FX varchar(5))

--    insert into @local (FX) values ('AUD')
--    insert into @local (FX) values ('NZD')
--    insert into @local (FX) values ('GBP')
--    insert into @local (FX) values ('EUR')

--    insert into @local (FX) values ('USD')
--    insert into @local (FX) values ('INR')
--    insert into @local (FX) values ('SGD')


--    insert into @fx (FX) 
--    select 
--        replace(rtrim(ltrim(Item)), char(10), '')
--    from
--        dbo.fn_DelimitedSplit8K
--        (
--    --'CLP,IDR,ISK,KRW,MGA,PKR,TWD,TZS,VND',

--'AED,
--ARS,
--AUD,
--AZN,
--BGN,
--BND,
--CAD,
--CHF,
--CLP,
--CNH,
--CNY,
--CZK,
--DKK,
--EGP,
--EUR,
--FJD,
--GBP,
--HKD,
--HUF,
--IDR,
--ILS,
--INR,
--ISK,
--JPY,
--KRW,
--KWD,
--LKR,
--MAD,
--MGA,
--MXN,
--MYR,
--NOK,
--NZD,
--OMR,
--PEN,
--PGK,
--PHP,
--PKR,
--PLN,
--RUB,
--SAR,
--SBD,
--SCR,
--SEK,
--SGD,
--THB,
--TOP,
--TRY,
--TWD,
--TZS,
--USD,
--VEF,
--VEF,
--VND,
--VUV,
--WST,
--XOF,
--XPF,
--ZAR',
--            ','
--        )





--    declare @SQL varchar(max)
--    declare @CLOB table (string varchar(max), xmlstring XML)

--    declare c_pair cursor local for
--        select 
--            l.FX LocalCode,
--            f.FX ForeignCode
--        from
--            @local l,
--            @FX f
--        order by 1, 2

--    declare 
--        @LocalCode varchar(3), 
--        @ForeignCode varchar(3)


--    open c_pair

--    fetch next from c_pair into @LocalCode, @ForeignCode

--    while @@fetch_status = 0
--    begin

--        --10 year, fixedPeriod=3625

--        set @SQL = 
--        '
--        E:\ETL\Tool\wget64.exe 
--          --quiet
--          --output-document=e:\etl\data\' + @LocalCode+ '-' + @ForeignCode + '.html
--          --method POST
--          --header "accept: */*" 
--          --header "accept-language: en-AU,en;q=0.8,en-US;q=0.6,id;q=0.4" 
--          --header "content-length: 149"
--          --header "content-type: application/x-www-form-urlencoded; charset=UTF-8"
--          --header "cookie: slideNotificationBar=1; ASP.NET_SessionId=y4htxnopmorxdoknwykgblew; CURRENCY_CONVERTER_TYPE=CurrencyConverter; _ga=GA1.3.15358145.1485469967; _gat=1; _msuuid_fcbmlraza0=2D788E5F-8569-44F3-A9E1-8EE86E421438; __qca=P0-130039802-1485469967707"
--          --header "host: www.nzforex.co.nz"
--          --header "origin: http://www.nzforex.co.nz"
--          --header "proxy-connection: keep-alive"
--          --header "referer: http://www.nzforex.co.nz/forex-tools/historical-rate-tools/historical-exchange-rates"
--          --header "user-agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.67 Safari/537.36"
--          --header "x-requested-with: XMLHttpRequest"
--          --header "cache-control: no-cache"
--          --body-data 
--          "baseCurrency=' + @LocalCode+ '&termCurrency=' + @ForeignCode + '&roundTo=10&fixedPeriod=7&periodOptions=fixed&fromDate=01+Jan+2005&toDate=26+Jan+2017&X-Requested-With=XMLHttpRequest"
--          http://www.nzforex.co.nz/forex-tools/historical-rate-tools/historical-exchange-rates
--        '

--        set @SQL = 'exec xp_cmdshell ''' + replace(replace(replace(@SQL, '''', ''''''), char(10), ''), char(13), '') + ''''
--        --print @SQL
--        exec(@SQL)

--        set @SQL =
--            '
--            select
--                BulkColumn,
--                cast(substring(BulkColumn, charindex(''<tbody>'', BulkColumn), charindex(''</table>'', BulkColumn) - charindex(''<tbody>'', BulkColumn)) as xml) TableBody
--            from
--                openrowset
--                (
--                    bulk ''e:\etl\data\' + @LocalCode+ '-' + @ForeignCode + '.html'',
--                    single_clob
--                ) t
--            '

--        --print @sql

--        delete from @CLOB

--        insert into @CLOB (string, xmlstring)
--        exec (@sql)

--        if object_id('tempdb..#parsed') is not null
--            drop table #parsed
    
--        select --top 10
--            --t.TableBody,
--            @LocalCode LocalCode,
--            @ForeignCode ForeignCode,
--            try_convert(date, r.value('td[1]', 'varchar(20)'), 103) FXDate,
--            try_convert(decimal(25,10), replace(r.value('td[2]', 'varchar(40)'), ',', '')) FXRate,
--            'nzforex.co.nz' FXSource
--        into #parsed
--        from
--            @CLOB t
--            cross apply t.xmlstring.nodes('/tbody/tr') as tablerow(r)

--        delete t
--        from
--            #parsed r
--            inner join [db-au-cba]..fxHistory t on
--                t.LocalCode = r.LocalCode and
--                t.ForeignCode = r.ForeignCode and
--                t.FXDate = r.FXDate
--        where
--            t.FXSource = 'nzforex.co.nz'

--        insert into [db-au-cba]..fxHistory
--        (
--            LocalCode,
--            ForeignCode,
--            FXDate,
--            FXRate,
--            FXSource
--        )
--        select
--            LocalCode,
--            ForeignCode,
--            FXDate,
--            FXRate,
--            FXSource
--        from
--            #parsed
--        where
--            FXDate is not null

--        fetch next from c_pair into @LocalCode, @ForeignCode

--    end


--    close c_pair
--    deallocate c_pair


--    --xe.com

--    declare c_pairxe cursor local for
--        select 
--            l.FX LocalCode,
--            convert(varchar(10), d.[Date], 120) FXDate
--        from
--            @local l,
--            [db-au-cba]..Calendar d
--        where
--            d.[Date] >= dateadd(day, -7, convert(date, getdate())) and
--            d.[Date] <  convert(date, getdate())
--        order by 1, 2

--    declare 
--        @FXDate varchar(10)

--    open c_pairxe

--    fetch next from c_pairxe into @LocalCode, @FXDate

--    while @@fetch_status = 0
--    begin

--        set @SQL = 
--        '
--        E:\ETL\Tool\wget64.exe 
--            --quiet
--            --header ''cache-control: no-cache''
--            --output-document=e:\etl\data\' + @LocalCode+ '-' + @FXDate + '.html
--            --method GET
--            "http://www.xe.com/currencytables/?from=' + @LocalCode+ '&date=' + @FXDate + '"'

--        set @SQL = 'exec xp_cmdshell ''' + replace(replace(replace(@SQL, '''', ''''''), char(10), ''), char(13), '') + ''''
--        --print @SQL
--        exec(@SQL)

--        set @SQL =
--            '
--            select 
--                cast(BodyXML as xml) BodyXML
--            from
--                (
--                    select
--                        BulkColumn
--                    from
--                        openrowset
--                        (
--                    bulk ''e:\etl\data\' + @LocalCode+ '-' + @FXDate + '.html'',
--                            single_clob
--                        ) t
--                ) t
--                cross apply
--                (
--                    select
--                        charindex(''<table id=''''historicalRateTbl'', t.BulkColumn) TableStart
--                ) ts
--                cross apply
--                (
--                    select
--                        charindex(''<tbody>'', t.BulkColumn, ts.TableStart) TableBodyStart,
--                        charindex(''</table>'', t.BulkColumn, ts.TableStart) TableBodyEnd
--                ) tb
--                cross apply
--                (
--                    select
--                        replace
--                        (
--                            replace(
--                                substring(BulkColumn, tb.TableBodyStart, tb.TableBodyEnd - TableBodyStart),
--                                ''&iacute;'',
--                                ''y''
--                            ),
--                            ''&#237;'',
--                            ''y''
--                        ) BodyXML
--                ) bx
--            '

--        --print @sql

--        delete from @CLOB

--        insert into @CLOB (xmlstring)
--        exec (@sql)


--        if object_id('tempdb..#parsedxe') is not null
--            drop table #parsedxe
    
--        select --top 10
--            --t.TableBody,
--            @LocalCode LocalCode,
--            replace(r.value('td[1]', 'varchar(100)'), ',', '') ForeignCode,
--            @FXDate FXDate,
--            try_convert(decimal(25,10), replace(r.value('td[3]', 'varchar(40)'), ',', '')) FXRate,
--            'xe.com' FXSource
--        into #parsedxe
--        from
--            @CLOB t
--            cross apply t.xmlstring.nodes('/tbody/tr') as tablerow(r)

--        delete t
--        from
--            #parsedxe r
--            inner join [db-au-cba]..fxHistory t on
--                t.LocalCode = r.LocalCode and
--                t.ForeignCode = r.ForeignCode and
--                t.FXDate = r.FXDate
--        where
--            t.FXSource = 'xe.com'

--        insert into [db-au-cba]..fxHistory
--        (
--            LocalCode,
--            ForeignCode,
--            FXDate,
--            FXRate,
--            FXSource
--        )
--        select
--            LocalCode,
--            ForeignCode,
--            FXDate,
--            FXRate,
--            FXSource
--        from
--            #parsedxe
--        where
--            FXDate is not null



--        fetch next from c_pairxe into @LocalCode, @FXDate

--    end

--    close c_pairxe

--    deallocate c_pairxe



end


GO
