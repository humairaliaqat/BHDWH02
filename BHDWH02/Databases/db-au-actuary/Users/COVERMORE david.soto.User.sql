USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\david.soto]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\david.soto] FOR LOGIN [COVERMORE\david.soto] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\david.soto]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\david.soto]
GO
