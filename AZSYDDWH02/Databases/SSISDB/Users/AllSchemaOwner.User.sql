USE [SSISDB]
GO
/****** Object:  User [AllSchemaOwner]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [AllSchemaOwner] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [ssis_admin] ADD MEMBER [AllSchemaOwner]
GO
