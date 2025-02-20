USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_factABSTraveller]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_ic_factABSTraveller] as
select 
    DateSK,
    DomainSK,
    DestinationSK,
    DurationSK,
    AgeBandSK,
    LeisureTravellerCount,
    NonLeisureTravellerCount,
    FriendRelativeCount,
    HolidayCount
from
    factABSTraveller
GO
