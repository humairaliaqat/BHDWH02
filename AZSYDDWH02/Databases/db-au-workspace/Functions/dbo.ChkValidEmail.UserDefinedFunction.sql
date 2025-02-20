USE [db-au-workspace]
GO
/****** Object:  UserDefinedFunction [dbo].[ChkValidEmail]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE FUNCTION [dbo].[ChkValidEmail](@EMAIL varchar(100))RETURNS bit as  
  
BEGIN  
DECLARE @bitEmailVal as Bit  
DECLARE @EmailText varchar(100)  
  
SET @EmailText=ltrim(rtrim(isnull(@EMAIL,'')))  
  
SET @bitEmailVal = case when @EmailText = '' then 0  
when @EmailText like '% %' then 0  
when @EmailText like ('%["(),:;<>\]%') then 0  
when substring(@EmailText,charindex('@',@EmailText),len(@EmailText)) like ('%[!#$%&*+/=?^`_{|]%') then 0  
when (left(@EmailText,1) like ('[-_.+]') or right(@EmailText,1) like ('[-_.+]')) then 0                                                                                     
when (@EmailText like '%[%' or @EmailText like '%]%') then 0  
when @EmailText LIKE '%@%@%' then 0  
when @EmailText NOT LIKE '_%@_%._%' then 0  
else 1  
end  
RETURN @bitEmailVal  
END  
GO
