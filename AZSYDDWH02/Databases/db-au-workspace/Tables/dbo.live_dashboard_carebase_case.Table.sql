USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[live_dashboard_carebase_case]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[live_dashboard_carebase_case](
	[ClientName] [nvarchar](100) NULL,
	[Country] [nvarchar](max) NULL,
	[TotalActiveCases] [int] NULL,
	[ActiveChild] [int] NULL,
	[ActiveICU] [int] NULL,
	[ActiveRepatration] [int] NULL,
	[ActiveEVAC] [int] NULL,
	[ActiveDeath] [int] NULL,
	[ActiveInpatient20K] [int] NULL,
	[ActiveHighRisk200K] [int] NULL,
	[ActiveDental] [int] NULL,
	[OpenedToday] [int] NULL,
	[OpenedMTD] [int] NULL,
	[CloseedToday] [int] NULL,
	[ClosedMTD] [int] NULL,
	[ActiveMedical] [int] NULL,
	[ActiveTechnical] [int] NULL,
	[ActiveHighRisk] [int] NULL,
	[ActiveMediumRisk] [int] NULL,
	[ActiveLowRisk] [int] NULL,
	[ActiveVeryHighRisk] [int] NULL,
	[ActivePlan] [int] NULL,
	[ActivePlanCM] [int] NULL,
	[ActivePlanRN] [int] NULL,
	[ActivePlanTL] [int] NULL,
	[ActivePlanCG] [int] NULL,
	[ActivePlanIB] [int] NULL,
	[ActivePlanEX] [int] NULL,
	[Active0To7] [int] NULL,
	[Active8To14] [int] NULL,
	[Active15To30] [int] NULL,
	[ActiveOver30] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
