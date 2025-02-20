USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimIncurredMovement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimIncurredMovement](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[IncurredTime] [datetime] NULL,
	[IncurredDate] [date] NULL,
	[EstimateMovement] [decimal](20, 6) NULL,
	[RecoveryEstimateMovement] [decimal](20, 6) NULL,
	[PaymentMovement] [decimal](20, 6) NULL,
	[MovementSequence] [bigint] NULL,
	[FirstMovement] [bit] NULL,
	[FirstMovementInDay] [bit] NULL,
	[BatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimIncurredMovement_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaimIncurredMovement_BIRowID] ON [dbo].[clmClaimIncurredMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimIncurredMovement_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimIncurredMovement_ClaimKey] ON [dbo].[clmClaimIncurredMovement]
(
	[ClaimKey] ASC,
	[IncurredTime] ASC
)
INCLUDE([IncurredDate],[EstimateMovement],[RecoveryEstimateMovement],[PaymentMovement],[FirstMovement],[FirstMovementInDay],[MovementSequence]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimIncurredMovement_ClaimKeyDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimIncurredMovement_ClaimKeyDate] ON [dbo].[clmClaimIncurredMovement]
(
	[ClaimKey] ASC,
	[IncurredDate] ASC,
	[MovementSequence] ASC
)
INCLUDE([IncurredTime],[EstimateMovement],[PaymentMovement]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimIncurredMovement_IncurredDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimIncurredMovement_IncurredDate] ON [dbo].[clmClaimIncurredMovement]
(
	[IncurredDate] ASC,
	[ClaimKey] ASC
)
INCLUDE([IncurredTime],[EstimateMovement],[RecoveryEstimateMovement],[PaymentMovement],[FirstMovement],[FirstMovementInDay],[MovementSequence]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
