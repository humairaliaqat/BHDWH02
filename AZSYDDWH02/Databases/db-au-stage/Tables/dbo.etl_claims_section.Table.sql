USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_claims_section]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_claims_section](
	[CountryKey] [varchar](2) NULL,
	[ClaimKey] [varchar](33) NULL,
	[SectionKey] [varchar](95) NULL,
	[EventKey] [varchar](64) NULL,
	[BenefitSectionKey] [varchar](33) NULL,
	[SectionID] [int] NOT NULL,
	[ClaimNo] [int] NULL,
	[EventID] [int] NULL,
	[SectionCode] [varchar](25) NULL,
	[EstimateValue] [money] NULL,
	[Redundant] [int] NOT NULL,
	[BenefitSectionID] [int] NULL,
	[OriginalBenefitSectionID] [int] NULL,
	[BenefitSubSectionID] [int] NULL,
	[BenefitLimit] [nvarchar](200) NULL,
	[SectionDescription] [nvarchar](200) NULL,
	[RecoveryEstimateValue] [money] NULL
) ON [PRIMARY]
GO
