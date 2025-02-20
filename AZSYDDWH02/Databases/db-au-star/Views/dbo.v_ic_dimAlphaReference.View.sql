USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimAlphaReference]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[v_ic_dimAlphaReference]
as
select
    'Point in time' OutletReference, 
    OutletSK, 
    OutletSK ReferenceSK, 
    'PT' + convert(varchar(max), OutletSK) RefSK
from
    dimOutlet

union all

select
    'Latest alpha' OutletReference, 
    OutletSK, 
    LatestOutletSK ReferenceSK, 
    'LA' + convert(varchar(max), OutletSK) RefSK
from
    dimOutlet
GO
