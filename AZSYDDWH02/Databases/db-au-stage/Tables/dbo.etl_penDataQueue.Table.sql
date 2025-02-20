USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penDataQueue]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penDataQueue](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[DataQueueKey] [varchar](41) NULL,
	[JobKey] [varchar](41) NULL,
	[DataQueueID] [int] NOT NULL,
	[JobID] [int] NULL,
	[DataID] [varchar](300) NOT NULL,
	[DataQueueTypeID] [int] NOT NULL,
	[DataValue] [xml] NULL,
	[Comment] [varchar](2000) NULL,
	[RetryCount] [int] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[TrooperName] [varchar](100) NULL,
	[LastSourceUpdated] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
