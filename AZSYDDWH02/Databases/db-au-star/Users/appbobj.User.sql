USE [db-au-star]
GO
/****** Object:  User [appbobj]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [appbobj] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [appbobj]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appbobj]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [appbobj]
GO
