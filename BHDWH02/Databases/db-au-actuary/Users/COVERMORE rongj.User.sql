USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\rongj]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\rongj] FOR LOGIN [COVERMORE\rongj] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\rongj]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\rongj]
GO
