USE [db-au-actuary]
GO
/****** Object:  User [cmadmin]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [cmadmin] FOR LOGIN [cmadmin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [cmadmin]
GO
