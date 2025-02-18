USE [DB-AU-LOG]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_star_BatchRunStatus]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_star_BatchRunStatus]   
    @OpMode varchar(30),
    @Subject_Area varchar(50),
    @Batch_ID int output,
    @Batch_Start_Time datetime output,
    @Batch_End_Time datetime output
    
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Description:    This stored procedure performance batch operations as per parameter values.
				It will return the maximum Batch_ID value for all Operation Mode.
				
Parameters:		@OpMode:			Required. Value is SELECT, INSERT, UPDATE
				@Subject_Area:		Required. ETL subject area
				@Batch_ID:			Batch_ID OUTPUT value
				@Batch_Start_Time:	@Batch_Start_Time OUTPUT value
				@Batch_End_Time:	@Batch_End_Time OUTPUT value
Change History:
                20131114 - LT - Procedure created
                20150204 - LS - hijacking this with standard batch logging

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @OpMode varchar(30)
declare @Batch_ID int
declare @Batch_Date date
declare @Batch_Start_Time datetime
declare @Batch_Status varchar(10)
declare @Batch_End_Time datetime
declare @Subject_Area varchar(50)
declare @Batch_ID_Output int
select	
    @OpMode = 'UPDATE',
    @Batch_Date = convert(date,getdate()),
    @Batch_Start_Time = getdate(),
    @Batch_End_Time = getdate(),
    @Batch_Status = 'Success',
    @Subject_Area = 'Policy Star'
*/

    set nocount on

    declare 
        @start date,
        @end date

    --default 30 days for batch creation using this sp
    select 
        @start = dateadd(day, -30, getdate()),
        @end = getdate()


    if @OpMode = 'INSERT'
    begin
    
        exec [db-au-stage]..syssp_createbatch
            @SubjectArea = @Subject_Area,
            @StartDate = @start,
            @EndDate = @end

        exec [db-au-stage]..syssp_getrunningbatch
            @SubjectArea = @Subject_Area,
            @BatchID = @Batch_ID out,
            @StartDate = @Batch_Start_Time out,
            @EndDate = @Batch_End_Time out
	    
    end

    if @OpMode = 'UPDATE'
    begin
    
        exec [db-au-stage]..syssp_getrunningbatch
            @SubjectArea = @Subject_Area,
            @BatchID = @Batch_ID out,
            @StartDate = @Batch_Start_Time out,
            @EndDate = @Batch_End_Time out

        exec [db-au-stage]..syssp_closebatch
            @BatchID = @Batch_ID
    
    end

    if @OpMode = 'SELECT'
    begin

        exec [db-au-stage]..syssp_getrunningbatch
            @SubjectArea = @Subject_Area,
            @BatchID = @Batch_ID out,
            @StartDate = @Batch_Start_Time out,
            @EndDate = @Batch_End_Time out
    
    end

end

GO
