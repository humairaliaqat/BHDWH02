USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\SG_Pricing Users]    Script Date: 18/02/2025 12:14:25 PM ******/
CREATE USER [COVERMORE\SG_Pricing Users] FOR LOGIN [COVERMORE\SG_Pricing Users]
GO
ALTER ROLE [db_executor] ADD MEMBER [COVERMORE\SG_Pricing Users]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\SG_Pricing Users]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\SG_Pricing Users]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\SG_Pricing Users]
GO
