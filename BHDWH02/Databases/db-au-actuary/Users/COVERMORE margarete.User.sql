USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\margarete]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\margarete] FOR LOGIN [COVERMORE\margarete] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\margarete]
GO
