USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimTransactionTypeStatus]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimTransactionTypeStatus](
	[TransactionTypeStatusSK] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionType] [nvarchar](50) NULL,
	[TransactionStatus] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [cidx] ON [dbo].[dimTransactionTypeStatus]
(
	[TransactionTypeStatusSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[dimTransactionTypeStatus]
(
	[TransactionType] ASC,
	[TransactionStatus] ASC
)
INCLUDE([TransactionTypeStatusSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
