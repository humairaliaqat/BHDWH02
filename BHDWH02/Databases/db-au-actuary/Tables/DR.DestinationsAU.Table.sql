USE [db-au-actuary]
GO
/****** Object:  Table [DR].[DestinationsAU]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[DestinationsAU](
	[Destinations] [nvarchar](max) NULL,
	[PolicyKey] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
