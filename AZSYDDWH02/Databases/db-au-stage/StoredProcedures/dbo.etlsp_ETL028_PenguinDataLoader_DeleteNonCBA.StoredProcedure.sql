USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL028_PenguinDataLoader_DeleteNonCBA]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_ETL028_PenguinDataLoader_DeleteNonCBA]
as

SET NOCOUNT ON

--delete non-cba policyimport records
delete ppi
from 
	[db-au-cba].dbo.penPolicyImport ppi
	inner join [db-au-cba].dbo.penDataImport di on ppi.DataImportKey = di.DataImportKey
where
	di.JobID not in 
	(
		select distinct JobID
		from [db-au-cba].dbo.penJob
		where CountryKey = 'AU' and JobName = 'CBA Policy Data Loader'
	)

--delete non-cba joberrors
delete je
from [db-au-cba].dbo.penJobError je
where
	je.JobKey not in 
	(
		select distinct JobKey 
		from [db-au-cba].dbo.penJob 
		where JobName = 'CBA Policy DATA Loader'
	)

--delete non-cba data queue records
delete dq
from [db-au-cba].dbo.penDataQueue dq
where
	JobID not in 
	(
		select distinct JobID
		from [db-au-cba].dbo.penJob
		where CountryKey = 'AU' and JobName = 'CBA Policy Data Loader'
	)

--delete non-cba data import records
delete di
from [db-au-cba].dbo.penDataImport di
where
	JobID not in 
	(
		select distinct JobID
		from [db-au-cba].dbo.penJob
		where CountryKey = 'AU' and JobName = 'CBA Policy Data Loader'
	)

--delete non-cba policy renewal batch records
delete prb
from [db-au-cba].dbo.penPolicyRenewalBatch prb
where
	prb.JobID not in
	(
		select distinct JobID
		from [db-au-cba].dbo.penJob
		where CountryKey = 'AU' and JobName = 'CBA Policy Data Loader'
	)

--delete non-cba job records
delete j
from [db-au-cba].dbo.penJob j
where CountryKey <> 'AU' and JobName <> 'CBA Policy Data Loader'

GO
