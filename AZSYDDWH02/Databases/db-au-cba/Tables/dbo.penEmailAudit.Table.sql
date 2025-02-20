USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penEmailAudit]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penEmailAudit](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[EmailAuditKey] [varchar](41) NOT NULL,
	[EmailAuditID] [bigint] NOT NULL,
	[SentDate] [datetime] NULL,
	[Sender] [varchar](50) NULL,
	[Status] [bit] NULL,
	[Recipients] [varchar](200) NULL,
	[AuditReference] [varchar](20) NULL,
	[AuditReferenceTypeID] [int] NULL,
	[Subject] [nvarchar](200) NULL,
	[Body] [nvarchar](max) NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[ExtraData] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penEmailAudit_CompanyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penEmailAudit_CompanyKey] ON [dbo].[penEmailAudit]
(
	[CompanyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penEmailAudit_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penEmailAudit_CountryKey] ON [dbo].[penEmailAudit]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penEmailAudit_EmailAuditKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penEmailAudit_EmailAuditKey] ON [dbo].[penEmailAudit]
(
	[EmailAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penEmailAudit_SentDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penEmailAudit_SentDate] ON [dbo].[penEmailAudit]
(
	[SentDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
