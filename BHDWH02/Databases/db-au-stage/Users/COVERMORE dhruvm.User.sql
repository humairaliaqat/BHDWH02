USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\dhruvm]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\dhruvm] FOR LOGIN [COVERMORE\dhruvm] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\dhruvm]
GO
