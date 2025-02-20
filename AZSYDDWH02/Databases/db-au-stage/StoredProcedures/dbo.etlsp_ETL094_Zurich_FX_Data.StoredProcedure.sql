USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL094_Zurich_FX_Data]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--CREATE
CREATE 
PROCEDURE [dbo].[etlsp_ETL094_Zurich_FX_Data]
AS

  --SET NOCOUNT ON


  /****************************************************************************************************/
  --  Name:           etlsp_ETL094_Zurich_FX_Data
  --  Author:         Linus Tor
  --  Date Created:   20190703
  --  Description:    This stored procedure to load Zurich Fx data.
  --  Parameters:     
  --  
  --  Change History: 20190703 - LT - Created
  --                  20190704 - RS - Polished as requested :)
  --
  /****************************************************************************************************/

  --uncomment to debug
  /*
  */

  DECLARE @filename varchar(256)
  DECLARE @filecount int
  DECLARE @sql nvarchar(4000)
  DECLARE @AUDRate decimal(25, 10)
  DECLARE @NZDRate decimal(25, 10)
  DECLARE @FXDate date
  DECLARE @tmpString varchar(100)

  BEGIN

    CREATE TABLE #FileName (
      [FileName] varchar(256)
    );

    INSERT INTO #FileName
    EXEC xp_cmdshell 'dir "e:\ETL\Data\FX Data\USD_End&Avrg. rates_*.csv" /b';

    --take count of files to make sure only a single file gets processed
    SELECT
      @filecount = COUNT(*)
    FROM #FileName
    WHERE FileName LIKE 'USD%';

    --print(@filecount)

    --stop if multiple files found in the directory
    IF @filecount > 1
      RAISERROR ('Multiple FX files present', -- Message text.
      16, -- Severity.
      1 -- State.
      );
    ELSE
      SELECT
        @filename = [FileName]
      FROM #FileName
      WHERE FileName LIKE 'USD%';

    PRINT ('Processing file:' + @filename)

    --DROP TABLE #fx;

    CREATE TABLE #fx (
      ForeignCode nvarchar(100) NULL,
      [Description] nvarchar(300) NULL,
      [MonthEndFXRate] varchar(100) NULL,
      [YTDFXAverage] varchar(100) NULL
    )



    SET @sql = 'bulk insert #fx
from ''e:\ETL\Data\FX Data\' + @filename + '''
with
(
	FIRSTROW = 1,
	FIELDTERMINATOR = '';''
)'

    --print(@sql)
    PRINT ('Loading table #fx')
    EXEC (@sql)

    --select * from #fx;

    --get @AUDRate
    SELECT
      @AUDRate = [MonthEndFXRate]
    FROM #fx
    WHERE ForeignCode = 'AUD'

    --get @NZDRate
    SELECT
      @NZDRate = [MonthEndFXRate]
    FROM #fx
    WHERE ForeignCode = 'NZD'

    --get FX date string and convert to datetime
    SELECT
      @tmpString = RIGHT([db-au-cba].dbo.fn_RemoveSpecialChars([Description]), 10)
    FROM #fx
    WHERE [Description] LIKE 'Exchange rates%'

    SELECT
      @FXDate = CONVERT(date, RIGHT(@tmpString, 4) + '-' + SUBSTRING(@tmpString, 4, 2) + '-' + LEFT(@tmpString, 2))

    --delete unwanted rows
    DELETE #fx
    WHERE ForeignCode IS NULL
      OR ForeignCode = 'ISO Code';

    --delete if already exists
    delete [db-au-cba].dbo.fxHistory
    where FXDate = @FXDate and FXSource = 'Zurich'

    --insert records to final table
    insert [db-au-cba].dbo.fxHistory
    (
    	LocalCode,
    	ForeignCode,
    	FXDate,
    	FXRate,
    	FXSource
    )
    SELECT
      'AUD' AS LocalCode,
      LEFT(ForeignCode, 5) AS ForeignCode,
      @FXDate,
      1 / (CONVERT(float, [MonthEndFXRate]) / @AUDRate) AS FXRate,
      'Zurich' AS FXSource
    FROM #fx
    UNION ALL
    SELECT
      'NZD' AS LocalCode,
      ForeignCode,
      @FXDate,
      1 / (CONVERT(float, [MonthEndFXRate]) / @NZDRate) AS FXRate,
      'Zurich' AS FXSource
    FROM #fx
    UNION ALL
    --USD is not in the FX data file. This will insert USD rate for AUD and NZD
    SELECT
      'AUD' AS LocalCode,
      'USD' AS ForeignCode,
      @FXDate,
      1 / (100 / @AUDRate) AS FXRate,
      'Zurich' AS FXSource
    UNION ALL
    SELECT
      'NZD' AS LocalCode,
      'USD' AS ForeignCode,
      @FXDate,
      1 / (100 / @NZDRate) AS FXRate,
      'Zurich' AS FXSource
  END;
GO
