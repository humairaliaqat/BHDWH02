USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\maxc]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\maxc] FOR LOGIN [COVERMORE\maxc] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\maxc]
GO
