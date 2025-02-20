USE [db-au-cba]
GO
/****** Object:  View [dbo].[vCBClientGroup]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vCBClientGroup] as
/*
    2019-11-21, EV,   Created - vcbClientGroup to cbClient
*/
select
    CountryKey,
    ClientCode,
    ClientName,
    EvacDebtorCode,
    NonEvacDebtorCode,
    CurrencyCode,
    IsCovermoreClient,
    case
    	When
			cc.ClientCode in ('CB', 'BW')
			then 'CBA'
        else 'Other'
    end ClientGroup
from
    cbClient cc




GO
