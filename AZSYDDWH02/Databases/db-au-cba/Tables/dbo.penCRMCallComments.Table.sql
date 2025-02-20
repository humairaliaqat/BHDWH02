USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penCRMCallComments]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penCRMCallComments](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](3) NOT NULL,
	[CRMCallKey] [varchar](41) NULL,
	[OutletKey] [varchar](30) NULL,
	[UserKey] [varchar](41) NULL,
	[CRMUserKey] [varchar](41) NULL,
	[CRMCallID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[CRMUserID] [int] NOT NULL,
	[AlphaCode] [nvarchar](20) NOT NULL,
	[UserID] [int] NULL,
	[Category] [nvarchar](50) NULL,
	[SubCategory] [nvarchar](50) NULL,
	[Duration] [int] NULL,
	[CallDate] [datetime] NOT NULL,
	[ActualCallDate] [datetime] NOT NULL,
	[CallComments] [nvarchar](max) NULL,
	[isXora] [bit] NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[CallDateUTC] [datetime] NULL,
	[ActualCallDateUTC] [datetime] NULL,
	[AgencyCallID] [varchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_penCRMCallComments_CallDate]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penCRMCallComments_CallDate] ON [dbo].[penCRMCallComments]
(
	[CallDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_ActualCallDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_ActualCallDate] ON [dbo].[penCRMCallComments]
(
	[ActualCallDate] ASC,
	[CRMUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_Category]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_Category] ON [dbo].[penCRMCallComments]
(
	[Category] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_CountryKey] ON [dbo].[penCRMCallComments]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_CRMCallKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_CRMCallKey] ON [dbo].[penCRMCallComments]
(
	[CRMCallKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_CRMUserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_CRMUserKey] ON [dbo].[penCRMCallComments]
(
	[CRMUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_OutletKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_OutletKey] ON [dbo].[penCRMCallComments]
(
	[OutletKey] ASC,
	[Category] ASC
)
INCLUDE([CallDate],[CallComments]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_SubCategory]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_SubCategory] ON [dbo].[penCRMCallComments]
(
	[SubCategory] ASC,
	[CountryKey] ASC,
	[CompanyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMCallComments_UserKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMCallComments_UserKey] ON [dbo].[penCRMCallComments]
(
	[UserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
