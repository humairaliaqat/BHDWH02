USE [SSISDB]
GO
/****** Object:  View [catalog].[extended_operation_info]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [catalog].[extended_operation_info]
AS
SELECT     [info_id], 
           [operation_id], 
           [object_name], 
           [object_type],
           [reference_id],
           [status], 
           [start_time], 
           [end_time]
FROM       [internal].[extended_operation_info]
WHERE      [operation_id] in (SELECT [id] FROM [internal].[current_user_readable_operations])
           OR (IS_MEMBER('ssis_admin') = 1)
           OR (IS_SRVROLEMEMBER('sysadmin') = 1)
GO
