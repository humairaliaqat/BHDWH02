USE [db-au-star]
GO
/****** Object:  User [COVERMORE\mollym]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [COVERMORE\mollym] FOR LOGIN [COVERMORE\mollym] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\mollym]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\mollym]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\mollym]
GO
