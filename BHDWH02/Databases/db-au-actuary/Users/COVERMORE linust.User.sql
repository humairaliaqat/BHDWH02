USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\linust]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\linust] FOR LOGIN [COVERMORE\linust] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\linust]
GO
