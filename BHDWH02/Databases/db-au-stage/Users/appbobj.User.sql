USE [db-au-stage]
GO
/****** Object:  User [appbobj]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [appbobj] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [appbobj]
GO
