USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\shu.low]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\shu.low] FOR LOGIN [COVERMORE\shu.low] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\shu.low]
GO
