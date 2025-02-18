USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[cleanup_server_log]    Script Date: 18/02/2025 2:36:19 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

            CREATE PROCEDURE [internal].[cleanup_server_log]
            WITH EXECUTE AS 'AllSchemaOwner'
            AS
                SET NOCOUNT ON

                DECLARE @enable_clean_operation bit

                DECLARE @caller_name nvarchar(256)
                DECLARE @caller_sid  varbinary(85)
                DECLARE @operation_id bigint

                EXECUTE AS CALLER
                SET @caller_name =  SUSER_NAME()
                SET @caller_sid =   SUSER_SID()
                REVERT

                -- delete all operations 
                BEGIN TRY
                    SELECT @enable_clean_operation = CONVERT(bit, property_value) 
                        FROM [catalog].[catalog_properties]
                        WHERE property_name = 'OPERATION_CLEANUP_ENABLED'

                    IF @enable_clean_operation = 1
                    BEGIN
                        INSERT INTO [internal].[operations] (
                            [operation_type],  
                            [created_time], 
                            [object_type],
                            [object_id],
                            [object_name],
                            [status], 
                            [start_time],
                            [caller_sid], 
                            [caller_name]
                        )
                        VALUES (
                            2,
                            SYSDATETIMEOFFSET(),
                            NULL,                     -- No object type for this operation
                            NULL,                     -- The project_id is not set  
                            NULL,                     -- The object name is not set
                            1,      
                            SYSDATETIMEOFFSET(),
                            @caller_sid,            -- SID of the user 
                            @caller_name            -- Name of the database principal.
                        ) 
                        SET @operation_id = SCOPE_IDENTITY()

                        --check if there are any active operations
                        IF EXISTS (SELECT operation_id FROM [internal].[operations]
                                WHERE [status] IN (2, 5)
                                AND   [operation_id] <> @operation_id )
                        BEGIN    
                            RAISERROR(27139, 16, 1) WITH NOWAIT
                            RETURN 1
                        END 

                        IF NOT EXISTS (SELECT [user_access] FROM sys.databases 
                        WHERE name = 'SSISDB' and [user_access] = 1 )
                        BEGIN
                            RAISERROR(27160, 16 , 1, N'cleanup_server_log' ) WITH NOWAIT
                            RETURN 1
                        END 

                        DECLARE @rows_affected bigint
                        DECLARE @delete_batch_size int

                        -- every time, we would delete 1000 operations per batch
                        SET @delete_batch_size = 1000  
                        SET @rows_affected = @delete_batch_size

                        WHILE (@rows_affected = @delete_batch_size)
                        BEGIN
                            DELETE TOP (@delete_batch_size)
                                FROM [internal].[operations] 
                                WHERE ([operation_type] = 200)
                            SET @rows_affected = @@ROWCOUNT
                        END

                        UPDATE [internal].[operations]
                            SET [status] = 7,
                            [end_time] = SYSDATETIMEOFFSET()
                            WHERE [operation_id] = @operation_id
                    END
                END TRY
                BEGIN CATCH
                    UPDATE [internal].[operations]
                        SET [status] = 4,
                        [end_time] = SYSDATETIMEOFFSET()
                        WHERE [operation_id] = @operation_id;
                    THROW;
                END CATCH

                RETURN 0
            
GO
