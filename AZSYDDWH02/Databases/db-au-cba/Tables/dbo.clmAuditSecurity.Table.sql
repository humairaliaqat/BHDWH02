USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmAuditSecurity]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmAuditSecurity](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[AuditKey] [varchar](50) NOT NULL,
	[AuditUserName] [nvarchar](150) NULL,
	[AuditDateTime] [datetime] NOT NULL,
	[AuditAction] [char](1) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[SecurityKey] [varchar](40) NOT NULL,
	[SecurityID] [int] NOT NULL,
	[Limits] [money] NULL,
	[EstimateLimits] [money] NULL,
	[Initials] [nvarchar](50) NULL,
	[Name] [nvarchar](150) NULL,
	[Login] [nvarchar](50) NULL,
	[LevelDesc] [nvarchar](500) NULL,
	[isActive] [bit] NULL,
	[AuditDateTimeUTC] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmAuditSecurity_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmAuditSecurity_BIRowID] ON [dbo].[clmAuditSecurity]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAuditSecurity_AuditKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditSecurity_AuditKey] ON [dbo].[clmAuditSecurity]
(
	[AuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmAuditSecurity_SecurityKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmAuditSecurity_SecurityKey] ON [dbo].[clmAuditSecurity]
(
	[SecurityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
