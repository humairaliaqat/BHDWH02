USE [DB-AU-LOG]
GO
/****** Object:  User [COVERMORE\nikita.kale]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE USER [COVERMORE\nikita.kale] FOR LOGIN [COVERMORE\nikita.kale] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\nikita.kale]
GO
