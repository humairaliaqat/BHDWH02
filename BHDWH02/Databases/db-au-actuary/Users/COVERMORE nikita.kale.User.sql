USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\nikita.kale]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\nikita.kale] FOR LOGIN [COVERMORE\nikita.kale] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\nikita.kale]
GO
