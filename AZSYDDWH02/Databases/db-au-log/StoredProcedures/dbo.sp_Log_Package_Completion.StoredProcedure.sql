USE [db-au-log]
GO
/****** Object:  StoredProcedure [dbo].[sp_Log_Package_Completion]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Log_Package_Completion] @Src_Record_Count int , 
                                              @Update_Record_Count int , 
                                              @Insert_Record_Count int , 
                                              @Batch_ID int , 
                                              @Package_ID varchar ( 100 )
AS
BEGIN

    --20131002, RE, Re-formatted code

    DECLARE
       @Package_Status varchar ( 50 ) , 
       @Failure_Record_Count int

    SET @Failure_Record_Count =
        ( SELECT
                 COUNT ( * )
            FROM Package_Error_Log
            WHERE Package_ID = @Package_ID
              AND Batch_ID = @Batch_ID
              AND
                  ( 
                    SELECT
                           MAX( Package_Start_Time )
                      FROM package_run_details
                      WHERE Package_ID = @Package_ID
                        AND Batch_ID = @Batch_ID
                        AND Package_End_Time IS NULL
                  )
                  < 
                  ( 
                    SELECT
                           MAX( Insert_Date )
                      FROM Package_Error_Log
                      WHERE Package_ID = @Package_ID
                        AND Batch_ID = @Batch_ID
                  )
        )

    IF @Failure_Record_Count > 0
        BEGIN
            SET @Package_Status = 'Failure'
        END
    ELSE
        BEGIN
            SET @Package_Status = 'Success'
        END

    UPDATE Package_Run_Details
    SET
        Src_Record_Count = @Src_Record_Count , 
        Insert_Record_Count = @Insert_Record_Count , 
        Update_Record_Count = @Update_Record_Count , 
        Package_Status = @Package_Status , 
        Package_End_Time = GETDATE ()
    WHERE
          Batch_ID = @Batch_ID
      AND Package_ID = @Package_ID
      AND Package_End_Time IS NULL
      AND Package_Start_Time = 
          ( SELECT
                   MAX( Package_Start_Time )
              FROM Package_Run_Details
              WHERE Package_ID = @Package_ID
                AND Batch_ID = @Batch_ID
          )
END
  



GO
