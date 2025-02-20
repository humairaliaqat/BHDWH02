USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmCatastrophe]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmCatastrophe](
	[CountryKey] [varchar](2) NULL,
	[CatastropheCode] [varchar](3) NULL,
	[TotalIncurred] [money] NULL,
	[UpdateDateTime] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[clmCatastrophe]
(
	[CountryKey] ASC,
	[CatastropheCode] ASC
)
INCLUDE([TotalIncurred]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
