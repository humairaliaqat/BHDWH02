USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\nimmu.ivan]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\nimmu.ivan] FOR LOGIN [COVERMORE\nimmu.ivan] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\nimmu.ivan]
GO
