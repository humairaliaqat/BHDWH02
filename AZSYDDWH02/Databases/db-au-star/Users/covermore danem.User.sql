USE [db-au-star]
GO
/****** Object:  User [covermore\danem]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [covermore\danem] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [covermore\danem]
GO
