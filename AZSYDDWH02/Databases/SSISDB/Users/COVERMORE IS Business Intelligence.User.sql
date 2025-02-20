USE [SSISDB]
GO
/****** Object:  User [COVERMORE\IS Business Intelligence]    Script Date: 20/02/2025 10:29:27 AM ******/
CREATE USER [COVERMORE\IS Business Intelligence] FOR LOGIN [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [ssis_admin] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [ssis_failover_monitoring_agent] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [ssis_logreader] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [db_owner] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [COVERMORE\IS Business Intelligence]
GO
