USE [db-au-workspace]
GO
/****** Object:  User [COVERMORE\erwin.devera]    Script Date: 20/02/2025 10:27:08 AM ******/
CREATE USER [COVERMORE\erwin.devera] FOR LOGIN [COVERMORE\erwin.devera] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\erwin.devera]
GO
