USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\mollym]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\mollym] FOR LOGIN [COVERMORE\mollym] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\mollym]
GO
