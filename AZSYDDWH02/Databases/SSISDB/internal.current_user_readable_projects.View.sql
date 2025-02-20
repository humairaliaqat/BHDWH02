USE [SSISDB]
GO
/****** Object:  View [internal].[current_user_readable_projects]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [internal].[current_user_readable_projects]
AS
SELECT     [object_id] AS [ID]
FROM       [catalog].[effective_object_permissions]
WHERE      [object_type] = 2
           AND  [permission_type] = 1
GO
