USE [DB-AU-LOG]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_GetBatchDate]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_GetBatchDate] @Country varchar(10),
									@Instance varchar(50),
									@StartDate datetime OUTPUT,
									@EndDate datetime OUTPUT
as

set nocount on

/******************************************************************************/
-- Title:			etlsp_GetBatchDate
-- Date Created:	20160620
-- Author:			Linus Tor
-- Parameters:		@Country: Required. Valid country value
--					@Instance: Required. Valid instance name (eg. [AU_PenguinSharp_Active]
--					@StartDate: output of batch start date in UTC
--					@EndDate: output of batch end date in UTC
-- Change History:	20160620 - LT - procedure create
--
/******************************************************************************/

--uncomment to debug
/*
declare @Country varchar(10)
declare @Instance varchar(50)
declare @StartDate datetime
declare @EndDate datetime
select @Country = 'AU', @Instance = '[AU_PenguinSharp_Active]', @StartDate = null, @EndDate = null
*/

select
	@StartDate = [db-au-stage].dbo.xfn_ConvertLocalToUTC(min(batchStartTimeStamp),'AUS Eastern Standard Time'),
	@EndDate = [db-au-stage].dbo.xfn_ConvertLocalToUTC(max(batchEndTimeStamp),'AUS Eastern Standard Time')
from
	etlBatchRun b
	inner join etlObjectRun o on b.batchID = o.batchID
	inner join refSourceTable st on o.tableID = st.srcTableID
where
	b.country = @Country and
	st.srcDBName = @Instance and
	b.BatchStatus = 'Success' and
	isDWHLoaded = 0


GO
