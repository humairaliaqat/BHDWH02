USE [SSISDB]
GO
/****** Object:  User [COVERMORE\surbhi.gupta]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\surbhi.gupta] FOR LOGIN [COVERMORE\surbhi.gupta] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\surbhi.gupta]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\surbhi.gupta]
GO
