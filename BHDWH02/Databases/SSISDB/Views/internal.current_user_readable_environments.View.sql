USE [SSISDB]
GO
/****** Object:  View [internal].[current_user_readable_environments]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [internal].[current_user_readable_environments]
AS
SELECT     [object_id] AS [ID]
FROM       [catalog].[effective_object_permissions]
WHERE      [object_type] = 3
           AND  [permission_type] = 1
GO
