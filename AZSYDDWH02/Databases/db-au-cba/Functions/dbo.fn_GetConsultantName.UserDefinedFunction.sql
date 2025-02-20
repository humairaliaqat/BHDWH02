USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetConsultantName]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_GetConsultantName](@ConsultantKey varchar(13))
returns varchar(50)
as
begin

  declare @cname varchar(13)
  
  select top 1 @cname = ConsultantName
  from Consultant c
  where c.ConsultantKey = @ConsultantKey

  if @cname is null
    select top 1 @cname = ConsultantName
    from Policy
    where 
      ConsultantKey = @ConsultantKey and
      ConsultantName is not null and
      ConsultantName <> ''

  return @cname 
  
end



GO
