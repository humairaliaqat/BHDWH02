USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblPlanCode_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblPlanCode_AU](
	[PlanCodeId] [int] NOT NULL,
	[PolTypeId] [int] NOT NULL,
	[SingMultiId] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
	[PlanCode] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
