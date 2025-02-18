USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UW_Destinations_2021]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UW_Destinations_2021](
	[Destination] [nvarchar](50) NULL,
	[Fix] [nvarchar](50) NULL,
	[Region] [nvarchar](50) NULL,
	[UW_Destination_2017] [nvarchar](50) NULL,
	[UW_Destination_2021] [nvarchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UW_Destinations_Destination]    Script Date: 18/02/2025 12:14:27 PM ******/
CREATE CLUSTERED INDEX [idx_UW_Destinations_Destination] ON [cng].[UW_Destinations_2021]
(
	[Destination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
