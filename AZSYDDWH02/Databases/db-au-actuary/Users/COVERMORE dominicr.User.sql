USE [db-au-actuary]
GO
/****** Object:  User [COVERMORE\dominicr]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE USER [COVERMORE\dominicr] FOR LOGIN [COVERMORE\dominicr] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [COVERMORE\dominicr]
GO
