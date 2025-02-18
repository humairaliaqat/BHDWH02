USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [cng].[Update_Claim_Tables]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [cng].[Update_Claim_Tables]
AS

--ClaimDataSet
    PRINT 'ClaimDataSet'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    DECLARE @ClaimDataSet nvarchar(100)
    SET @ClaimDataSet = (SELECT TOP 1 Name FROM           [db-au-actuary].[sys].[tables] WHERE Name LIKE 'out_ClaimDataSet_%_Zurich' ORDER BY Name DESC)
  --SET @ClaimDataSet = (SELECT TOP 1 Name FROM [ULDWH02].[db-au-actuary].[sys].[tables] WHERE Name LIKE 'out_ClaimDataSet_%'        ORDER BY Name DESC)
    PRINT @ClaimDataSet

    DECLARE @ClaimDataSet_CBA nvarchar(100)
    SET @ClaimDataSet_CBA = (SELECT TOP 1 Name FROM              [db-au-actuary].[sys].[tables] WHERE Name LIKE 'out_Claim_%_Zurich_CBA' ORDER BY Name DESC)
  --SET @ClaimDataSet_CBA = (SELECT TOP 1 Name FROM [AZSYDDWH02].[db-au-actuary].[sys].[tables] WHERE Name LIKE 'out_ClaimDataSet_%'     ORDER BY Name DESC)
    PRINT @ClaimDataSet_CBA

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[ClaimDataSet]') AND type in (N'U'))
    DROP TABLE [cng].[ClaimDataSet];

    DECLARE @sql1 nvarchar(MAX) 
    SET @sql1 =
        'WITH ClaimDataSet AS ( ' + 
            'SELECT * FROM [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] WITH(NOLOCK) ' +
            'UNION ALL ' + 
            'SELECT * FROM [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA + '] WITH(NOLOCK) ' +
        ')' +
        'SELECT * INTO [db-au-actuary].[cng].[ClaimDataSet] FROM ClaimDataSet;'
    EXECUTE sp_executesql @sql1;

    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID('[cng].[ClaimDataSet]'))
        BEGIN
      --CREATE CLUSTERED    INDEX idx_ClaimDataSet_ClaimKeySectionID        ON [db-au-actuary].[cng].[ClaimDataSet] ([ClaimKey],[SectionID]);
        CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKeySectionID        ON [db-au-actuary].[cng].[ClaimDataSet] ([ClaimKey],[SectionID]);
        CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKey                 ON [db-au-actuary].[cng].[ClaimDataSet] ([ClaimKey]);
        CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimNo                  ON [db-au-actuary].[cng].[ClaimDataSet] ([ClaimNo]);
        CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyProductCode     ON [db-au-actuary].[cng].[ClaimDataSet] ([PolicyKey],[ProductCode]);
        CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyJVCode          ON [db-au-actuary].[cng].[ClaimDataSet] ([PolicyKey],[JVCode]);
        END

    DECLARE @sql2 nvarchar(MAX) 
    SET @sql2 =
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID(''[dataout].[' + @ClaimDataSet     + ']'')) ' + 
            'BEGIN ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKeySectionID         ON [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] ([ClaimKey],[SectionID]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKey                  ON [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] ([ClaimKey]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimNo                   ON [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] ([ClaimNo]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyProductCode      ON [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] ([PolicyKey],[ProductCode]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyJVCode           ON [db-au-actuary].[dataout].[' + @ClaimDataSet     + '] ([PolicyKey],[JVCode]); ' + 
            'END '
    EXECUTE sp_executesql @sql2;

    DECLARE @sql3 nvarchar(MAX) 
    SET @sql3 =
        'IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID(''[dataout].[' + @ClaimDataSet_CBA  + ']'')) ' + 
            'BEGIN ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKeySectionID         ON [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA  + '] ([ClaimKey],[SectionID]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimKey                  ON [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA  + '] ([ClaimKey]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_ClaimNo                   ON [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA  + '] ([ClaimNo]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyProductCode      ON [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA  + '] ([PolicyKey],[ProductCode]); ' + 
            'CREATE NONCLUSTERED INDEX idx_ClaimDataSet_PolicyKeyJVCode           ON [db-au-actuary].[dataout].[' + @ClaimDataSet_CBA  + '] ([PolicyKey],[JVCode]); ' + 
            'END '
    EXECUTE sp_executesql @sql3;


--clmEvent
    PRINT 'clmEvent'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[clmEvent]') AND type in (N'U'))
    DROP TABLE [cng].[clmEvent];

    WITH clmEvent AS (
        SELECT * FROM  [ULDWH02].[db-au-cmdwh].[dbo].[clmEvent] WITH(NOLOCK)
        UNION ALL 
        SELECT * FROM [AZSYDDWH02].[db-au-CBA].[dbo].[clmEvent] WITH(NOLOCK)
        WHERE [EventKey] NOT IN (SELECT [EventKey] FROM [ULDWH02].[db-au-cmdwh].[dbo].[clmEvent]  WITH(NOLOCK))
    )

    SELECT * INTO [db-au-actuary].[cng].[clmEvent] FROM clmEvent;

  --CREATE CLUSTERED    INDEX idx_clmEvent_BIRowID          ON [db-au-actuary].[cng].[clmEvent] ([BIRowID]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_BIRowID          ON [db-au-actuary].[cng].[clmEvent] ([BIRowID]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_CatastropheCode  ON [db-au-actuary].[cng].[clmEvent] ([CatastropheCode]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_ClaimKey         ON [db-au-actuary].[cng].[clmEvent] ([ClaimKey]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_ClaimNo          ON [db-au-actuary].[cng].[clmEvent] ([ClaimNo]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_EventKey         ON [db-au-actuary].[cng].[clmEvent] ([EventKey]);
    CREATE NONCLUSTERED INDEX idx_clmEvent_PerilCode        ON [db-au-actuary].[cng].[clmEvent] ([PerilCode]);


--clmSection
    PRINT 'clmSection'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[clmSection]') AND type in (N'U'))
    DROP TABLE [cng].[clmSection];

    WITH 
    clmSection AS (
        SELECT * FROM  [ULDWH02].[db-au-cmdwh].[dbo].[clmSection] WITH(NOLOCK)
        UNION ALL 
        SELECT * FROM [AZSYDDWH02].[db-au-CBA].[dbo].[clmSection] WITH(NOLOCK)
    ),

    clmSection1 AS (
        SELECT ROW_NUMBER() OVER (PARTITION BY [CountryKey],[ClaimNo],[EventID],[SectionID] ORDER BY [BIRowID] DESC) AS [Rank]
              ,CONCAT([CountryKey],'-',[ClaimNo],'-',[EventID],'-',[SectionID]) AS [SectionKey]
              ,[SectionCode]
              ,[SectionDescription]
              ,[BenefitLimit]
        FROM clmSection
    )

    SELECT * INTO [db-au-actuary].[cng].[clmSection] FROM clmSection1 WHERE [Rank] = 1;

  --CREATE CLUSTERED    INDEX idx_clmSection_SectionKey ON [db-au-actuary].[cng].[clmSection] ([SectionKey]);
    CREATE NONCLUSTERED INDEX idx_clmSection_SectionKey ON [db-au-actuary].[cng].[clmSection] ([SectionKey]);
 

--e5CaseNotes
    PRINT 'e5CaseNotes'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[e5WorkCaseNote]') AND type in (N'U'))
    DROP TABLE [cng].[e5WorkCaseNote];

    WITH e5WorkCaseNote AS (
        SELECT a.*,b.[ClaimNumber]
        FROM        [ULDWH02].[db-au-cmdwh].[dbo].[e5WorkCaseNote] a WITH(NOLOCK)
        INNER JOIN  [ULDWH02].[db-au-cmdwh].[dbo].[e5Work]         b WITH(NOLOCK) ON a.Work_ID = b.Work_Id
        UNION ALL
                SELECT a.*,b.[ClaimNumber]
        FROM       [AZSYDDWH02].[db-au-CBA].[dbo].[e5WorkCaseNote] a WITH(NOLOCK)
        INNER JOIN [AZSYDDWH02].[db-au-CBA].[dbo].[e5Work]         b WITH(NOLOCK) ON a.Work_ID = b.Work_Id
    )

    SELECT * INTO [db-au-actuary].[cng].[e5WorkCaseNote] FROM e5WorkCaseNote;

  --CREATE CLUSTERED    INDEX idx_e5WorkCaseNote_BIRowID    ON [db-au-actuary].[cng].[e5WorkCaseNote] ([BIRowID]);
    CREATE NONCLUSTERED INDEX idx_e5WorkCaseNote_BIRowID    ON [db-au-actuary].[cng].[e5WorkCaseNote] ([BIRowID]);
    CREATE NONCLUSTERED INDEX idx_e5WorkCaseNot_ClaimNumber ON [db-au-actuary].[cng].[e5WorkCaseNote] ([ClaimNumber]);


--KLCatas
    PRINT 'KLCatas'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[KLCatas]') AND type in (N'U'))
    DROP TABLE [cng].[KLCatas];

    WITH 
    KLCatas AS (
        SELECT *
        FROM [ULSQLAGR03].[CLAIMS].[dbo].[KLCATAS]  a
        JOIN [ULSQLAGR03].[CLAIMS].[dbo].[KLDOMAIN] b ON a.[KLDOMAINID] = b.[DomainId]
    )

    SELECT * INTO [db-au-actuary].[cng].[KLCatas] FROM KLCatas;

  --CREATE CLUSTERED    INDEX idx_KLCatas_KC_Code ON [db-au-actuary].[cng].[KLCatas] ([KC_Code]);
    CREATE NONCLUSTERED INDEX idx_KLCatas_KC_Code ON [db-au-actuary].[cng].[KLCatas] ([KC_Code]);


--Claim Header
    PRINT 'Claim Header'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    --IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Claim_Header_Table]') AND type in (N'U'))
    --DROP TABLE [cng].[Claim_Header_Table];
    
    SELECT * INTO [db-au-actuary].[cng].[Claim_Header_Table_1] FROM [db-au-actuary].[cng].[Claim_Header];

  --CREATE CLUSTERED    INDEX idx_Claim_Header_Table_ClaimKeySectionID      ON [db-au-actuary].[cng].[Claim_Header_Table_1]   ([ClaimKey],[SectionID]);
    CREATE NONCLUSTERED INDEX idx_Claim_Header_Table_ClaimKeySectionID      ON [db-au-actuary].[cng].[Claim_Header_Table_1]   ([ClaimKey],[SectionID]);
    CREATE NONCLUSTERED INDEX idx_Claim_Header_Table_ClaimKey               ON [db-au-actuary].[cng].[Claim_Header_Table_1]   ([ClaimKey]);
    CREATE NONCLUSTERED INDEX idx_Claim_Header_Table_ClaimNo                ON [db-au-actuary].[cng].[Claim_Header_Table_1]   ([ClaimNo]);
    CREATE NONCLUSTERED INDEX idx_Claim_Header_Table_PolicyKeyProductCode   ON [db-au-actuary].[cng].[Claim_Header_Table_1]   ([PolicyKey],[ProductCode]);

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Claim_Header_Table]') AND type in (N'U'))
    DROP TABLE [cng].[Claim_Header_Table];
    EXEC SP_RENAME 'cng.Claim_Header_Table_1', 'Claim_Header_Table';
    
    
--Claim Transactions
    PRINT 'Claim Transactions'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    --IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Claim_Transactions_Table]') AND type in (N'U'))
    --DROP TABLE [cng].[Claim_Transactions_Table];
    
    SELECT * INTO [db-au-actuary].[cng].[Claim_Transactions_Table_1] FROM [db-au-actuary].[cng].[Claim_Transactions];

  --CREATE CLUSTERED    INDEX idx_Claim_Transactions_Table_ClaimKeySectionID      ON [db-au-actuary].[cng].[Claim_Transactions_Table_1]   ([ClaimKey],[SectionID]);
    CREATE NONCLUSTERED INDEX idx_Claim_Transactions_Table_ClaimKeySectionID      ON [db-au-actuary].[cng].[Claim_Transactions_Table_1]   ([ClaimKey],[SectionID]);
    CREATE NONCLUSTERED INDEX idx_Claim_Transactions_Table_ClaimKey               ON [db-au-actuary].[cng].[Claim_Transactions_Table_1]   ([ClaimKey]);
    CREATE NONCLUSTERED INDEX idx_Claim_Transactions_Table_ClaimNo                ON [db-au-actuary].[cng].[Claim_Transactions_Table_1]   ([ClaimNo]);
    CREATE NONCLUSTERED INDEX idx_Claim_Transactions_Table_PolicyKeyProductCode   ON [db-au-actuary].[cng].[Claim_Transactions_Table_1]   ([PolicyKey],[ProductCode]);

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Claim_Transactions_Table]') AND type in (N'U'))
    DROP TABLE [cng].[Claim_Transactions_Table];
    EXEC SP_RENAME 'cng.Claim_Transactions_Table_1', 'Claim_Transactions_Table';
    
GO
