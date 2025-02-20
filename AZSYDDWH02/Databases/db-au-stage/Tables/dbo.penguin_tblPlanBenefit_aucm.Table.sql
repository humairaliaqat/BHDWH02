USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPlanBenefit_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPlanBenefit_aucm](
	[PlanBenefitID] [int] NOT NULL,
	[PlanId] [int] NOT NULL,
	[BenefitId] [int] NOT NULL,
	[BenefitValue] [nvarchar](300) NULL,
	[BenefitCoverTypeId] [int] NULL,
	[BenefitAmount] [nvarchar](25) NULL,
	[ExcessApplies] [nvarchar](150) NULL
) ON [PRIMARY]
GO
