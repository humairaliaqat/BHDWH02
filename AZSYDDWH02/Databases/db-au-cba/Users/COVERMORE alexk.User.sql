USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\alexk]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\alexk] FOR LOGIN [COVERMORE\alexk] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\alexk]
GO
