USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\saurabhd]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\saurabhd] FOR LOGIN [COVERMORE\saurabhd] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\saurabhd]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\saurabhd]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\saurabhd]
GO
