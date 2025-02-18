USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Header_Op_Time]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Header_Op_Time] AS

WITH 
chdr AS (
    SELECT * FROM [db-au-actuary].[cng].[Claim_Header_Table]
),

chdr_01 AS (
    SELECT 
         *
        ,RANK()   OVER (PARTITION BY [DomainCountry],[SectionMonth]                               ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionMonthRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[SectionMonth])                                                                                      AS [SectionMonthCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[SectionMonth],[ActuarialBenefitGroup]       ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionMonthBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[SectionMonth],[ActuarialBenefitGroup])                                                              AS [SectionMonthBenefitCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[SectionQuarter]                             ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionQuarterRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[SectionQuarter])                                                                                    AS [SectionQuarterCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[SectionQuarter],[ActuarialBenefitGroup]     ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionQuarterBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[SectionQuarter],[ActuarialBenefitGroup])                                                            AS [SectionQuarterBenefitCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],YEAR([SectionMonth])                         ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionYearRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],YEAR([SectionMonth]))                                                                                AS [SectionYearCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],YEAR([SectionMonth]),[ActuarialBenefitGroup] ORDER BY [FinalisedTime],[SectionDate],[IncurredTime])  AS [SectionYearBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],YEAR([SectionMonth]),[ActuarialBenefitGroup])                                                        AS [SectionYearBenefitCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[LossMonth]                                  ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossMonthRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[LossMonth])                                                                                         AS [LossMonthCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[LossMonth],[ActuarialBenefitGroup]          ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossMonthBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[LossMonth],[ActuarialBenefitGroup])                                                                 AS [LossMonthBenefitCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[LossQuarter]                                ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossQuarterRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[LossQuarter])                                                                                       AS [LossQuarterCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],[LossQuarter],[ActuarialBenefitGroup]        ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossQuarterBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],[LossQuarter],[ActuarialBenefitGroup])                                                               AS [LossQuarterBenefitCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],YEAR([LossMonth])                            ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossYearRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],YEAR([LossMonth]))                                                                                   AS [LossYearCount]
        ,RANK()   OVER (PARTITION BY [DomainCountry],YEAR([LossMonth]),[ActuarialBenefitGroup]    ORDER BY [FinalisedTime],[LossDate],[IncurredTime])     AS [LossYearBenefitRank]
        ,COUNT(*) OVER (PARTITION BY [DomainCountry],YEAR([LossMonth]),[ActuarialBenefitGroup])                                                           AS [LossYearBenefitCount]
    FROM chdr
),

chdr_02 AS (
    SELECT 
         *
        ,[SectionMonthRank]         *1.0/[SectionMonthCount]          AS [SectionMonthOpTime]
        ,[SectionMonthBenefitRank]  *1.0/[SectionMonthBenefitCount]   AS [SectionMonthBenefitOpTime]
        ,[SectionQuarterRank]       *1.0/[SectionQuarterCount]        AS [SectionQuarterOpTime]
        ,[SectionQuarterBenefitRank]*1.0/[SectionQuarterBenefitCount] AS [SectionQuarterBenefitOpTime]
        ,[SectionYearRank]          *1.0/[SectionYearCount]           AS [SectionYearOpTime]
        ,[SectionYearBenefitRank]   *1.0/[SectionYearBenefitCount]    AS [SectionYearBenefitOpTime]
        ,[LossMonthRank]            *1.0/[LossMonthCount]             AS [LossMonthOpTime]
        ,[LossMonthBenefitRank]     *1.0/[LossMonthBenefitCount]      AS [LossMonthBenefitOpTime]
        ,[LossQuarterRank]          *1.0/[LossQuarterCount]           AS [LossQuarterOpTime]
        ,[LossQuarterBenefitRank]   *1.0/[LossQuarterBenefitCount]    AS [LossQuarterBenefitOpTime]
        ,[LossYearRank]             *1.0/[LossYearCount]              AS [LossYearOpTime]
        ,[LossYearBenefitRank]      *1.0/[LossYearBenefitCount]       AS [LossYearBenefitOpTime]
    FROM chdr_01
)

SELECT *
FROM chdr_02
;
GO
