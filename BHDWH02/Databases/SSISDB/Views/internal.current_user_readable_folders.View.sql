USE [SSISDB]
GO
/****** Object:  View [internal].[current_user_readable_folders]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [internal].[current_user_readable_folders]
AS
SELECT     [object_id] AS [ID]
FROM       [catalog].[effective_object_permissions]
WHERE      [object_type] = 1
           AND  [permission_type] = 1
GO
