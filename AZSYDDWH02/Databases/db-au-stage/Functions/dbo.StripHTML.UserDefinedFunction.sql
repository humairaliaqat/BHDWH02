USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[StripHTML]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[StripHTML]( @text varchar(max) ) returns varchar(max) as
begin
    declare @textXML xml
    declare @result varchar(max)
    set @textXML = REPLACE( @text, '&', '' );
    with doc(contents) as
    (
        select chunks.chunk.query('.') from @textXML.nodes('/') as chunks(chunk)
    )
    select @result = contents.value('.', 'varchar(max)') from doc
    return @result
end

GO
