USE [db-au-cba]
GO
/****** Object:  View [dbo].[vPenPolicyTravellerGroup]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vPenPolicyTravellerGroup] as 
	select PolicyKey,
			SUM(CAST(IsAdult as int)) as AdultCount,
			SUM(ABS(CAST(IsAdult as int)-1)) as ChildrenCount,
			COUNT(*) as TravellerCount,
			CASE
				WHEN COUNT(*) = 1 THEN 'Single'
				WHEN COUNT(*) > 6 THEN 'Group'
				WHEN COUNT(*) = 2 THEN 'Couple'
				WHEN COUNT(*) between 3 AND 6 THEN 'Family'
			END as TravelGroup
	from penPolicyTraveller ppt 
	GROUP BY PolicyKey
GO
