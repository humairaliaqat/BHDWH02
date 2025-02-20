USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimTicket]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_ic_dimTicket]
as
select
    DestinationSK OriginSK, 
    Destination, 
    Continent, 
    SubContinent, 
    ABSCountry, 
    ABSArea
from
    dimDestination
GO
