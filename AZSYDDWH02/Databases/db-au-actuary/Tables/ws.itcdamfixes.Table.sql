USE [db-au-actuary]
GO
/****** Object:  Table [ws].[itcdamfixes]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[itcdamfixes](
	[claimno] [bigint] NULL,
	[claimID] [bigint] NULL,
	[ITC_DAM] [real] NULL,
	[AUD_amt] [real] NULL,
	[PaymentKey] [varchar](40) NULL,
	[BIRowID] [bigint] NOT NULL
) ON [PRIMARY]
GO
