USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnValueSet_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnValueSet_aucm](
	[AddOnValueSetID] [int] NOT NULL,
	[PlanID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[MaxCover] [money] NULL,
	[IsPolicyAddon] [bit] NOT NULL,
	[IsSelectPerTraveller] [bit] NOT NULL
) ON [PRIMARY]
GO
