USE [SSISDB]
GO
/****** Object:  User [COVERMORE\venkatarao.tiriveedh]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\venkatarao.tiriveedh] FOR LOGIN [COVERMORE\venkatarao.tiriveedh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\venkatarao.tiriveedh]
GO
