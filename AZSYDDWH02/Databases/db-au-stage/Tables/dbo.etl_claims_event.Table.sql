USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_claims_event]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_claims_event](
	[CountryKey] [varchar](2) NULL,
	[ClaimKey] [varchar](33) NULL,
	[EventKey] [varchar](64) NULL,
	[EventID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[EMCID] [int] NULL,
	[PerilCode] [varchar](3) NULL,
	[PerilDesc] [varchar](65) NULL,
	[EventCountryCode] [varchar](3) NULL,
	[EventCountryName] [varchar](200) NULL,
	[EventDesc] [nvarchar](100) NULL,
	[EventDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[EventDateTimeUTC] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NULL,
	[CreatedBy] [varchar](30) NULL,
	[CaseID] [varchar](15) NULL,
	[CatastropheCode] [varchar](3) NULL,
	[CatastropheShortDesc] [varchar](20) NULL,
	[CatastropheLongDesc] [nvarchar](60) NULL
) ON [PRIMARY]
GO
