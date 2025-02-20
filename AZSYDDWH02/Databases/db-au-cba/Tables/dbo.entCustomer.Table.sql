USE [db-au-cba]
GO
/****** Object:  Table [dbo].[entCustomer]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[entCustomer](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[DeleteDate] [datetime] NULL,
	[ConsolidationID] [bigint] NULL,
	[Status] [nvarchar](10) NULL,
	[CUstomerName] [nvarchar](255) NULL,
	[CustomerRole] [nvarchar](50) NULL,
	[Title] [nvarchar](20) NULL,
	[FirstName] [nvarchar](100) NULL,
	[MidName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Gender] [nvarchar](7) NULL,
	[MaritalStatus] [nvarchar](15) NULL,
	[DOB] [date] NULL,
	[isDeceased] [bit] NULL,
	[CurrentAddress] [nvarchar](614) NULL,
	[CurrentEmail] [nvarchar](255) NULL,
	[CurrentContact] [nvarchar](25) NULL,
	[MergedTo] [bigint] NULL,
	[UpdateBatchID] [bigint] NULL,
	[FTS] [nvarchar](max) NULL,
	[PrimaryScore] [int] NULL,
	[SecondaryScore] [int] NULL,
	[SanctionScore] [int] NULL,
	[SanctionReference] [varchar](max) NULL,
	[ClaimScore] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_entCustomer_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [idx_entCustomer_BIRowID] ON [dbo].[entCustomer]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [id_entCustomer_CurrentEmail]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [id_entCustomer_CurrentEmail] ON [dbo].[entCustomer]
(
	[CurrentEmail] ASC,
	[DOB] ASC,
	[CurrentContact] ASC
)
INCLUDE([CustomerID],[CUstomerName],[MergedTo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_address]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_address] ON [dbo].[entCustomer]
(
	[LastName] ASC,
	[CurrentAddress] ASC
)
INCLUDE([CustomerID],[FirstName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_email]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_email] ON [dbo].[entCustomer]
(
	[CurrentEmail] ASC,
	[CUstomerName] ASC
)
INCLUDE([CustomerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_entCustomer_CreateDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_entCustomer_CreateDate] ON [dbo].[entCustomer]
(
	[CreateDate] ASC
)
INCLUDE([BIRowID],[CustomerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_entCustomer_CustomerID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_entCustomer_CustomerID] ON [dbo].[entCustomer]
(
	[CustomerID] ASC
)
INCLUDE([BIRowID],[MergedTo],[FirstName],[CreateDate],[UpdateDate],[Status],[CUstomerName],[CustomerRole],[Title],[MidName],[LastName],[Gender],[MaritalStatus],[DOB],[isDeceased],[CurrentAddress],[CurrentEmail],[CurrentContact]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_entCustomer_MergedTo]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_entCustomer_MergedTo] ON [dbo].[entCustomer]
(
	[MergedTo] ASC
)
INCLUDE([BIRowID],[CustomerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_name]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_name] ON [dbo].[entCustomer]
(
	[CUstomerName] ASC
)
INCLUDE([CustomerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
