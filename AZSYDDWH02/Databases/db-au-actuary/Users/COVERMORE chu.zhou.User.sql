USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\chu.zhou]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\chu.zhou] FOR LOGIN [COVERMORE\chu.zhou] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\chu.zhou]
GO
