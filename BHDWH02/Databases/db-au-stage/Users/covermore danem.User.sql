USE [db-au-stage]
GO
/****** Object:  User [covermore\danem]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [covermore\danem] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [covermore\danem]
GO
