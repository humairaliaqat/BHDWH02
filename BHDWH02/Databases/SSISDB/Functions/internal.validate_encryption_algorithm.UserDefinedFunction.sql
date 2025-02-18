USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[validate_encryption_algorithm]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [internal].[validate_encryption_algorithm](@algorithm_name nvarchar(255))
RETURNS INT
AS
BEGIN
  DECLARE @ret INT 
     
  IF @algorithm_name IN ('TRIPLE_DES_3KEY', 'AES_128', 'AES_192' , 'AES_256')
      SET @ret = 0
  ELSE
      SET @ret = -1
  
  RETURN @ret
END
GO
