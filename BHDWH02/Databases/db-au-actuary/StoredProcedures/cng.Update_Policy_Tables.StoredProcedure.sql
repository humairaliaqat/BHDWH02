USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [cng].[Update_Policy_Tables]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [cng].[Update_Policy_Tables] AS

--DWHDataSetSummary
    PRINT 'DWHDataSetSummary'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    SELECT MAX([Issue Date]) FROM    [uldwh02].[db-au-actuary].[ws].[DWHDataSetSummary];
    SELECT MAX([Issue Date]) FROM    [uldwh02].[db-au-actuary].[ws].[DWHDataSet];
    SELECT MAX([Issue Date]) FROM [azsyddwh02].[db-au-actuary].[ws].[DWHDataSetSummary];
    SELECT MAX([Issue Date]) FROM [azsyddwh02].[db-au-actuary].[ws].[DWHDataSet];
    SELECT MAX([Issue Date]) FROM    [bhdwh02].[db-au-actuary].[ws].[DWHDataSetSummary];
    SELECT MAX([Issue Date]) FROM    [bhdwh02].[db-au-actuary].[ws].[DWHDataSet];
    SELECT MAX([Issue Date]) FROM    [bhdwh02].[db-au-actuary].[ws].[DWHDataSetSummary_CBA];
    SELECT MAX([Issue Date]) FROM    [bhdwh02].[db-au-actuary].[ws].[DWHDataSet_CBA];
    
    --DROP TABLE [db-au-actuary].[ws].[DWHDataSetSummary];
    --SELECT * INTO [db-au-actuary].[ws].[DWHDataSetSummary]     FROM    [uldwh02].[db-au-actuary].[ws].[DWHDataSetSummary];
    --DROP TABLE [db-au-actuary].[ws].[DWHDataSetSummary_CBA];
    --SELECT * INTO [db-au-actuary].[ws].[DWHDataSetSummary_CBA] FROM [azsyddwh02].[db-au-actuary].[ws].[DWHDataSetSummary];

    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Product Group] = IIF([Product Group] = 'UNKNOWN'           ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Product Group] = IIF([Product Group] = 'UNKNOWN'           ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Product Group] = IIF([Product Group] IS NULL               ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Product Group] = IIF([Product Group] IS NULL               ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Product Group] = IIF([Product Group] = 'NULL'              ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Product Group] = IIF([Product Group] = 'NULL'              ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Product Group] = IIF([Product Group] = ''                  ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Product Group] = IIF([Product Group] = ''                  ,'Travel'       ,[Product Group]);

    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Policy Type]   = IIF([Policy Type]   = 'UNKNOWN'           ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Policy Type]   = IIF([Policy Type]   = 'UNKNOWN'           ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Policy Type]   = IIF([Policy Type]   IS NULL               ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Policy Type]   = IIF([Policy Type]   IS NULL               ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Policy Type]   = IIF([Policy Type]   = 'NULL'              ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Policy Type]   = IIF([Policy Type]   = 'NULL'              ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Policy Type]   = IIF([Policy Type]   = ''                  ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Policy Type]   = IIF([Policy Type]   = ''                  ,'Leisure'      ,[Policy Type]  );

    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Plan Type]     = IIF([Plan Type]     IS NULL               ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Plan Type]     = IIF([Plan Type]     IS NULL               ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Plan Type]     = IIF([Plan Type]     = ''                  ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Plan Type]     = IIF([Plan Type]     = ''                  ,'International',[Plan Type]    );

    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Trip Type]     = IIF([Trip Type]     IS NULL               ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Trip Type]     = IIF([Trip Type]     IS NULL               ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary]     SET [Trip Type]     = IIF([Trip Type]     = ''                  ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Trip Type]     = IIF([Trip Type]     = ''                  ,'Single Trip'  ,[Trip Type]    );

    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Policy Type]   = IIF([Policy Type]   ='Leisure_CBA'        ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSetSummary_CBA] SET [Trip Type]     = IIF([Trip Type]     ='Annual Multi Trip'  ,'AMT'          ,[Trip Type]    );

    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID('[ws].[DWHDataSetSummary]'))
        BEGIN
      --CREATE CLUSTERED    INDEX idx_DWHDataSetSummary_PolicyKey                   ON [db-au-actuary].[ws].[DWHDataSetSummary] ([PolicyKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_PolicyKey                   ON [db-au-actuary].[ws].[DWHDataSetSummary] ([PolicyKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_PolicyKeyProductCode        ON [db-au-actuary].[ws].[DWHDataSetSummary] ([PolicyKey],[Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_DomainCountry               ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Domain Country]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_PolicyStatus                ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Policy Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_ProductCode                 ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_PlanCode                    ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Plan Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_ProductPlan                 ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Product Plan]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_TripType                    ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Trip Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_PlanType                    ON [db-au-actuary].[ws].[DWHDataSetSummary] ([Plan Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_OutletKey                   ON [db-au-actuary].[ws].[DWHDataSetSummary] ([OutletKey]);
        END

    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID('[ws].[DWHDataSetSummary_CBA]'))
        BEGIN
      --CREATE CLUSTERED    INDEX idx_DWHDataSetSummary_CBA_PolicyKey               ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([PolicyKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_PolicyKey               ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([PolicyKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_PolicyKeyProductCode    ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([PolicyKey],[Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_DomainCountry           ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Domain Country]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_PolicyStatus            ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Policy Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_ProductCode             ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_PlanCode                ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Plan Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_ProductPlan             ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Product Plan]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_TripType                ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Trip Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_PlanType                ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([Plan Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSetSummary_CBA_OutletKey               ON [db-au-actuary].[ws].[DWHDataSetSummary_CBA] ([OutletKey]);
        END


--DWHDataSet
    PRINT 'DWHDataSet'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    --DROP TABLE [db-au-actuary].[ws].[DWHDataSet];
    --SELECT * INTO [db-au-actuary].[ws].[DWHDataSet]     FROM    [uldwh02].[db-au-actuary].[ws].[DWHDataSet];
    --DROP TABLE [db-au-actuary].[ws].[DWHDataSet_CBA]; 
    --SELECT * INTO [db-au-actuary].[ws].[DWHDataSet_CBA] FROM [azsyddwh02].[db-au-actuary].[ws].[DWHDataSet];

    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Product Group] = IIF([Product Group] = 'UNKNOWN'           ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Product Group] = IIF([Product Group] = 'UNKNOWN'           ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Product Group] = IIF([Product Group] IS NULL               ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Product Group] = IIF([Product Group] IS NULL               ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Product Group] = IIF([Product Group] = 'NULL'              ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Product Group] = IIF([Product Group] = 'NULL'              ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Product Group] = IIF([Product Group] = ''                  ,'Travel'       ,[Product Group]);
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Product Group] = IIF([Product Group] = ''                  ,'Travel'       ,[Product Group]);

    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Policy Type]   = IIF([Policy Type]   = 'UNKNOWN'           ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Policy Type]   = IIF([Policy Type]   = 'UNKNOWN'           ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Policy Type]   = IIF([Policy Type]   IS NULL               ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Policy Type]   = IIF([Policy Type]   IS NULL               ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Policy Type]   = IIF([Policy Type]   = 'NULL'              ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Policy Type]   = IIF([Policy Type]   = 'NULL'              ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Policy Type]   = IIF([Policy Type]   = ''                  ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Policy Type]   = IIF([Policy Type]   = ''                  ,'Leisure'      ,[Policy Type]  );

    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Plan Type]     = IIF([Plan Type]     IS NULL               ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Plan Type]     = IIF([Plan Type]     IS NULL               ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Plan Type]     = IIF([Plan Type]     = ''                  ,'International',[Plan Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Plan Type]     = IIF([Plan Type]     = ''                  ,'International',[Plan Type]    );

    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Trip Type]     = IIF([Trip Type]     IS NULL               ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Trip Type]     = IIF([Trip Type]     IS NULL               ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet]     SET [Trip Type]     = IIF([Trip Type]     = ''                  ,'Single Trip'  ,[Trip Type]    );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Trip Type]     = IIF([Trip Type]     = ''                  ,'Single Trip'  ,[Trip Type]    );

    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Policy Type]   = IIF([Policy Type]   ='Leisure_CBA'        ,'Leisure'      ,[Policy Type]  );
    UPDATE [db-au-actuary].[ws].[DWHDataSet_CBA] SET [Trip Type]     = IIF([Trip Type]     ='Annual Multi Trip'  ,'AMT'          ,[Trip Type]    );

    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID('[ws].[DWHDataSet]'))
        BEGIN
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_PolicyTransactionKey       ON [db-au-actuary].[ws].[DWHDataSet]     ([PolicyTransactionKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_PolicyKeyProductCode       ON [db-au-actuary].[ws].[DWHDataSet]     ([PolicyKey],[Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_TransactionStatus          ON [db-au-actuary].[ws].[DWHDataSet]     ([Transaction Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_TransactionType            ON [db-au-actuary].[ws].[DWHDataSet]     ([Transaction Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_DomainCountry              ON [db-au-actuary].[ws].[DWHDataSet]     ([Domain Country]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_PolicyStatus               ON [db-au-actuary].[ws].[DWHDataSet]     ([Policy Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_ProductCode                ON [db-au-actuary].[ws].[DWHDataSet]     ([Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_PlanCode                   ON [db-au-actuary].[ws].[DWHDataSet]     ([Plan Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_ProductPlan                ON [db-au-actuary].[ws].[DWHDataSet]     ([Product Plan]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_TripType                   ON [db-au-actuary].[ws].[DWHDataSet]     ([Trip Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_PlanType                   ON [db-au-actuary].[ws].[DWHDataSet]     ([Plan Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_OutletKey                  ON [db-au-actuary].[ws].[DWHDataSet]     ([OutletKey]);
        END

    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name IS NOT NULL AND object_id = OBJECT_ID('[ws].[DWHDataSet_CBA]'))
        BEGIN
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_PolicyTransactionKey   ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([PolicyTransactionKey]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_PolicyKeyProductCode   ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([PolicyKey],[Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_TransactionStatus      ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Transaction Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_TransactionType        ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Transaction Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_DomainCountry          ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Domain Country]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_PolicyStatus           ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Policy Status]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_ProductCode            ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Product Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_PlanCode               ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Plan Code]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_ProductPlan            ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Product Plan]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_TripType               ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Trip Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_PlanType               ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([Plan Type]);
        CREATE NONCLUSTERED INDEX idx_DWHDataSet_CBA_OutletKey              ON [db-au-actuary].[ws].[DWHDataSet_CBA] ([OutletKey]);
        END


--dimOutlet
    PRINT 'dimOutlet'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))
    

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[dimOutlet]') AND type in (N'U'))
    DROP TABLE [cng].[dimOutlet];

    WITH dimOutlet AS (
        SELECT * FROM    [ULDWH02].[db-au-star].[dbo].[dimOutlet] WITH(NOLOCK)
      --UNION ALL 
      --SELECT * FROM [AZSYDDWH02].[db-au-star].[dbo].[dimOutlet] WITH(NOLOCK)
    )

    SELECT * INTO [db-au-actuary].[cng].[dimOutlet] FROM dimOutlet;

    UPDATE [db-au-actuary].[cng].[dimOutlet] SET [JVDesc] = REPLACE([JVDesc],'Integration',[SuperGroupName]);

  --CREATE UNIQUE CLUSTERED INDEX idx_dimOutlet_OutletSK            ON [db-au-actuary].[cng].[dimOutlet] ([OutletSK]);
    CREATE NONCLUSTERED     INDEX idx_dimOutlet_OutletSK            ON [db-au-actuary].[cng].[dimOutlet] ([OutletSK]);
    CREATE NONCLUSTERED     INDEX idx_dimOutlet_OutletKeyisLatest   ON [db-au-actuary].[cng].[dimOutlet] ([OutletKey],[isLatest]);


--dimProduct
    PRINT 'dimProduct'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))
    

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[dimProduct]') AND type in (N'U'))
    DROP TABLE [cng].[dimProduct];

    WITH dimProduct AS (
        SELECT * FROM    [ULDWH02].[db-au-star].[dbo].[dimProduct] WITH(NOLOCK)
      --UNION ALL 
      --SELECT * FROM [AZSYDDWH02].[db-au-star].[dbo].[dimProduct] WITH(NOLOCK)
    )

    SELECT * INTO [db-au-actuary].[cng].[dimProduct] FROM dimProduct;

  --CREATE UNIQUE CLUSTERED INDEX idx_dimProduct_ProductSK  ON [db-au-actuary].[cng].[dimProduct] ([ProductSK]);
    CREATE NONCLUSTERED     INDEX idx_dimProduct_ProductSK  ON [db-au-actuary].[cng].[dimProduct] ([ProductSK]);
    CREATE NONCLUSTERED     INDEX idx_dimProduct_ProductKey ON [db-au-actuary].[cng].[dimProduct] ([ProductKey]);


--penOutlet
    PRINT 'penOutlet'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penOutlet]') AND type in (N'U'))
    DROP TABLE [cng].[penOutlet];

    WITH penOutlet AS (
        SELECT * FROM  [ULDWH02].[db-au-cmdwh].[dbo].[penOutlet] WITH(NOLOCK)
        UNION ALL 
        SELECT * FROM [AZSYDDWH02].[db-au-CBA].[dbo].[penOutlet] WITH(NOLOCK)
    )

    SELECT * INTO [db-au-actuary].[cng].[penOutlet] FROM penOutlet;

    UPDATE [db-au-actuary].[cng].[penOutlet] SET [JV] = REPLACE([JV],'BW WL','BW NAC');
    UPDATE [db-au-actuary].[cng].[penOutlet] SET [JV] = REPLACE([JV],'A&G','Auto & General');

  --CREATE CLUSTERED    INDEX idx_penOutlet_OutletKeyOutletStatus  ON [db-au-actuary].[cng].[penOutlet] ([OutletKey],[OutletStatus]);
    CREATE NONCLUSTERED INDEX idx_penOutlet_OutletKeyOutletStatus  ON [db-au-actuary].[cng].[penOutlet] ([OutletKey],[OutletStatus]);


--penPolicy
    PRINT 'penPolicy'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penPolicy]') AND type in (N'U'))
    DROP TABLE [cng].[penPolicy];

    WITH penPolicy AS (
        SELECT DISTINCT [PolicyKey],[PolicyID],[PolicyNumber],[ProductCode],[TripStart],[TripEnd] FROM  [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy] WITH(NOLOCK)
        UNION ALL 
        SELECT DISTINCT [PolicyKey],[PolicyID],[PolicyNumber],[ProductCode],[TripStart],[TripEnd] FROM [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicy] WITH(NOLOCK)
    )

    SELECT * INTO [db-au-actuary].[cng].[penPolicy] FROM penPolicy;

  --CREATE UNIQUE CLUSTERED INDEX idx_penPolicy_PolicyKeyProductCode    ON [db-au-actuary].[cng].[penPolicy] ([PolicyKey],[ProductCode]);
    CREATE NONCLUSTERED     INDEX idx_penPolicy_PolicyKeyProductCode    ON [db-au-actuary].[cng].[penPolicy] ([PolicyKey],[ProductCode]);
    CREATE NONCLUSTERED     INDEX idx_penPolicy_PolicyID                ON [db-au-actuary].[cng].[penPolicy] ([PolicyID]);


--penPolicyCreditNote
    PRINT 'penPolicyCreditNote'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penPolicyCreditNote]') AND type in (N'U'))
    DROP TABLE [cng].[penPolicyCreditNote];

    WITH penPolicyCreditNote AS (
        SELECT 
             a.*
            ,b.[PolicyKey]      AS [OriginalPolicyKey]
            ,b.[ProductCode]    AS [OriginalProductCode]
            ,c.[PolicyKey]      AS [RedeemPolicyKey]
            ,c.[ProductCode]    AS [RedeemProductCode]
            ,d.[TripStartDate]  AS [CreditNoteStartDate]
            ,d.[ExpiryDate]     AS [CreditNoteExpiryDate]
        FROM      [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyCreditNote] a WITH(NOLOCK) 
        LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]           b WITH(NOLOCK) ON a.[OriginalPolicyId] = b.[PolicyID] AND a.[CountryKey] = b.[CountryKey] AND a.[CompanyKey] = b.[CompanyKey] AND a.[DomainId] = b.[DomainId] AND a.[OriginalPolicyId] <> 0
        LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]           c WITH(NOLOCK) ON a.[RedeemPolicyId]   = c.[PolicyID] AND a.[CountryKey] = c.[CountryKey] AND a.[CompanyKey] = c.[CompanyKey] AND a.[DomainId] = c.[DomainId] AND a.[RedeemPolicyId]   <> 0
        LEFT JOIN (SELECT * FROM [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
                   UNION ALL
                   SELECT * FROM [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
                  ) d ON a.[ID] = d.[ID] AND a.[CreditNoteNumber] = d.[CreditNoteNumber] COLLATE Latin1_General_CI_AS
        --UNION ALL 
        --SELECT 
        --     a.*
        --    ,b.[PolicyKey]      AS [OriginalPolicyKey]
        --    ,b.[ProductCode]    AS [OriginalProductCode]
        --    ,c.[PolicyKey]      AS [RedeemPolicyKey]
        --    ,c.[ProductCode]    AS [RedeemProductCode]
        --    ,d.[TripStartDate]  AS [CreditNoteStartDate]
        --    ,d.[ExpiryDate]     AS [CreditNoteExpiryDate]
        --FROM      [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicyCreditNote] a WITH(NOLOCK) 
        --LEFT JOIN [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicy]           b WITH(NOLOCK) ON a.[OriginalPolicyId] = b.[PolicyID] AND a.[CountryKey] = b.[CountryKey] AND a.[CompanyKey] = b.[CompanyKey] AND a.[DomainId] = b.[DomainId]
        --LEFT JOIN [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicy]           c WITH(NOLOCK) ON a.[RedeemPolicyId]   = c.[PolicyID] AND a.[CountryKey] = c.[CountryKey] AND a.[CompanyKey] = c.[CompanyKey] AND a.[DomainId] = c.[DomainId]
        --LEFT JOIN (SELECT * FROM [AZSYDDWH02].[AU_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
        --           UNION ALL
        --           SELECT * FROM [AZSYDDWH02].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
        --          ) d ON a.[ID] = d.[ID] AND a.[CreditNoteNumber] = d.[CreditNoteNumber] COLLATE Latin1_General_CI_AS
    )

    SELECT * INTO [db-au-actuary].[cng].[penPolicyCreditNote] FROM penPolicyCreditNote;

  --CREATE UNIQUE CLUSTERED INDEX idx_penPolicyCreditNote_CreditNotePolicyKey   ON [db-au-actuary].[cng].[penPolicyCreditNote] ([CreditNotePolicyKey]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyCreditNote_CreditNotePolicyKey   ON [db-au-actuary].[cng].[penPolicyCreditNote] ([CreditNotePolicyKey]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyCreditNote_CreditNoteNumber      ON [db-au-actuary].[cng].[penPolicyCreditNote] ([CreditNoteNumber]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyCreditNote_OriginalPolicyKey     ON [db-au-actuary].[cng].[penPolicyCreditNote] ([OriginalPolicyKey],[OriginalProductCode]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyCreditNote_RedeemPolicyKey       ON [db-au-actuary].[cng].[penPolicyCreditNote] ([RedeemPolicyKey],[RedeemProductCode]);


--penPolicyTransAddOn
    PRINT 'penPolicyTransAddOn'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penPolicyTransAddOn]') AND type in (N'U'))
    DROP TABLE [cng].[penPolicyTransAddOn];

    WITH penPolicyTransAddOn AS (
        SELECT 
             a.[CountryKey]
            ,a.[CompanyKey]
            ,a.[PolicyTransactionKey]
            ,a.[AddOnGroup]
            ,a.[AddOnText]
            ,a.[CoverIncrease]
            ,a.[GrossPremium]
            ,a.[UnAdjGrossPremium]
            ,a.[AddonCount]
            ,b.[PolicyKey]
            ,b.[TransactionStatus]
            ,b.[TransactionType]
            ,c.[ProductCode]
        FROM       [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransAddOn]  a WITH(NOLOCK)
        LEFT JOIN  [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransaction] b WITH(NOLOCK) ON a.[PolicyTransactionKey] = b.[PolicyTransactionKey]
        LEFT JOIN  [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]            c WITH(NOLOCK) ON b.[PolicyKey] = c.[PolicyKey]
        UNION ALL 
        SELECT
             a.[CountryKey]
            ,a.[CompanyKey]
            ,a.[PolicyTransactionKey]
            ,a.[AddOnGroup]
            ,a.[AddOnText]
            ,a.[CoverIncrease]
            ,a.[GrossPremium]
            ,a.[UnAdjGrossPremium]
            ,CASE WHEN [TransactionType] IN ('Base','Variation') AND [TransactionStatus] =   'Active'                             THEN  1
                  WHEN [TransactionType] IN ('Base','Variation') AND [TransactionStatus] IN ('Cancelled','CancelledWithOverride') THEN -1
                  ELSE 0
             END AS [AddonCount]
            ,b.[PolicyKey]
            ,b.[TransactionStatus]
            ,b.[TransactionType]
            ,c.[ProductCode]
        FROM      [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicyTransAddOn]  a WITH(NOLOCK)
        LEFT JOIN [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicyTransaction] b WITH(NOLOCK) ON a.[PolicyTransactionKey] = b.[PolicyTransactionKey]
        LEFT JOIN [AZSYDDWH02].[db-au-CBA].[dbo].[penPolicy]            c WITH(NOLOCK) ON b.[PolicyKey] = c.[PolicyKey]
    )

    SELECT * INTO [db-au-actuary].[cng].[penPolicyTransAddOn] FROM penPolicyTransAddOn;

  --CREATE CLUSTERED    INDEX idx_penPolicyTransAddOn_PolicyTransactionKey  ON [db-au-actuary].[cng].[penPolicyTransAddOn] ([PolicyTransactionKey]);
    CREATE NONCLUSTERED INDEX idx_penPolicyTransAddOn_PolicyTransactionKey  ON [db-au-actuary].[cng].[penPolicyTransAddOn] ([PolicyTransactionKey]);
    CREATE NONCLUSTERED INDEX idx_penPolicyTransAddOn_PolicyKeyProductCode  ON [db-au-actuary].[cng].[penPolicyTransAddOn] ([PolicyKey],[ProductCode]);


--penPolicyTransSummary
    PRINT 'penPolicyTransSummary'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penPolicyTransSummary]') AND type in (N'U'))
    DROP TABLE [cng].[penPolicyTransSummary];

    WITH 
    TopUpComments AS (
        SELECT DISTINCT [UserComments] AS [TopUpComments] 
        FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK)
        WHERE [TopUp] = 1
    ),
    
    penPolicyTransSummary AS (
        SELECT a.[PolicyTransactionKey],a.[PolicyKey],a.[ProductCode],a.[BasePolicyCount],a.[TransactionType],a.[TransactionStatus],a.[AutoComments],a.[UserComments]
              ,a.[TopUp]
              ,a.[RefundToCustomer],c.[CNStatus]
              ,b.[PromoCode],b.[PromoName],b.[PromoType],b.[Discount] AS [PromoDiscount]
        FROM       [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]     a WITH(NOLOCK)
        LEFT JOIN  [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransactionPromo] b WITH(NOLOCK) ON a.[PolicyTransactionKey] = b.[PolicyTransactionKey] AND b.[IsApplied] = 1 AND b.[ApplyOrder] = 1
        LEFT JOIN  [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyCNStatus]         c WITH(NOLOCK) ON a.[CNStatusID] = c.[CNStatusID]
        UNION ALL 
        SELECT a.[PolicyTransactionKey],a.[PolicyKey],a.[ProductCode],a.[BasePolicyCount],a.[TransactionType],a.[TransactionStatus],a.[AutoComments],a.[UserComments]
              ,CASE WHEN c.[TopUpComments] IS NULL THEN 0 ELSE 1 END AS [TopUp]
              ,NULL AS [RefundToCustomer],NULL AS [CNStatus]
              ,b.[PromoCode],b.[PromoName],b.[PromoType],b.[Discount] AS [PromoDiscount]
        FROM      [AZSYDDWH02].[db-au-cba].[dbo].[penPolicyTransSummary]     a WITH(NOLOCK)
        LEFT JOIN [AZSYDDWH02].[db-au-cba].[dbo].[penPolicyTransactionPromo] b WITH(NOLOCK) ON a.[PolicyTransactionKey] = b.[PolicyTransactionKey] AND b.[IsApplied] = 1 AND b.[ApplyOrder] = 1
        LEFT JOIN TopUpComments                                              c WITH(NOLOCK) ON a.[UserComments]         = c.[TopUpComments]
        
      --SELECT [CountryKey],[CompanyKey],[PolicyTransactionKey],[PolicyKey],[PolicyNoKey],[UserKey],[UserSKey],[PolicyTransactionID],[PolicyID],[PolicyNumber],[TransactionTypeID],[TransactionType],[IssueDate],[AccountingPeriod],[CRMUserID],[CRMUserName],[TransactionStatusID],[TransactionStatus],[Transferred],[UserComments],[CommissionTier],[VolumeCommission],[Discount],[isExpo],[isPriceBeat],[NoOfBonusDaysApplied],[isAgentSpecial],[ParentID],[ConsultantID],[isClientCall],[RiskNet],[AutoComments],[TripCost],[AllocationNumber],[PaymentDate],[TransactionStart],[TransactionEnd],[TaxAmountSD],[TaxOnAgentCommissionSD],[TaxAmountGST],[TaxOnAgentCommissionGST],[BasePremium],[GrossPremium],[Commission],[DiscountPolicyTrans],[GrossAdminFee],[AdjustedNet],[CommissionRatePolicyPrice],[DiscountRatePolicyPrice],[CommissionRateTravellerPrice],[DiscountRateTravellerPrice],[CommissionRateTravellerAddOnPrice],[DiscountRateTravellerAddOnPrice],[CommissionRateEMCPrice],[DiscountRateEMCPrice],[UnAdjBasePremium],[UnAdjGrossPremium],[UnAdjCommission],[UnAdjDiscountPolicyTrans],[UnAdjGrossAdminFee],[UnAdjAdjustedNet],[UnAdjCommissionRatePolicyPrice],[UnAdjDiscountRatePolicyPrice],[UnAdjCommissionRateTravellerPrice],[UnAdjDiscountRateTravellerPrice],[UnAdjCommissionRateTravellerAddOnPrice],[UnAdjDiscountRateTravellerAddOnPrice],[UnAdjCommissionRateEMCPrice],[UnAdjDiscountRateEMCPrice],[StoreCode],[OutletAlphaKey],[OutletSKey],[NewPolicyCount],[BasePolicyCount],[AddonPolicyCount],[ExtensionPolicyCount],[CancelledPolicyCount],[CancelledAddonPolicyCount],[CANXPolicyCount],[DomesticPolicyCount],[InternationalPolicyCount],[TravellersCount],[AdultsCount],[ChildrenCount],[ChargedAdultsCount],[DomesticTravellersCount],[DomesticAdultsCount],[DomesticChildrenCount],[DomesticChargedAdultsCount],[InternationalTravellersCount],[InternationalAdultsCount],[InternationalChildrenCount],[InternationalChargedAdultsCount],[NumberofDays],[LuggageCount],[MedicalCount],[MotorcycleCount],[RentalCarCount],[WintersportCount],[AttachmentCount],[EMCCount],[InternationalNewPolicyCount],[InternationalCANXPolicyCount],[ProductCode],[PurchasePath],[SingleFamilyFlag],[isAMT],[IssueTime],[ExternalReference],[UnAdjTaxAmountSD],[UnAdjTaxOnAgentCommissionSD],[UnAdjTaxAmountGST],[UnAdjTaxOnAgentCommissionGST],[DomainKey],[DomainID],[IssueTimeUTC],[PaymentDateUTC],[TransactionStartUTC],[TransactionEndUTC],[CurrencyCode],[CurrencySymbol],[YAGOIssueDate],[InboundPolicyCount],[InboundTravellersCount],[InboundAdultsCount],[InboundChildrenCount],[InboundChargedAdultsCount],[ImportDate],[PostingDate],[YAGOPostingDate],[PostingTime],[CompetitorName],[CompetitorPrice],[CanxCover],[PaymentMode],[PointsRedeemed],        [RedemptionReference],[GigyaId],[IssuingConsultantID],[LeadTimeDate],        [MaxAMTDuration],[RefundTransactionID],[RefundTransactionKey],        [TopUp],        [RefundToCustomer],        [CNStatusID]
      --FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK)
      --UNION ALL 
      --SELECT [CountryKey],[CompanyKey],[PolicyTransactionKey],[PolicyKey],[PolicyNoKey],[UserKey],[UserSKey],[PolicyTransactionID],[PolicyID],[PolicyNumber],[TransactionTypeID],[TransactionType],[IssueDate],[AccountingPeriod],[CRMUserID],[CRMUserName],[TransactionStatusID],[TransactionStatus],[Transferred],[UserComments],[CommissionTier],[VolumeCommission],[Discount],[isExpo],[isPriceBeat],[NoOfBonusDaysApplied],[isAgentSpecial],[ParentID],[ConsultantID],[isClientCall],[RiskNet],[AutoComments],[TripCost],[AllocationNumber],[PaymentDate],[TransactionStart],[TransactionEnd],[TaxAmountSD],[TaxOnAgentCommissionSD],[TaxAmountGST],[TaxOnAgentCommissionGST],[BasePremium],[GrossPremium],[Commission],[DiscountPolicyTrans],[GrossAdminFee],[AdjustedNet],[CommissionRatePolicyPrice],[DiscountRatePolicyPrice],[CommissionRateTravellerPrice],[DiscountRateTravellerPrice],[CommissionRateTravellerAddOnPrice],[DiscountRateTravellerAddOnPrice],[CommissionRateEMCPrice],[DiscountRateEMCPrice],[UnAdjBasePremium],[UnAdjGrossPremium],[UnAdjCommission],[UnAdjDiscountPolicyTrans],[UnAdjGrossAdminFee],[UnAdjAdjustedNet],[UnAdjCommissionRatePolicyPrice],[UnAdjDiscountRatePolicyPrice],[UnAdjCommissionRateTravellerPrice],[UnAdjDiscountRateTravellerPrice],[UnAdjCommissionRateTravellerAddOnPrice],[UnAdjDiscountRateTravellerAddOnPrice],[UnAdjCommissionRateEMCPrice],[UnAdjDiscountRateEMCPrice],[StoreCode],[OutletAlphaKey],[OutletSKey],[NewPolicyCount],[BasePolicyCount],[AddonPolicyCount],[ExtensionPolicyCount],[CancelledPolicyCount],[CancelledAddonPolicyCount],[CANXPolicyCount],[DomesticPolicyCount],[InternationalPolicyCount],[TravellersCount],[AdultsCount],[ChildrenCount],[ChargedAdultsCount],[DomesticTravellersCount],[DomesticAdultsCount],[DomesticChildrenCount],[DomesticChargedAdultsCount],[InternationalTravellersCount],[InternationalAdultsCount],[InternationalChildrenCount],[InternationalChargedAdultsCount],[NumberofDays],[LuggageCount],[MedicalCount],[MotorcycleCount],[RentalCarCount],[WintersportCount],[AttachmentCount],[EMCCount],[InternationalNewPolicyCount],[InternationalCANXPolicyCount],[ProductCode],[PurchasePath],[SingleFamilyFlag],[isAMT],[IssueTime],[ExternalReference],[UnAdjTaxAmountSD],[UnAdjTaxOnAgentCommissionSD],[UnAdjTaxAmountGST],[UnAdjTaxOnAgentCommissionGST],[DomainKey],[DomainID],[IssueTimeUTC],[PaymentDateUTC],[TransactionStartUTC],[TransactionEndUTC],[CurrencyCode],[CurrencySymbol],[YAGOIssueDate],[InboundPolicyCount],[InboundTravellersCount],[InboundAdultsCount],[InboundChildrenCount],[InboundChargedAdultsCount],[ImportDate],[PostingDate],[YAGOPostingDate],[PostingTime],[CompetitorName],[CompetitorPrice],[CanxCover],[PaymentMode],[PointsRedeemed],NULL AS [RedemptionReference],[GigyaId],[IssuingConsultantID],[LeadTimeDate],NULL AS [MaxAMTDuration],[RefundTransactionID],[RefundTransactionKey],NULL AS [TopUp],NULL AS [RefundToCustomer],NULL AS [CNStatusID]
      --FROM [AZSYDDWH02].[db-au-cba].[dbo].[penPolicyTransSummary] WITH(NOLOCK)
    )

    SELECT DISTINCT * INTO [db-au-actuary].[cng].[penPolicyTransSummary] FROM penPolicyTransSummary;

  --CREATE UNIQUE CLUSTERED INDEX idx_penPolicyTransSummary_PolicyTransactionKey ON [db-au-actuary].[cng].[penPolicyTransSummary] ([PolicyTransactionKey],[ProductCode]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyTransSummary_PolicyTransactionKey ON [db-au-actuary].[cng].[penPolicyTransSummary] ([PolicyTransactionKey],[ProductCode]);
    CREATE NONCLUSTERED     INDEX idx_penPolicyTransSummary_PolicyKeyProductCode ON [db-au-actuary].[cng].[penPolicyTransSummary] ([PolicyKey],[ProductCode]);


--penPolicyTravellerAll
    PRINT 'penPolicyTravellerAll'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[penPolicyTravellerAll]') AND type in (N'U'))
    DROP TABLE [cng].[penPolicyTravellerAll];

    WITH penPolicyTraveller AS (
        SELECT a.*
              ,b.[ProductCode]
        FROM      [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTraveller] a WITH(NOLOCK) 
        LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]          b WITH(NOLOCK) ON a.[PolicyKey] = b.[PolicyKey]
        --WHERE a.[isPrimary] = 1
        UNION ALL 
        SELECT a.*
              ,NULL AS [GAID]
              ,NULL AS [FullAddress]
              ,b.[ProductCode]
        FROM      [AZSYDDWH02].[db-au-cba].[dbo].[penPolicyTraveller] a WITH(NOLOCK) 
        LEFT JOIN [AZSYDDWH02].[db-au-cba].[dbo].[penPolicy]          b WITH(NOLOCK) ON a.[PolicyKey] = b.[PolicyKey]
        --WHERE a.[isPrimary] = 1
    )

    SELECT * INTO [db-au-actuary].[cng].[penPolicyTravellerAll] FROM penPolicyTraveller;

  --CREATE CLUSTERED    INDEX idx_penPolicyTraveller_PolicyTravellerKey   ON [db-au-actuary].[cng].[penPolicyTravellerAll] ([PolicyTravellerKey],[ProductCode]);
    CREATE NONCLUSTERED INDEX idx_penPolicyTraveller_PolicyTravellerKey   ON [db-au-actuary].[cng].[penPolicyTravellerAll] ([PolicyTravellerKey],[ProductCode]);
    CREATE NONCLUSTERED INDEX idx_penPolicyTraveller_PolicyKeyProductCode ON [db-au-actuary].[cng].[penPolicyTravellerAll] ([PolicyKey],[ProductCode]);


--Policy Header Works
    PRINT 'Policy Header Works'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[DWHDataSetSummary]') AND type in (N'U'))
    DROP TABLE [cng].[DWHDataSetSummary];

    WITH DWHDataSetSummary AS (
        SELECT ROW_NUMBER() OVER (PARTITION BY [PolicyKey] ORDER BY [BIRowID]) AS [Rank],
               * 
        FROM [db-au-actuary].[ws].[DWHDataSetSummary]
        WHERE [Domain Country] IN ('AU','NZ') AND ([Issue Date] >= '2015-01-01' OR [Departure Date] >= '2015-01-01' OR [Return Date] >= '2015-01-01')
        UNION ALL
        SELECT ROW_NUMBER() OVER (PARTITION BY [PolicyKey] ORDER BY [BIRowID]) AS [Rank],
               * 
        FROM [db-au-actuary].[ws].[DWHDataSetSummary_CBA]
        WHERE [Domain Country] IN ('AU','NZ') AND ([Issue Date] >= '2015-01-01' OR [Departure Date] >= '2015-01-01' OR [Return Date] >= '2015-01-01')
    )

    SELECT * INTO [db-au-actuary].[cng].[DWHDataSetSummary] FROM DWHDataSetSummary;

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Table]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Header_Table];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Header_Table] FROM [db-au-actuary].[cng].[Policy_Header];

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Works_Table_1]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Header_Works_Table_1];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Header_Works_Table_1] FROM [db-au-actuary].[cng].[Policy_Header_Works];

  --CREATE CLUSTERED    INDEX idx_Policy_Header_Works_Table_PolicyKey               ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([PolicyKey]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PolicyKey               ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([PolicyKey]);    
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PolicyKeyProductCode    ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([PolicyKey],[Product Code]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_BasePolicyNo            ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Base Policy No]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_DomainCountry           ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Domain Country]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PolicyStatus            ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Policy Status]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PolicyStatusDetailed    ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Policy Status Detailed]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_JVCode                  ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([JV Code]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_JVDescription           ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([JV Description]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_OutletKey               ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([OutletKey]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_OutletChannel           ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Outlet Channel]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_ProductCode             ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Product Code]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PlanCode                ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Plan Code]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_ProductPlan             ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Product Plan]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_ProductGroup            ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Product Group]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PolicyType              ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Policy Type]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_TripType                ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Trip Type]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_PlanType                ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([Plan Type]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_UWRatingGroup           ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([UW Rating Group]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_UWJVDescriptionOrig     ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([UW JV Description Orig]);
    CREATE NONCLUSTERED INDEX idx_Policy_Header_Works_Table_UWPolicyStatus          ON [db-au-actuary].[cng].[Policy_Header_Works_Table_1] ([UW Policy Status]);

    --IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Table]') AND type in (N'U'))
    --DROP TABLE [cng].[Policy_Header_Table];

    --IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Works_Table]') AND type in (N'U'))
    --DROP TABLE [cng].[Policy_Header_Works_Table];

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Works_Table]') AND type in (N'U'))
    EXEC SP_RENAME 'cng.Policy_Header_Works_Table', 'Policy_Header_Works_Table_Old';

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Header_Works_Table_1]') AND type in (N'U'))
    EXEC SP_RENAME 'cng.Policy_Header_Works_Table_1', 'Policy_Header_Works_Table';

    SELECT COUNT(*) FROM [db-au-actuary].[cng].[Policy_Header_Works_Table_Old];
    SELECT COUNT(*) FROM [db-au-actuary].[cng].[Policy_Header_Works_Table];


--Claim Incurred Pattern
    PRINT 'Claim Incurred Pattern'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Claim_Incurred_Pattern_Table]') AND type in (N'U'))
    DROP TABLE [cng].[Claim_Incurred_Pattern_Table];
    
    SELECT * INTO [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] FROM [db-au-actuary].[cng].[Claim_Incurred_Pattern];

    CREATE NONCLUSTERED INDEX idx_Claim_Incurred_Pattern_Table_DomainCountry        ON [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] ([DomainCountry]);
    CREATE NONCLUSTERED INDEX idx_Claim_Incurred_Pattern_Table_TripType             ON [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] ([TripType]);
    CREATE NONCLUSTERED INDEX idx_Claim_Incurred_Pattern_Table_PlanType             ON [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] ([PlanType]);
    CREATE NONCLUSTERED INDEX idx_Claim_Incurred_Pattern_Table_LeadTimeGroup        ON [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] ([LeadTimeGroup]);
    CREATE NONCLUSTERED INDEX idx_Claim_Incurred_Pattern_Table_DaysToLossRescale    ON [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table] ([DaysToLoss%Rescale]);


--Policy Issue Month Summary v2
    PRINT 'Policy Issue Month Summary v2'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Issue_Table_v2]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Issue_Table_v2];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Table_v2] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Issue_v2];


