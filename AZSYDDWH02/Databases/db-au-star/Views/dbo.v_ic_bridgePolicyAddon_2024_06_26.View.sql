USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_bridgePolicyAddon_2024_06_26]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[v_ic_bridgePolicyAddon_2024_06_26]    
as    
select distinct    
    convert(bigint, PolicySK) PolicySK,    
    AddonGroup,    
    1 BridgeCount    
from    
    [db-au-star]..factPolicyTransactionAddons t with(nolock)    
 WHERE PolicySK in (select PolicySK from dimpolicy)
GO
