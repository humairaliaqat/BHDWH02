USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\nikita.kale]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\nikita.kale] FOR LOGIN [COVERMORE\nikita.kale] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\nikita.kale]
GO
