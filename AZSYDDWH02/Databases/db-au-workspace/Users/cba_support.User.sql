USE [db-au-workspace]
GO
/****** Object:  User [cba_support]    Script Date: 20/02/2025 10:27:08 AM ******/
CREATE USER [cba_support] FOR LOGIN [cba_support] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [cba_support]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [cba_support]
GO
