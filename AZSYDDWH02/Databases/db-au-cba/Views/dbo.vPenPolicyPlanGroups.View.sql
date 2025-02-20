USE [db-au-cba]
GO
/****** Object:  View [dbo].[vPenPolicyPlanGroups]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vPenPolicyPlanGroups] as 
	select DISTINCT
		UniquePlanId,
		po.OutletKey,
		po.OutletAlphaKey,
		CASE WHEN IsNull(CHARINDEX('cardholder', PlanDisplayName),0) = 0 THEN
				LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(PlanDisplayName, 'Activated', ''), 'Base', ''), 'EMC', '')))
			else
				LTRIM(RTRIM(REPLACE(REPLACE(REPLACE(LEFT(PlanDisplayName, charindex('cardholder', PlanDisplayName) -1), 'Activated', ''), 'Base', ''), 'EMC', '')))
		END ProductClassification,
		CASE 
			WHEN PlanDisplayName like 'Base%' or PlanName like 'Base%' then 'Base'
			WHEN PlanDisplayName like 'Activated%' or PlanName like 'Activ%' then 'Activation'
			ELSE 'Whitelabel'
		END SaleType,
		CASE WHEN PATINDEX('%[a-z]%', REVERSE(PlanCode)) > 1
                THEN LEFT(PlanCode, LEN(PlanCode) - PATINDEX('%[a-z]%', REVERSE(PlanCode)) + 1)
            ELSE PlanCode END as PlanCode,
		ProductCode
	from penProductPlan ppp
	JOIN penOutlet po on ppp.OutletKey = po.OutletKey and po.OutletStatus = 'Current'
	--CASE PlanName
		--	WHEN 'Base-Gold' THEN 'Gold'
		--	WHEN 'Base-Platinum' THEN 'Platinum'
		--	WHEN 'Base-Diamond' THEN 'Diamond'
		--	WHEN 'Base-BusGold' THEN 'Business Gold'
		--	WHEN 'Base-BuPlatinum' THEN 'Business Platinum'
		--	WHEN 'Activ-Gold-C' THEN 'Gold'
		--	WHEN 'Activ-Gold-CC' THEN 'Gold'
		--	WHEN 'Activ-Gold-CF' THEN 'Gold'
		--	WHEN 'Activ-Plat-C' THEN 'Platinum'
		--	WHEN 'Activ-Plat-CC' THEN 'Platinum'
		--	WHEN 'Activ-Plat-CF' THEN 'Platinum'
		--	WHEN 'Activ-Diam-C' THEN 'Diamond'
		--	WHEN 'Activ-Diam-CC' THEN 'Diamond'
		--	WHEN 'Activ-Diam-CF' THEN 'Diamond'
		--	WHEN 'Activ-BuGold-C' THEN 'Business Gold'
		--	WHEN 'Activ-BuGold-CC' THEN 'Business Gold'
		--	WHEN 'Activ-BuGold-CF' THEN 'Business Gold'
		--	WHEN 'Activ-BuPlat-C' THEN 'Business Platinum'
		--	WHEN 'Activ-BuPlat-CC' THEN 'Business Platinum'
		--	WHEN 'Activ-BuPlat-CF' THEN 'Business Platinum'
		--	WHEN 'Int-ST-Comp' THEN 'Comprehensive'
		--	WHEN 'Int-ST-Comp-F' THEN 'Comprehensive'
		--	WHEN 'Int-ST-Ess' THEN 'Essentials'
		--	WHEN 'Int-ST-Ess-F' THEN 'Essentials'
		--	WHEN 'Int-ST-Med' THEN 'Medical Only'
		--	WHEN 'Int-ST-Non-Med' THEN 'Non-Medical'
		--	WHEN 'Dom-ST' THEN 'Domestic '
		--	WHEN 'Dom-ST-F' THEN 'Domestic '
		--	WHEN 'Inbound-ST' THEN 'Inbound'
		--	WHEN 'Int-ST-Canx' THEN 'Cancellation Only'
		--	WHEN 'Int-AMT-S' THEN 'Comprehensive'
		--	WHEN 'Int-AMT-F' THEN 'Comprehensive'
		--	WHEN 'Dom-AMT-S' THEN 'Domestic Multi-Trip'
		--	WHEN 'Dom-AMT-F' THEN 'Domestic Multi-Trip'
		--	WHEN 'Base-PlatDeb' THEN 'Platinum Debit'
		--	WHEN 'Base-TravMon' THEN 'Travel Money'
		--	WHEN 'Base-WorldDeb' THEN 'World Debit'
		--	WHEN 'Activ-World-C' THEN 'World Debit'
		--	WHEN 'Activ-World-CC' THEN 'World Debit'
		--	WHEN 'Activ-World-CF' THEN 'World Debit'
		--	WHEN 'Base-TransAcc' THEN 'Transit Accident'
		--	WHEN 'Base-UnauthTran' THEN 'Unauthorised Transaction'
		--	WHEN 'Base-Breeze' THEN 'Breeze Mastercard'
		--	WHEN 'Base-Vgold' THEN 'Visa Gold'
		--	WHEN 'Base-World' THEN 'World'
		--	ELSE 'Unknown'
		--end ProductClassification,
		--CASE planName
		--	WHEN 'Base-Gold' THEN 'Base'
		--	WHEN 'Base-Platinum' THEN 'Base'
		--	WHEN 'Base-Diamond' THEN 'Base'
		--	WHEN 'Base-BusGold' THEN 'Base'
		--	WHEN 'Base-BuPlatinum' THEN 'Base'
		--	WHEN 'Activ-Gold-C' THEN 'Activated'
		--	WHEN 'Activ-Gold-CC' THEN 'Activated'
		--	WHEN 'Activ-Gold-CF' THEN 'Activated'
		--	WHEN 'Activ-Plat-C' THEN 'Activated'
		--	WHEN 'Activ-Plat-CC' THEN 'Activated'
		--	WHEN 'Activ-Plat-CF' THEN 'Activated'
		--	WHEN 'Activ-Diam-C' THEN 'Activated'
		--	WHEN 'Activ-Diam-CC' THEN 'Activated'
		--	WHEN 'Activ-Diam-CF' THEN 'Activated'
		--	WHEN 'Activ-BuGold-C' THEN 'Activated'
		--	WHEN 'Activ-BuGold-CC' THEN 'Activated'
		--	WHEN 'Activ-BuGold-CF' THEN 'Activated'
		--	WHEN 'Activ-BuPlat-C' THEN 'Activated'
		--	WHEN 'Activ-BuPlat-CC' THEN 'Activated'
		--	WHEN 'Activ-BuPlat-CF' THEN 'Activated'
		--	WHEN 'Int-ST-Comp' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Comp-F' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Ess' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Ess-F' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Med' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Non-Med' THEN 'Whitelabel'
		--	WHEN 'Dom-ST' THEN 'Whitelabel'
		--	WHEN 'Dom-ST-F' THEN 'Whitelabel'
		--	WHEN 'Inbound-ST' THEN 'Whitelabel'
		--	WHEN 'Int-ST-Canx' THEN 'Whitelabel'
		--	WHEN 'Int-AMT-S' THEN 'Whitelabel'
		--	WHEN 'Int-AMT-F' THEN 'Whitelabel'
		--	WHEN 'Dom-AMT-S' THEN 'Whitelabel'
		--	WHEN 'Dom-AMT-F' THEN 'Whitelabel'
		--	WHEN 'Base-PlatDeb' THEN 'Base'
		--	WHEN 'Base-TravMon' THEN 'Base'
		--	WHEN 'Base-WorldDeb' THEN 'Base'
		--	WHEN 'Activ-World-C' THEN 'Activated'
		--	WHEN 'Activ-World-CC' THEN 'Activated'
		--	WHEN 'Activ-World-CF' THEN 'Activated'
		--	WHEN 'Base-TransAcc' THEN 'Base'
		--	WHEN 'Base-UnauthTran' THEN 'Base'
		--	WHEN 'Base-Breeze' THEN 'Base'
		--	WHEN 'Base-Vgold' THEN 'Base'
		--	WHEN 'Base-World' THEN 'Base'
		--	ELSE 'Unknown'
		--END as SaleType,
GO
