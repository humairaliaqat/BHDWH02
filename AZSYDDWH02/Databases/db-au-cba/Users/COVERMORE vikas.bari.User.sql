USE [db-au-cba]
GO
/****** Object:  User [COVERMORE\vikas.bari]    Script Date: 20/02/2025 10:13:00 AM ******/
CREATE USER [COVERMORE\vikas.bari] FOR LOGIN [COVERMORE\vikas.bari] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\vikas.bari]
GO
