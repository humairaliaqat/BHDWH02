USE [db-au-cba]
GO
/****** Object:  View [dbo].[vCorpItems]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vCorpItems]
with schemabinding
as

select
  CountryKey,
  'DaysPaid' as BankRecordType,
  QuoteKey,
  BankRecordKey,
  DaysPaidID ItemID
from dbo.corpDaysPaid

union all
      
select
  CountryKey,
  'Closing' as BankRecordType,
  QuoteKey,
  BankRecordKey,
  ClosingID ItemID
from dbo.corpClosing cl
    
union all

select
  CountryKey,
  'EMC' as BankRecordType,
  QuoteKey,
  BankRecordKey,
  EMCID ItemID
from dbo.corpEMC em
    
union all

select
  CountryKey,
  'Luggage' as BankRecordType,
  QuoteKey,
  BankRecordKey,
  LuggageID ItemID
from dbo.corpLuggage lu



GO
