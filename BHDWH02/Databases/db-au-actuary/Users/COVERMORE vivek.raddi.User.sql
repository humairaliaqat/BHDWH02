USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\vivek.raddi]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\vivek.raddi] FOR LOGIN [COVERMORE\vivek.raddi] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\vivek.raddi]
GO
