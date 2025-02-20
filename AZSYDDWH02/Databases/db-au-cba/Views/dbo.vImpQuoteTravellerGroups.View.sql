USE [db-au-cba]
GO
/****** Object:  View [dbo].[vImpQuoteTravellerGroups]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vImpQuoteTravellerGroups] as 
	select QuoteSK,
			SUM(CASE WHEN TravellerIdentifier like 'adult%' THEN 1 ELSE 0 END) as AdultCount,
			SUM(CASE WHEN TravellerIdentifier like 'child%' THEN 1 ELSE 0 END) as ChildrenCount,
			COUNT(*) as TravellerCount,
			CASE
				WHEN COUNT(*) = 1 THEN 'Single'
				WHEN COUNT(*) > 6 THEN 'Group'
				WHEN COUNT(*) = 2 THEN 'Couple'
				WHEN COUNT(*) between 3 AND 6 THEN 'Family'
			END as TravelGroup
	from impQuoteTravellers qt
	GROUP BY QuoteSK
GO
