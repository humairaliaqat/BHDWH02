USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\margarete]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\margarete] FOR LOGIN [COVERMORE\margarete] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\margarete]
GO
