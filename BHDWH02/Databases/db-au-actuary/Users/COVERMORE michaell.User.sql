USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\michaell]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\michaell] FOR LOGIN [COVERMORE\michaell] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\michaell]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\michaell]
GO
