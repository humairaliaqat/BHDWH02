USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\roy.alingcastre]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\roy.alingcastre] FOR LOGIN [COVERMORE\roy.alingcastre] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\roy.alingcastre]
GO
