USE [SSISDB]
GO
/****** Object:  User [COVERMORE\venkatarao.tiriveedh]    Script Date: 18/02/2025 2:36:17 PM ******/
CREATE USER [COVERMORE\venkatarao.tiriveedh] FOR LOGIN [COVERMORE\venkatarao.tiriveedh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\venkatarao.tiriveedh]
GO
