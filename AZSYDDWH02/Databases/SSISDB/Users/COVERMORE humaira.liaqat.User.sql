USE [SSISDB]
GO
/****** Object:  User [COVERMORE\humaira.liaqat]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\humaira.liaqat] FOR LOGIN [COVERMORE\humaira.liaqat] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [COVERMORE\humaira.liaqat]
GO
