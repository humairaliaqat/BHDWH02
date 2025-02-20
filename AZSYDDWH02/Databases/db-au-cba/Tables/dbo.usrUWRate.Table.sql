USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrUWRate]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrUWRate](
	[BIRowID] [bigint] NOT NULL,
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[GroupCode] [nvarchar](50) NULL,
	[Excess] [money] NULL,
	[Area] [varchar](20) NULL,
	[MinimumAge] [int] NULL,
	[MaximumAge] [int] NULL,
	[UWRate] [numeric](10, 5) NULL
) ON [PRIMARY]
GO
