USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\adm_ratneshs]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\adm_ratneshs] FOR LOGIN [COVERMORE\adm_ratneshs] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\adm_ratneshs]
GO
