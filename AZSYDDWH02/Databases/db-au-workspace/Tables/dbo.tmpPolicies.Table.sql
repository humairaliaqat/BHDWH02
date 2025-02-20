USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[tmpPolicies]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpPolicies](
	[OutletAlphaKey] [nvarchar](50) NOT NULL,
	[Date] [date] NULL,
	[policyKey] [varchar](41) NULL,
	[UniquePlanID] [int] NOT NULL,
	[TravelGroup] [varchar](6) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[TransactionType] [varchar](10) NOT NULL,
	[ChannelSource] [varchar](11) NOT NULL,
	[BasePolicyCount] [int] NOT NULL,
	[GrossPremium] [money] NULL,
	[Commission] [money] NULL
) ON [PRIMARY]
GO
