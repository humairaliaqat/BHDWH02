USE [db-au-star]
GO
/****** Object:  User [COVERMORE\linust]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [COVERMORE\linust] FOR LOGIN [COVERMORE\linust] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\linust]
GO
