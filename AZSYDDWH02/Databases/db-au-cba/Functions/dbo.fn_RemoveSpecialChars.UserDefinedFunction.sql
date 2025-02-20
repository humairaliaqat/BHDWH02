USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RemoveSpecialChars]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_RemoveSpecialChars] (@s varchar(256)) returns varchar(256)
   with schemabinding

/************************************************************************************/
-- This function removes ASCII characters that are not between 32 and 122
/************************************************************************************/

begin
   if @s is null
      return null

   declare @s2 varchar(256)
   set @s2 = ''

   declare @l int
   set @l = len(@s)
   
   declare @p int
   set @p = 1
   
   while @p <= @l begin
      declare @c int
      set @c = ascii(substring(@s, @p, 1))
      if @c between 32 and 122
         set @s2 = @s2 + char(@c)
      set @p = @p + 1
      end
   if len(@s2) = 0
      return null
   return @s2
   end
GO
