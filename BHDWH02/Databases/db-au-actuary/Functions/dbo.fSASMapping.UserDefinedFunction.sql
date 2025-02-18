USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [dbo].[fSASMapping]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fSASMapping] 
(
    @FieldName varchar(64), 
    @Value nvarchar(255)
)
returns nvarchar(255)
as
begin

    declare @result nvarchar(255)
    set @result = null
    
    select top 1 
        @result = MappedValue
    from
        ws.SASMapping
    where
        FieldName = @FieldName and
        OriginalValue = @Value
    
    return @result
    ;
end
GO
