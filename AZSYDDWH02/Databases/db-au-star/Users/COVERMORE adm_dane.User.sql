USE [db-au-star]
GO
/****** Object:  User [COVERMORE\adm_dane]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [COVERMORE\adm_dane] FOR LOGIN [COVERMORE\adm_dane] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\adm_dane]
GO
