USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\kota.kumar]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\kota.kumar] FOR LOGIN [COVERMORE\kota.kumar] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\kota.kumar]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\kota.kumar]
GO