--Policy Departure Month Summary v2
    PRINT 'Policy Departure Month Summary v2'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Departure_Table_v2]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Departure_Table_v2];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Departure_Table_v2] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Departure_v2];


--Policy Return Month Summary v2
    PRINT 'Policy Return Month Summary v2'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Return_Table_v2]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Return_Table_v2];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Return_Table_v2] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Return_v2];


--Policy Exposure Month Summary v2
    PRINT 'Policy Exposure Month Summary v2'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Exposure_Table_v2]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Exposure_Table_v2];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Exposure_Table_v2] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Exposure_v2];
    
    
--Policy Issue Month Development Summary v2
    PRINT 'Policy Issue Month Development Summary v2'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Issue_Development_Table_v2]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Issue_Development_Table_v2];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Development_Table_v2] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Development_v2];
    
    
--Policy Issue Month Development Summary v3
    PRINT 'Policy Issue Month Development Summary v3'
    PRINT(CONVERT(VARCHAR(24),GETDATE()))

    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cng].[Policy_Month_Summary_Issue_Development_Table_v3]') AND type in (N'U'))
    DROP TABLE [cng].[Policy_Month_Summary_Issue_Development_Table_v3];
    
    SELECT * INTO [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Development_Table_v3] FROM [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Development_v3];
    
GO
