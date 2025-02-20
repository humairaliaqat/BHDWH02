USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbEmotion]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbEmotion](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[EmotionDate] [datetime] NULL,
	[EmotionTimeUTC] [datetime] NULL,
	[Emotion] [nvarchar](50) NULL,
	[Comments] [nvarchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbEmotion_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbEmotion_BIRowID] ON [dbo].[cbEmotion]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbEmotion_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbEmotion_CaseKey] ON [dbo].[cbEmotion]
(
	[CaseKey] ASC,
	[EmotionDate] DESC
)
INCLUDE([Emotion]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbEmotion_CaseNo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbEmotion_CaseNo] ON [dbo].[cbEmotion]
(
	[CaseNo] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
