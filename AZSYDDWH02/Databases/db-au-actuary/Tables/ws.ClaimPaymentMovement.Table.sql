USE [db-au-actuary]
GO
/****** Object:  Table [ws].[ClaimPaymentMovement]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[ClaimPaymentMovement](
	[BIRowID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[SectionKey] [varchar](40) NULL,
	[SectionCode] [varchar](25) NULL,
	[PaymentKey] [varchar](40) NULL,
	[AuditKey] [varchar](50) NOT NULL,
	[PaymentDate] [datetime] NULL,
	[Currency] [varchar](3) NULL,
	[FXRate] [decimal](25, 10) NULL,
	[PaymentStatus] [varchar](4) NULL,
	[PaymentAmount] [decimal](20, 6) NOT NULL,
	[ITCDAM] [decimal](20, 6) NULL,
	[NetPayment] [decimal](20, 6) NULL,
	[PaymentMovement] [decimal](20, 6) NULL,
	[ITCDAMMovement] [decimal](20, 6) NULL,
	[NetPaymentMovement] [decimal](20, 6) NULL,
	[asRecovery] [int] NOT NULL,
	[asEstimate] [int] NOT NULL,
 CONSTRAINT [PK_ClaimPaymentMovement] PRIMARY KEY NONCLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx] ON [ws].[ClaimPaymentMovement]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [ws].[ClaimPaymentMovement]
(
	[ClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
