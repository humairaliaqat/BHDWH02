USE [db-au-cba]
GO
/****** Object:  User [sqltest]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [sqltest] FOR LOGIN [sqltest] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [sqltest]
GO
ALTER ROLE [db_datareader] ADD MEMBER [sqltest]
GO
