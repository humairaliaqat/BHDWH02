USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\b.sumanth]    Script Date: 20/02/2025 10:25:21 AM ******/
CREATE USER [COVERMORE\b.sumanth] FOR LOGIN [COVERMORE\b.sumanth] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\b.sumanth]
GO
