USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\appbobj]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\appbobj] FOR LOGIN [COVERMORE\appbobj] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\appbobj]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\appbobj]
GO
