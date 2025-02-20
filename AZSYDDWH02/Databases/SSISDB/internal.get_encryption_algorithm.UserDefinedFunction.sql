USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[get_encryption_algorithm]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [internal].[get_encryption_algorithm]()
RETURNS nvarchar(255)
AS
BEGIN
  DECLARE @value nvarchar(255)
  SELECT @value = [property_value] 
  FROM [catalog].[catalog_properties] 
  WHERE property_name = 'ENCRYPTION_ALGORITHM'
  IF @value IS NULL
      RETURN NULL
      
  DECLARE @valid INT
  SELECT @valid = [internal].[validate_encryption_algorithm](@value)
  IF @valid <> 0
      SET @value = NULL
  
  RETURN @value
END
GO
