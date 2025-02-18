USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spMaterialiseClaimDataSet]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spMaterialiseClaimDataSet]
as
begin

    declare @date date
    declare @output varchar(max)

    set @date = dateadd(day, -1, convert(date, convert(varchar(8), getdate(), 120) + '01'))
    set @output = 'out_ClaimDataSet_' + replace(convert(varchar(8), getdate(), 120), '-', '')

    print @output


    if
        exists
        (
            select 
                null
            from
                [db-au-cmdwh]..fxHistory
            where
                FXSource = 'Zurich' and
                FXDate = convert(varchar(10), @date, 120)
        )
    begin

        if not exists
        (
            select
                null
            from
                [db-au-actuary].INFORMATION_SCHEMA.TABLES
            where
                TABLE_SCHEMA = 'dataout' and
                TABLE_NAME like @output + '%'
        )
        begin

            --Zurich
            exec [db-au-actuary].[dbo].[spClaimDataSet]
                @Domain = 'AU,NZ',
                @FXReferenceDate = @date,
                @FXCode = 'Zurich'



            --GLM
            --20180606, LL, just copy the whole GLM FX thing
            insert into [db-au-cmdwh]..fxHistory
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
                @date FXDate,
                min(FXRate),
                'GLM' FXSource
            from
                [db-au-cmdwh]..fxHistory
            where
                FXSource = 'GLM'
            group by
                LocalCode,
                ForeignCode

            exec [db-au-actuary].[dbo].[spClaimDataSet]
                @Domain = 'AU',
                @FXReferenceDate = @date,
                @FXCode = 'GLM'


            --send email here
            declare @result varchar(512)

            exec msdb..sp_send_dbmail 
                @profile_name='covermorereport',
                @recipients='Pricing@covermore.com.au;BusinessIntelligence@covermore.com.au',
                @subject='Actuarial claim dataset processed',
                @body=''

        end

    end


end
GO
