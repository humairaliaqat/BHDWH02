USE [db-au-actuary]
GO
/****** Object:  Table [ws].[SASMapping]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[SASMapping](
	[BIRowID] [bigint] NOT NULL,
	[FieldName] [varchar](64) NULL,
	[OriginalValue] [nvarchar](255) NULL,
	[MappedValue] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx] ON [ws].[SASMapping]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idxf]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idxf] ON [ws].[SASMapping]
(
	[FieldName] ASC,
	[OriginalValue] ASC
)
INCLUDE([MappedValue]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
