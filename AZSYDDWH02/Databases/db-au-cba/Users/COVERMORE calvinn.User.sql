USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\calvinn]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\calvinn] FOR LOGIN [COVERMORE\calvinn] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\calvinn]
GO
