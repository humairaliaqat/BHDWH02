USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[itcdamfixes_240207]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[itcdamfixes_240207](
	[claimno] [bigint] NULL,
	[claimID] [bigint] NULL,
	[ITC_DAM] [real] NULL,
	[AUD_amt] [real] NULL,
	[PaymentKey] [varchar](40) NULL,
	[BIRowID] [bigint] NOT NULL
) ON [PRIMARY]
GO
