USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimAgeBand]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimAgeBand](
	[AgeBandSK] [int] IDENTITY(1,1) NOT NULL,
	[Age] [int] NOT NULL,
	[Code] [nvarchar](50) NULL,
	[AgeBand] [nvarchar](50) NULL,
	[ABSAgeBand] [nvarchar](50) NULL,
	[ABSAgeCategory] [nvarchar](50) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimAgeBand_AgeBandSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_dimAgeBand_AgeBandSK] ON [dbo].[dimAgeBand]
(
	[AgeBandSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimAgeBand_ABSAgeBand]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimAgeBand_ABSAgeBand] ON [dbo].[dimAgeBand]
(
	[ABSAgeBand] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimAgeBand_ABSAgeCategory]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimAgeBand_ABSAgeCategory] ON [dbo].[dimAgeBand]
(
	[ABSAgeCategory] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimAgeBand_Age]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimAgeBand_Age] ON [dbo].[dimAgeBand]
(
	[Age] ASC
)
INCLUDE([AgeBandSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimAgeBand_AgeBand]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimAgeBand_AgeBand] ON [dbo].[dimAgeBand]
(
	[AgeBand] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimAgeBand_HashKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimAgeBand_HashKey] ON [dbo].[dimAgeBand]
(
	[HashKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
