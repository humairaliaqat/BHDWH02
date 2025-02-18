USE [SSISDB]
GO
/****** Object:  View [catalog].[executable_statistics]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [catalog].[executable_statistics]
AS
SELECT     [statistics_id], 
           [execution_id],
           [executable_id], 
           [execution_path], 
           [start_time],
           [end_time],
           [execution_duration], 
           [execution_result],
           [execution_value]
FROM       [internal].[executable_statistics]
WHERE      [execution_id] in (SELECT id FROM [internal].[current_user_readable_operations])
           OR (IS_MEMBER('ssis_admin') = 1)
           OR (IS_SRVROLEMEMBER('sysadmin') = 1)

GO
