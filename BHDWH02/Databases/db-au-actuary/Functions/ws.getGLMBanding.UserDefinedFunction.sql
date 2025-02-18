USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [ws].[getGLMBanding]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [ws].[getGLMBanding]
(
    @FactorName varchar(255),
    @Value decimal(16,6)
)
returns varchar(500)
as
begin

    declare @Band varchar(500)
    
    select 
        @Band = [Band]
    from
        ws.GLMBanding
    where
        [Factor Name] = @FactorName and
        [Minimum Value] <= @Value and
        [Maximum Value] >= @Value

    return @Band

end
GO
