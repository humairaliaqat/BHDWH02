USE [db-au-star]
GO
/****** Object:  User [COVERMORE\brookl]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE USER [COVERMORE\brookl] FOR LOGIN [COVERMORE\brookl] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\brookl]
GO
