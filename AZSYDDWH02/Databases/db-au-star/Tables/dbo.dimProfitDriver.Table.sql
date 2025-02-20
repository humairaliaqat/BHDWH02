USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimProfitDriver]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimProfitDriver](
	[ProfitDriverSK] [int] NOT NULL,
	[ProfitDriverParentSK] [int] NULL,
	[ProfitDriverCode] [varchar](255) NULL,
	[ProfitDriverDescription] [varchar](255) NULL,
	[SortOrder] [int] NULL,
	[Operator] [varchar](2) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimProfitDriver_ProfitDriverSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_dimProfitDriver_ProfitDriverSK] ON [dbo].[dimProfitDriver]
(
	[ProfitDriverSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimProfitDriver_ProfitDriverCode]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProfitDriver_ProfitDriverCode] ON [dbo].[dimProfitDriver]
(
	[ProfitDriverCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimProfitDriver_ProfitDriverParentSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimProfitDriver_ProfitDriverParentSK] ON [dbo].[dimProfitDriver]
(
	[ProfitDriverParentSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dimProfitDriver] ADD  DEFAULT (getdate()) FOR [CreateDateTime]
GO
