USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\laura.zhao]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\laura.zhao] FOR LOGIN [COVERMORE\laura.zhao] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\laura.zhao]
GO
