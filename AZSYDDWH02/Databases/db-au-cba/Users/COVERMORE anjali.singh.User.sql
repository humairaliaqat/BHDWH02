USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\anjali.singh]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\anjali.singh] FOR LOGIN [COVERMORE\anjali.singh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\anjali.singh]
GO
