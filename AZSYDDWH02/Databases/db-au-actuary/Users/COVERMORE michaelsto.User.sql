USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\michaelsto]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\michaelsto] FOR LOGIN [COVERMORE\michaelsto] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\michaelsto]
GO
