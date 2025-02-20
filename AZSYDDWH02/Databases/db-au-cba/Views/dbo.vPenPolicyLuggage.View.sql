USE [db-au-cba]
GO
/****** Object:  View [dbo].[vPenPolicyLuggage]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vPenPolicyLuggage]
as
select
    ptt.PolicyTransactionKey,
    pta.AddOnText Item,
    pta.CoverIncrease
from 
    penPolicyTravellerTransaction ptt
    inner join penPolicyTravellerAddOn pta on
        pta.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
where AddOnGroup = 'Luggage'

GO
