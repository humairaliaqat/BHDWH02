USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimCSQ]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimCSQ](
	[CSQSK] [int] IDENTITY(1,1) NOT NULL,
	[CSQID] [nvarchar](50) NULL,
	[CSQName] [nvarchar](50) NULL,
	[Company] [nvarchar](50) NULL,
	[SLAPercentage] [int] NULL,
	[SLA] [int] NULL,
	[SelectionCriteria] [nvarchar](50) NULL,
	[isActive] [bit] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimCSQ_CSQSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_dimCSQ_CSQSK] ON [dbo].[dimCSQ]
(
	[CSQSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimCSQ_CSQID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimCSQ_CSQID] ON [dbo].[dimCSQ]
(
	[CSQID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
