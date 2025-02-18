USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [ms].[Age_Banding]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [ms].[Age_Banding] 
(
	-- Add the parameters for the function here
	@AgeTravel int
)
RETURNS varchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @AgeBand varchar(50)

	-- Add the T-SQL statements to compute the return value here
	--SELECT <@ResultVar, sysname, @Result> = <@Param1, sysname, @p1>
	set @AgeBand = 
	case
		when @AgeTravel =1 then '0-24'
		when @AgeTravel =2 then '0-24'
		when @AgeTravel =3 then '0-24'
		when @AgeTravel =4 then '0-24'
		when @AgeTravel =5 then '0-24'
		when @AgeTravel =6 then '0-24'
		when @AgeTravel =7 then '0-24'
		when @AgeTravel =8 then '0-24'
		when @AgeTravel =9 then '0-24'
		when @AgeTravel =10 then '0-24'
		when @AgeTravel =11 then '0-24'
		when @AgeTravel =12 then '0-24'
		when @AgeTravel =13 then '0-24'
		when @AgeTravel =14 then '0-24'
		when @AgeTravel =15 then '0-24'
		when @AgeTravel =16 then '0-24'
		when @AgeTravel =17 then '0-24'
		when @AgeTravel =18 then '0-24'
		when @AgeTravel =19 then '0-24'
		when @AgeTravel =20 then '0-24'
		when @AgeTravel =21 then '0-24'
		when @AgeTravel =22 then '0-24'
		when @AgeTravel =23 then '0-24'
		when @AgeTravel =24 then '0-24'
		when @AgeTravel =25 then '25-44'
		when @AgeTravel =26 then '25-44'
		when @AgeTravel =27 then '25-44'
		when @AgeTravel =28 then '25-44'
		when @AgeTravel =29 then '25-44'
		when @AgeTravel =30 then '25-44'
		when @AgeTravel =31 then '25-44'
		when @AgeTravel =32 then '25-44'
		when @AgeTravel =33 then '25-44'
		when @AgeTravel =34 then '25-44'
		when @AgeTravel =35 then '25-44'
		when @AgeTravel =36 then '25-44'
		when @AgeTravel =37 then '25-44'
		when @AgeTravel =38 then '25-44'
		when @AgeTravel =39 then '25-44'
		when @AgeTravel =40 then '25-44'
		when @AgeTravel =41 then '25-44'
		when @AgeTravel =42 then '25-44'
		when @AgeTravel =43 then '25-44'
		when @AgeTravel =44 then '25-44'
		when @AgeTravel =45 then '45-49'
		when @AgeTravel =46 then '45-49'
		when @AgeTravel =47 then '45-49'
		when @AgeTravel =48 then '45-49'
		when @AgeTravel =49 then '45-49'
		when @AgeTravel =50 then '50-59'
		when @AgeTravel =51 then '50-59'
		when @AgeTravel =52 then '50-59'
		when @AgeTravel =53 then '50-59'
		when @AgeTravel =54 then '50-59'
		when @AgeTravel =55 then '50-59'
		when @AgeTravel =56 then '50-59'
		when @AgeTravel =57 then '50-59'
		when @AgeTravel =58 then '50-59'
		when @AgeTravel =59 then '50-59'
		when @AgeTravel =60 then '60-64'
		when @AgeTravel =61 then '60-64'
		when @AgeTravel =62 then '60-64'
		when @AgeTravel =63 then '60-64'
		when @AgeTravel =64 then '60-64'
		when @AgeTravel =65 then '65-69'
		when @AgeTravel =66 then '65-69'
		when @AgeTravel =67 then '65-69'
		when @AgeTravel =68 then '65-69'
		when @AgeTravel =69 then '65-69'
		when @AgeTravel =70 then '70-72'
		when @AgeTravel =71 then '70-72'
		when @AgeTravel =72 then '70-72'
		when @AgeTravel =73 then '73-74'
		when @AgeTravel =74 then '73-74'
		when @AgeTravel =75 then '75-76'
		when @AgeTravel =76 then '75-76'
		when @AgeTravel =77 then '77-79'
		when @AgeTravel =78 then '77-79'
		when @AgeTravel =79 then '77-79'
		when @AgeTravel =80 then '80-81'
		when @AgeTravel =81 then '80-81'
		when @AgeTravel =82 then '82-84'
		when @AgeTravel =83 then '82-84'
		when @AgeTravel =84 then '82-84'
		when @AgeTravel =85 then '85-89'
		when @AgeTravel =86 then '85-89'
		when @AgeTravel =87 then '85-89'
		when @AgeTravel =88 then '85-89'
		when @AgeTravel =89 then '85-89'
		when @AgeTravel =90 then '90-99'
		when @AgeTravel =91 then '90-99'
		when @AgeTravel =92 then '90-99'
		when @AgeTravel =93 then '90-99'
		when @AgeTravel =94 then '90-99'
		when @AgeTravel =95 then '90-99'
		when @AgeTravel =96 then '90-99'
		when @AgeTravel =97 then '90-99'
		when @AgeTravel =98 then '90-99'
		when @AgeTravel =99 then '90-99'


	end
	-- Return the result of the function
	RETURN @AgeBand

END
GO
