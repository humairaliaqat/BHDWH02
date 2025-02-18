USE [db-au-actuary]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetTotalWorkingDaysUsingLoop]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--use [db-au-actuary]
CREATE FUNCTION [dbo].[fn_GetTotalWorkingDaysUsingLoop]
(@DateFrom DATE,
@DateTo   DATE
)
RETURNS INT
AS
     BEGIN
         DECLARE @TotWorkingDays INT= 0;
         WHILE @DateFrom <= @DateTo
             BEGIN
                 IF DATENAME(WEEKDAY, @DateFrom) IN('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
                     BEGIN
                         SET @TotWorkingDays = @TotWorkingDays + 1;
                 END;
                 SET @DateFrom = DATEADD(DAY, 1, @DateFrom);
             END;
         RETURN @TotWorkingDays;
     END;
GO
