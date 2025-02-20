USE [db-au-star]
GO
/****** Object:  View [dbo].[vdimPolicyAddon]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vdimPolicyAddon] 
with schemabinding
as
select
    BIRowID, 
    PolicySK,
    isnull(AddOnGroup, 'No Addon') AddOnGroup
from
    dbo.factPolicyTransactionAddons pta with(nolock)


GO
