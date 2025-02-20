USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penBenefit]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penBenefit](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[BenefitKey] [varchar](71) NULL,
	[BenefitID] [int] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[DomainID] [int] NOT NULL,
	[DisplayName] [nvarchar](200) NOT NULL,
	[HelpText] [nvarchar](max) NOT NULL,
	[BenefitCodeId] [int] NOT NULL,
	[BenefitCoverTypeId] [int] NULL,
	[IsClaimsBenefit] [bit] NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Status] [varchar](15) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
