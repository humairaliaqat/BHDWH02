USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\ashwani.singh]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\ashwani.singh] FOR LOGIN [COVERMORE\ashwani.singh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_executor] ADD MEMBER [COVERMORE\ashwani.singh]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\ashwani.singh]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\ashwani.singh]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\ashwani.singh]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\ashwani.singh]
GO
