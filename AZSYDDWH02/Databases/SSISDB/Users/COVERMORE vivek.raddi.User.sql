USE [SSISDB]
GO
/****** Object:  User [COVERMORE\vivek.raddi]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\vivek.raddi] FOR LOGIN [COVERMORE\vivek.raddi] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\vivek.raddi]
GO
