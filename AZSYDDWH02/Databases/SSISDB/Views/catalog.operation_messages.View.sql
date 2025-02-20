USE [SSISDB]
GO
/****** Object:  View [catalog].[operation_messages]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [catalog].[operation_messages]
AS
SELECT     [operation_message_id], 
           [operation_id], 
           [message_time],
           [message_type],  
           [message_source_type], 
           [message], 
           [extended_info_id]
FROM       [internal].[operation_messages] 
WHERE      [operation_id] in (SELECT [id] FROM [internal].[current_user_readable_operations])
           OR (IS_MEMBER('ssis_admin') = 1)
           OR (IS_SRVROLEMEMBER('sysadmin') = 1)
           OR (IS_MEMBER('ssis_logreader') = 1)

GO
