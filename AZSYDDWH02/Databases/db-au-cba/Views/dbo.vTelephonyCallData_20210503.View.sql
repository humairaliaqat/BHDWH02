USE [db-au-cba]
GO
/****** Object:  View [dbo].[vTelephonyCallData_20210503]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vTelephonyCallData_20210503] as 
	select *
	from 
		--[ULDWH02].[db-au-cmdwh].[dbo].[vTelephonyCallData]
		[vTelephonyCallData_Synonym]
	where 
        CallDate >= '2021-03-01' and
		Company IN ('Commonwealth Bank')



GO
