USE [DB-AU-LOG]
GO
/****** Object:  User [COVERMORE\dhruvm]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE USER [COVERMORE\dhruvm] FOR LOGIN [COVERMORE\dhruvm] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\dhruvm]
GO
