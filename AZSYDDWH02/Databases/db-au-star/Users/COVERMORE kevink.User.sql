USE [db-au-star]
GO
/****** Object:  User [COVERMORE\kevink]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [COVERMORE\kevink] FOR LOGIN [COVERMORE\kevink] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\kevink]
GO
