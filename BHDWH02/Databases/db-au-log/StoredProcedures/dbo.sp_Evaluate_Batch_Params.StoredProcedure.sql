USE [DB-AU-LOG]
GO
/****** Object:  StoredProcedure [dbo].[sp_Evaluate_Batch_Params]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Evaluate_Batch_Params] @Subject_Area varchar ( 50 ) , 
                                             @Package_ID varchar ( 50 ) , 
                                             @Package_Name varchar ( 50 ) , 
                                             @User_Name varchar  ( 50 ) , 
                                             @Batch_ID integer OUTPUT , 
                                             @Batch_Date datetime OUTPUT , 
                                             @Batch_To_Date datetime OUTPUT
AS
BEGIN

    --20131002, RE, optimised code to use one call

    SET NOCOUNT ON

    SELECT  @Batch_ID = MAX( Batch_ID )
    FROM	  Batch_Run_Status
    WHERE	  Subject_Area  = @Subject_Area
    
    SELECT TOP 1
           @Batch_Date	   = CAST( Batch_Date AS datetime ),
           @Batch_To_Date   = CAST ( COALESCE ( Batch_To_Date , '2999-12-31' )AS datetime )
    FROM	 Batch_Run_Status
    WHERE	 Subject_Area	   = @Subject_Area
      AND	 Batch_ID		   = @Batch_ID
    ORDER BY Batch_To_Date DESC

    INSERT INTO Package_Run_Details
				(
				Batch_ID , 
				Package_ID , 
				Package_Name , 
				User_Name , 
				Package_Start_Time , 
				Package_Status
				)
    VALUES
				(
				@Batch_ID , 
				@Package_ID , 
				@Package_Name , 
				@User_Name , 
				GETDATE() , 
				'Running'
				)
END





GO
