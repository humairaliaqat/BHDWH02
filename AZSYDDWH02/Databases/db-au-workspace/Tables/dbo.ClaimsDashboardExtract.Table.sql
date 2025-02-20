USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[ClaimsDashboardExtract]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClaimsDashboardExtract](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Period] [date] NULL,
	[Metric Group] [varchar](255) NULL,
	[Metric Sub Group] [varchar](255) NULL,
	[Metric Name] [varchar](255) NULL,
	[Value] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:27:08 AM ******/
CREATE CLUSTERED INDEX [cidx] ON [dbo].[ClaimsDashboardExtract]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:27:08 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[ClaimsDashboardExtract]
(
	[Period] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
