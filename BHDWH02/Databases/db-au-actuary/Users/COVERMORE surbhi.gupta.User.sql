USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\surbhi.gupta]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\surbhi.gupta] FOR LOGIN [COVERMORE\surbhi.gupta] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\surbhi.gupta]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\surbhi.gupta]
GO
