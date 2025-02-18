USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[check_permission]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [internal].[check_permission]
(
    @object_type SMALLINT,
    @object_id BIGINT,
    @permission_type SMALLINT
)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT
    
    IF (IS_MEMBER('ssis_admin') = 1) OR (IS_SRVROLEMEMBER('sysadmin') = 1)
        RETURN 1
    
    IF EXISTS 
    (
        SELECT [permission_type]
        FROM [catalog].[effective_object_permissions]
        WHERE 
            [object_type] = @object_type
        AND [object_id] = @object_id
        AND [permission_type] = @permission_type
    )
        SET @Result = 1
    ELSE
        SET @Result = 0
  
    RETURN @Result
END
GO
