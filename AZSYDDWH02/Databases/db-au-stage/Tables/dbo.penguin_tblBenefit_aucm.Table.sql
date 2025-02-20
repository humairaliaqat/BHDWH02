USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblBenefit_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblBenefit_aucm](
	[BenefitId] [int] NOT NULL,
	[Name] [nvarchar](200) NULL,
	[SortOrder] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[DisplayName] [nvarchar](200) NOT NULL,
	[HelpText] [nvarchar](max) NOT NULL,
	[BenefitCodeId] [int] NOT NULL,
	[BenefitCoverTypeId] [int] NULL,
	[IsClaimsBenefit] [bit] NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Status] [varchar](15) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
