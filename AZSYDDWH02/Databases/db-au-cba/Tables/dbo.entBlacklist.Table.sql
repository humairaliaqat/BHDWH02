USE [db-au-cba]
GO
/****** Object:  Table [dbo].[entBlacklist]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entBlacklist](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NULL,
	[PolicyKey] [varchar](50) NULL,
	[SURNAME] [varchar](50) NULL,
	[GIVEN] [varchar](50) NULL,
	[DOB] [date] NULL,
	[ADDRESS] [varchar](250) NULL,
	[EMAIL] [varchar](250) NULL,
	[CLAIM] [varchar](50) NULL,
	[POLICY] [varchar](50) NULL,
	[FRAUD] [varchar](50) NULL,
	[REASON] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [cidx]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx] ON [dbo].[entBlacklist]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[entBlacklist]
(
	[CustomerID] ASC
)
INCLUDE([REASON]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
