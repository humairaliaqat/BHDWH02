USE [SSISDB]
GO
/****** Object:  User [COVERMORE\mollym]    Script Date: 18/02/2025 2:36:17 PM ******/
CREATE USER [COVERMORE\mollym] FOR LOGIN [COVERMORE\mollym] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\mollym]
GO
