USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_TelephonyData]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[rptsp_TelephonyData]
as
begin

	select *
	from 
		--[ULDWH02].[db-au-cmdwh].[dbo].[vTelephonyCallData]
		[vTelephonyCallData_Synonym]
	where 
        CallDate >= '2018-10-01' and
		Company IN ('Commonwealth Bank','BankWest')

end
GO
