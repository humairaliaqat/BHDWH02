USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\abhilash.yelmelwar]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\abhilash.yelmelwar] FOR LOGIN [COVERMORE\abhilash.yelmelwar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\abhilash.yelmelwar]
GO
