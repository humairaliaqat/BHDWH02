USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\candyc]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\candyc] FOR LOGIN [COVERMORE\candyc] WITH DEFAULT_SCHEMA=[ws]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\candyc]
GO
