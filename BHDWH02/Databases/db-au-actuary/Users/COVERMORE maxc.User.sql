USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\maxc]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\maxc] FOR LOGIN [COVERMORE\maxc] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_executor] ADD MEMBER [COVERMORE\maxc]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\maxc]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\maxc]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\maxc]
GO
