USE [SSISDB]
GO
/****** Object:  User [AllSchemaOwner]    Script Date: 18/02/2025 2:36:17 PM ******/
CREATE USER [AllSchemaOwner] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [ssis_admin] ADD MEMBER [AllSchemaOwner]
GO
