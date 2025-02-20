USE [db-au-actuary]
GO
/****** Object:  Table [ws].[ClaimEstimateMovement]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[ClaimEstimateMovement](
	[BIRowID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[SectionKey] [varchar](40) NOT NULL,
	[SectionCode] [varchar](25) NULL,
	[EstimateDate] [datetime] NULL,
	[Currency] [varchar](3) NOT NULL,
	[FXRate] [numeric](5, 4) NOT NULL,
	[EstimateValue] [decimal](20, 6) NULL,
	[RecoveryEstimateValue] [decimal](20, 6) NULL,
	[EstimateMovement] [decimal](20, 6) NULL,
	[RecoveryEstimateMovement] [decimal](20, 6) NULL,
 CONSTRAINT [PK_ClaimEstimateMovement] PRIMARY KEY NONCLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx] ON [ws].[ClaimEstimateMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [ws].[ClaimEstimateMovement]
(
	[ClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
