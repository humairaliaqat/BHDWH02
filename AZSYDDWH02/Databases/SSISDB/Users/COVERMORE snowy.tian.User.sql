USE [SSISDB]
GO
/****** Object:  User [COVERMORE\snowy.tian]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\snowy.tian] FOR LOGIN [COVERMORE\snowy.tian] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\snowy.tian]
GO
