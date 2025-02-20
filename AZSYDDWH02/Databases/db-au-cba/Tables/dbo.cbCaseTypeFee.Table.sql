USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbCaseTypeFee]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbCaseTypeFee](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[FeeID] [int] NOT NULL,
	[ClientCode] [nvarchar](2) NOT NULL,
	[ProgramType] [nvarchar](2) NULL,
	[ProgramDescription] [nvarchar](255) NULL,
	[Channel] [nvarchar](250) NULL,
	[CaseType] [nvarchar](255) NULL,
	[Protocol] [nvarchar](250) NULL,
	[Fee] [money] NULL,
	[Tax] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCaseTypeFee_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbCaseTypeFee_BIRowID] ON [dbo].[cbCaseTypeFee]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbCaseTypeFee_FeeID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbCaseTypeFee_FeeID] ON [dbo].[cbCaseTypeFee]
(
	[FeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
