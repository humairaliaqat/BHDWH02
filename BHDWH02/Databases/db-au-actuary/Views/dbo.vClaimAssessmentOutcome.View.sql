USE [db-au-actuary]
GO
/****** Object:  View [dbo].[vClaimAssessmentOutcome]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vClaimAssessmentOutcome]
as
select * from  [uldwh02].[db-au-cmdwh].[dbo].[vClaimAssessmentOutcome]
GO
