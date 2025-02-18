USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[ETL_Exception]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETL_Exception](
	[ExceptionID] [int] IDENTITY(0,1) NOT NULL,
	[REF_ExceptionID] [int] NULL,
	[CountryKey] [varchar](50) NULL,
	[CompanyKey] [varchar](50) NULL,
	[DomainID] [int] NULL,
	[EntityKey] [varchar](255) NULL,
	[SourceTab] [varchar](50) NULL,
	[ExceptionType] [varchar](50) NULL,
	[InsertDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[isValid] [char](1) NULL
) ON [PRIMARY]
GO
