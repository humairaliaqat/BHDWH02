USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\adellep]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\adellep] FOR LOGIN [COVERMORE\adellep] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\adellep]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\adellep]
GO
