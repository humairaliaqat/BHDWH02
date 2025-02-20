USE [db-au-cba]
GO
/****** Object:  View [dbo].[vTelephonyCallData]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vTelephonyCallData] as 
	select *
	from 
		--[ULDWH02].[db-au-cmdwh].[dbo].[vTelephonyCallData]
		[vTelephonyCallData_Synonym]
	where 
        CallDate >= '2018-10-01' and
		Company IN ('Commonwealth Bank','BankWest')


GO
