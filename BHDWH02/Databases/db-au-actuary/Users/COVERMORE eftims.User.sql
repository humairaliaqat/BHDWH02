USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\eftims]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\eftims] FOR LOGIN [COVERMORE\eftims] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_executor] ADD MEMBER [COVERMORE\eftims]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\eftims]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\eftims]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\eftims]
GO
