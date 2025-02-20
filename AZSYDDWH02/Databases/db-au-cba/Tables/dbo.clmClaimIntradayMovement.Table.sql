USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmClaimIntradayMovement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmClaimIntradayMovement](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[FirstIncurredDate] [date] NULL,
	[AbsoluteAge] [int] NULL,
	[PreviousAbsoluteAge] [int] NULL,
	[IncurredDate] [date] NULL,
	[IncurredTime] [datetime] NULL,
	[IncurredAge] [int] NULL,
	[Estimate] [decimal](20, 6) NULL,
	[Paid] [decimal](20, 6) NULL,
	[IncurredValue] [decimal](20, 6) NULL,
	[PreviousEstimate] [decimal](20, 6) NULL,
	[PreviousPaid] [decimal](20, 6) NULL,
	[PreviousIncurred] [decimal](20, 6) NULL,
	[EstimateDelta] [decimal](20, 6) NULL,
	[PaymentDelta] [decimal](20, 6) NULL,
	[IncurredDelta] [decimal](20, 6) NULL,
	[NewCount] [int] NULL,
	[ReopenedCount] [int] NULL,
	[ClosedCount] [int] NULL,
	[BatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmClaimIntradayMovement_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmClaimIntradayMovement_BIRowID] ON [dbo].[clmClaimIntradayMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimIntradayMovement_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimIntradayMovement_ClaimKey] ON [dbo].[clmClaimIntradayMovement]
(
	[ClaimKey] ASC,
	[IncurredDate] ASC
)
INCLUDE([EstimateDelta],[PaymentDelta],[IncurredDelta],[NewCount],[ReopenedCount],[ClosedCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmClaimIntradayMovement_IncurredDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmClaimIntradayMovement_IncurredDate] ON [dbo].[clmClaimIntradayMovement]
(
	[IncurredDate] ASC,
	[ClaimKey] ASC
)
INCLUDE([EstimateDelta],[PaymentDelta],[IncurredDelta],[NewCount],[ReopenedCount],[ClosedCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
