USE [db-au-log]
GO
/****** Object:  User [COVERMORE\humaira.liaqat]    Script Date: 20/02/2025 10:24:01 AM ******/
CREATE USER [COVERMORE\humaira.liaqat] FOR LOGIN [COVERMORE\humaira.liaqat] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\humaira.liaqat]
GO
