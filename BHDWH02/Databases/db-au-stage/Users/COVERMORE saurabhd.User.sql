USE [db-au-stage]
GO
/****** Object:  User [COVERMORE\saurabhd]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE USER [COVERMORE\saurabhd] FOR LOGIN [COVERMORE\saurabhd] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\saurabhd]
GO
