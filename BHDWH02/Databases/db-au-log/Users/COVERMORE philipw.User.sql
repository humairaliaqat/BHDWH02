USE [DB-AU-LOG]
GO
/****** Object:  User [COVERMORE\philipw]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE USER [COVERMORE\philipw] FOR LOGIN [COVERMORE\philipw] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\philipw]
GO
