USE [db-au-cba]
GO
/****** Object:  View [dbo].[vCorporateStampDuty]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vCorporateStampDuty] 
as
select 
    '' QuoteKey,
    '' TaxKey,
    0 DomesticStampDutyRate,
    0 DomesticStampDutyOnPremiumExSDRate,
    0 InternationalStampDutyRate,
    0 InternationalStampDutyOnPremiumExSDRate,
    0 CalculatedInternationalStampDuty,
    0 CalculatedDomesticStampDuty
GO
