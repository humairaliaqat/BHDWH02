USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[cy2020_policy]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cy2020_policy](
	[sBU JV Revenue Active] [nvarchar](255) NULL,
	[sBU JV Revenue Active: Business Unit List] [nvarchar](255) NULL,
	[sBU JV Revenue Active: JV List] [nvarchar](255) NULL,
	[subChannel_RevenueModelling] [nvarchar](255) NULL,
	[subProduct_Revenue Modelling] [nvarchar](255) NULL,
	[Jan 20] [float] NULL,
	[Feb 20] [float] NULL,
	[Mar 20] [float] NULL,
	[Apr 20] [float] NULL,
	[May 20] [float] NULL,
	[Jun 20] [float] NULL,
	[Jul 20] [float] NULL,
	[Aug 20] [float] NULL,
	[Sep 20] [float] NULL,
	[Oct 20] [float] NULL,
	[Nov 20] [float] NULL,
	[Dec 20] [float] NULL,
	[Total] [float] NULL
) ON [PRIMARY]
GO
