USE [DB-AU-LOG]
GO
/****** Object:  User [appbobj]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE USER [appbobj] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [appbobj]
GO
