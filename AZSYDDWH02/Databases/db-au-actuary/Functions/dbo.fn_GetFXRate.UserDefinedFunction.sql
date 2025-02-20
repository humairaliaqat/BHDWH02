USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetFXRate]    Script Date: 20/02/2025 10:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_GetFXRate]
(
    @LocalCurrencyCode varchar(5),
    @ForeignCurrencyCode varchar(5),
    @ReferenceDate datetime,
    @Source varchar(50) = 'Oanda'
)
returns 
@output table
(
    FXDate date,
    FXRate decimal(25,10)
)
as
begin

    declare 
        @fxdate date,
        @fxrate decimal(25,10)

    select top 1 
        @fxdate = fx.FXDate,
        @fxrate = fx.FXRate
    from
        [db-au-cba].dbo.fxHistory fx with(nolock)
    where
        fx.LocalCode = @LocalCurrencyCode and
        fx.ForeignCode = @ForeignCurrencyCode and
        fx.FXDate >= dateadd(day, -3, convert(date, @ReferenceDate)) and
        fx.FXDate <= convert(date, @ReferenceDate) and
        fx.FXSource = @Source
    order by
        fx.FXDate desc

    if @fxdate is null
    begin

        select top 1 
            @fxdate = fx.FXEndDate,
            @fxrate = fx.FXRate
        from
            [db-au-cba].dbo.fxHistoryAverage fx with(nolock)
        where
            fx.LocalCode = @LocalCurrencyCode and
            fx.ForeignCode = @ForeignCurrencyCode and
            fx.FXStartDate <= convert(date, @ReferenceDate) and
            fx.FXEndDate >= convert(date, @ReferenceDate) and
            fx.FXSource = @Source
        order by
            fx.FXStartDate desc
    
    end

    insert into @output (FXDate, FXRate) values (@fxdate, @fxrate)

    return

end

GO
