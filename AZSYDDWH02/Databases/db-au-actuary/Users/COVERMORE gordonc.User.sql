USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\gordonc]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\gordonc] FOR LOGIN [COVERMORE\gordonc] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\gordonc]
GO
