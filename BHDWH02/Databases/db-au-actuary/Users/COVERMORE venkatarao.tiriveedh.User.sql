USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\venkatarao.tiriveedh]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\venkatarao.tiriveedh] FOR LOGIN [COVERMORE\venkatarao.tiriveedh] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\venkatarao.tiriveedh]
GO
