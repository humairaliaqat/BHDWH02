USE [SSISDB]
GO
/****** Object:  User [COVERMORE\nimmu.ivan]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\nimmu.ivan] FOR LOGIN [COVERMORE\nimmu.ivan] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\nimmu.ivan]
GO
