USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETLXXX_emcHealixImpulse]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATE 
CREATE
procedure [dbo].[etlsp_ETLXXX_emcHealixImpulse]    
as
begin
	/************************************************************************************************************************************
	Author:         Ratnesh Sharma
	Date:           20190130
	Prerequisite:         
	Description:    Processes Impulse EMC healix data
	Parameters:     
	Change History: 

                               
	*************************************************************************************************************************************/
    set nocount on;
    declare
		@sql varchar(max),
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int,
		@ETLRunArea varchar(50) = ''

   /* exec syssp_getrunningbatch
        @SubjectArea = @ETLRunArea,
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out*/

	
	--begin transaction
	begin try
		/*select @name = object_name(@@procid)
        
        exec syssp_genericerrorhandler 
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'*/
		
		--create [db-au-stage].dbo.etl_emcHealix after reading from source directly using DB link

		
		if object_id('[db-au-stage].dbo.etl_emcApplications') is not null
			drop table [db-au-stage].dbo.etl_emcApplications

		select 
		sessionid,
		--impulse_response,
		--json_value(impulse_response,'$.identifier') as Ddentifier,
		json_value(impulse_response,'$.assessmentID') as AssessmentID,
		AssessmentDateUTC,
		AssessmentDateAusLocalTime,
		--json_value(impulse_response,'$.totalRiskScore') as ImpulseTotalRiskScore,
		json_value(impulse_response,'$.isDeclaredByOther') as isDeclaredByOther,
		json_value(impulse_response,'$.healixVersion') as HealixVersion,
		json_value(impulse_response,'$.healixRegionID') as HealixRegionID,
		----json_value(impulse_response,'$.conditionGroups[0].score') as FirstconditionGroupScore,
		json_value(impulse_response,'$.tier') as tier,
		json_value(impulse_response,'$.price.gross') as GrossPrice,
		json_value(impulse_response,'$.price.displayPrice') as DisplayPrice,
		json_value(verisk_response,'$.totalRiskScore') as VerisktotalRiskScore
		into [db-au-stage].dbo.etl_emcApplications
		from [db-au-stage].dbo.etl_emcHealix q;



		if object_id('[db-au-stage].dbo.etl_emcApplicants') is not null
			drop table [db-au-stage].dbo.etl_emcApplicants

		select 
		sessionid,
		--null as ApplicantID, --this is identity column
		json_value(impulse_response,'$.identifier') as Identifier,
		FirstName,
		LastName,
		DOB
		into [db-au-stage].dbo.etl_emcApplicants
		from [db-au-stage].dbo.etl_emcHealix q;


		if object_id('[db-au-stage].dbo.etl_emcMedicalQuestions') is not null
			drop table [db-au-stage].dbo.etl_emcMedicalQuestions

		select 
		sessionid,
		--impulse_response,
		  --d.[key],
		  --d.[Value] conditionGroups,
		  --e.[key],
		  e.[Value] condition,
		json_value(e.[Value],'$.id') as ConditionID,
		json_value(e.[Value],'$.name') as ConditionName,
		json_value(e.[Value],'$.score') as ConditionScore,
		json_value(e.[Value],'$.isOkForWinterSports') as ConditionisOkForWinterSports,
		json_value(e.[Value],'$.isOkForMultiTrip') as ConditionisOkForMultiTrip,
		json_value(e.[Value],'$.isCovered') as ConditionisCovered,
		json_value(e.[Value],'$.isExcluded') as ConditionisExcluded
		into [db-au-stage].dbo.etl_emcMedicalQuestions
		from [db-au-stage].dbo.etl_emcHealix q
		 cross apply openjson(q.impulse_response, '$.conditionGroups') d
		 cross apply openjson(d.value,'$.conditions') e;

		 -----------------------Insert to DW---------------------------

		 if object_id('[db-au-cba-healix].dbo.[emcHealix]') is null
		 CREATE TABLE [db-au-cba-healix].[dbo].[emcHealix](
			[SessionID] [varchar](max) NULL,
			[AssessmentDatePosixTimestamp] [bigint] NULL,
			[AssessmentDateUTC] [datetime] NULL,
			[AssessmentDateAusLocalTime] [datetime] NULL,
			[DOB] [datetime] NULL,
			[FirstName] [varchar](max) NULL,
			[LastName] [varchar](max) NULL,
			[impulse_response] [varchar](max) NULL,
			[verisk_response] [varchar](max) NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

		delete dw
		from [db-au-cba-healix].[dbo].[emcHealix] dw
		join [db-au-stage].dbo.etl_emcHealix st on st.sessionid=dw.sessionid;


			insert into [db-au-cba-healix].[dbo].[emcHealix]([SessionID],[AssessmentDatePosixTimestamp],[AssessmentDateUTC],[AssessmentDateAusLocalTime],[DOB],[FirstName],[LastName],[impulse_response],[verisk_response])
			select [SessionID],[AssessmentDatePosixTimestamp],[AssessmentDateUTC],[AssessmentDateAusLocalTime],[DOB],[FirstName],[LastName],[impulse_response],[verisk_response]
			from [db-au-stage].dbo.etl_emcHealix;


		 if object_id('[db-au-cba-healix].dbo.[emcApplications]') is null
		 CREATE TABLE [db-au-cba-healix].[dbo].[emcApplications](
			[sessionid] [varchar](max) NULL,
			[AssessmentID] [nvarchar](4000) NULL,
			[AssessmentDateUTC] [datetime] NULL,
			[AssessmentDateAusLocalTime] [datetime] NULL,
			[isDeclaredByOther] [nvarchar](4000) NULL,
			[HealixVersion] [nvarchar](4000) NULL,
			[HealixRegionID] [nvarchar](4000) NULL,
			[tier] [nvarchar](4000) NULL,
			[GrossPrice] [nvarchar](4000) NULL,
			[DisplayPrice] [nvarchar](4000) NULL,
			[VerisktotalRiskScore] [nvarchar](4000) NULL
		) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

		delete dw
		from [db-au-cba-healix].[dbo].[emcApplications] dw
		join [db-au-stage].dbo.etl_emcApplications st on st.AssessmentID=dw.AssessmentID and st.sessionid=dw.sessionid;


			insert into [db-au-cba-healix].[dbo].[emcApplications]([sessionid],[AssessmentID],[AssessmentDateUTC],[AssessmentDateAusLocalTime],[isDeclaredByOther],[HealixVersion],[HealixRegionID],[tier],[GrossPrice],[DisplayPrice],[VerisktotalRiskScore])
			select [sessionid],[AssessmentID],[AssessmentDateUTC],[AssessmentDateAusLocalTime],[isDeclaredByOther],[HealixVersion],[HealixRegionID],[tier],[GrossPrice],[DisplayPrice],[VerisktotalRiskScore]
			from [db-au-stage].dbo.etl_emcApplications;



		 if object_id('[db-au-cba-healix].dbo.[emcApplicants]') is null
			 CREATE TABLE [db-au-cba-healix].[dbo].[emcApplicants](
				[ApplicantID] int identity(1,1) not null,
				[sessionid] [varchar](max) NULL,
				[Identifier] [nvarchar](4000) NULL,
				[FirstName] [varchar](max) NULL,
				[LastName] [varchar](max) NULL,
				[DOB] [datetime] NULL
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

		delete dw
		from [db-au-cba-healix].[dbo].[emcApplicants] dw
		join [db-au-stage].dbo.etl_emcApplicants st on st.sessionid=dw.sessionid and st.Identifier=dw.Identifier;

		
			insert into [db-au-cba-healix].[dbo].[emcApplicants]([sessionid],[Identifier],[FirstName],[LastName],[DOB])
			select [sessionid],[Identifier],[FirstName],[LastName],[DOB]
			from [db-au-stage].dbo.etl_emcApplicants;

			if object_id('[db-au-cba-healix].dbo.[emcMedicalQuestions]') is null
			CREATE TABLE [db-au-cba-healix].[dbo].[emcMedicalQuestions](
				[sessionid] [varchar](max) NULL,
				[condition] [nvarchar](max) NULL,
				[ConditionID] [nvarchar](4000) NULL,
				[ConditionName] [nvarchar](4000) NULL,
				[ConditionScore] [nvarchar](4000) NULL,
				[ConditionisOkForWinterSports] [nvarchar](4000) NULL,
				[ConditionisOkForMultiTrip] [nvarchar](4000) NULL,
				[ConditionisCovered] [nvarchar](4000) NULL,
				[ConditionisExcluded] [nvarchar](4000) NULL
			) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY];

		delete dw
		from [db-au-cba-healix].[dbo].[emcMedicalQuestions] dw
		join [db-au-stage].dbo.etl_emcMedicalQuestions st on st.sessionid=dw.sessionid and st.ConditionID=dw.ConditionID;

		insert into [db-au-cba-healix].[dbo].[emcMedicalQuestions]([sessionid],[condition],[ConditionID],[ConditionName],[ConditionScore],[ConditionisOkForWinterSports],[ConditionisOkForMultiTrip],[ConditionisCovered],[ConditionisExcluded])
		select [sessionid],[condition],[ConditionID],[ConditionName],[ConditionScore],[ConditionisOkForWinterSports],[ConditionisOkForMultiTrip],[ConditionisCovered],[ConditionisExcluded]
		from [db-au-stage].dbo.etl_emcMedicalQuestions;


			/*exec syssp_genericerrorhandler 
				@LogToTable = 1,
				@ErrorCode = '0',
				@BatchID = @batchid,
				@PackageID = @name,
				@LogStatus = 'Finished',
				@LogSourceCount = @sourcecount,
				@LogInsertCount = @insertcount,
				@LogUpdateCount = @updatecount*/

	end try
       
	begin catch
        
            --if @@trancount > 0
            --    rollback transaction
                
           /* exec syssp_genericerrorhandler 
                @SourceInfo = 'Impulse CBA healix emc data processing failed',
                @LogToTable = 1,
                @ErrorCode = '-100',
                @BatchID = @batchid,
                @PackageID = @name*/
				print('Error occurred'+error_message())
            
	end catch    

	--if @@trancount > 0
	--	commit transaction

end


GO
