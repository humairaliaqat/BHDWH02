USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[penpolicytransaddon]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penpolicytransaddon](
	[PolicyTransactionKey] [varchar](41) NULL,
	[AddOnGroup] [nvarchar](50) NULL,
	[AddOnText] [nvarchar](500) NULL,
	[CoverIncrease] [money] NULL,
	[GrossPremium] [money] NULL,
	[UnAdjGrossPremium] [money] NULL,
	[AddonCount] [int] NULL,
	[PolicyKey] [varchar](41) NULL
) ON [PRIMARY]
GO
