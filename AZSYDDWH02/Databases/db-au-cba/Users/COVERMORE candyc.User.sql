USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\candyc]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\candyc] FOR LOGIN [COVERMORE\candyc] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\candyc]
GO
