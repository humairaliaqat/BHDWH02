USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\abhilash.yelmelwar]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\abhilash.yelmelwar] FOR LOGIN [COVERMORE\abhilash.yelmelwar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\abhilash.yelmelwar]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\abhilash.yelmelwar]
GO
