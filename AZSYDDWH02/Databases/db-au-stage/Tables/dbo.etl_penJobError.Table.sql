USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penJobError]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penJobError](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[JobErrorKey] [varchar](41) NULL,
	[JobKey] [varchar](41) NULL,
	[ID] [int] NOT NULL,
	[JobID] [int] NOT NULL,
	[Description] [varchar](max) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[ErrorSource] [varchar](15) NOT NULL,
	[DataID] [varchar](300) NULL,
	[SourceData] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
