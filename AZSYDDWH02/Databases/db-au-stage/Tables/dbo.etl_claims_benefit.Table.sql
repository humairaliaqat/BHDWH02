USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_claims_benefit]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_claims_benefit](
	[CountryKey] [varchar](2) NULL,
	[BenefitSectionKey] [varchar](33) NULL,
	[BenefitSectionID] [int] NOT NULL,
	[BenefitCode] [varchar](25) NULL,
	[BenefitDesc] [nvarchar](255) NULL,
	[ProductCode] [varchar](5) NULL,
	[BenefitValidFrom] [date] NULL,
	[BenefitValidTo] [date] NULL,
	[BenefitLimit] [money] NULL,
	[PrintOrder] [smallint] NULL,
	[CommonCategory] [int] NULL
) ON [PRIMARY]
GO
