USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penCRMUser]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penCRMUser](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[CRMUserKey] [varchar](41) NOT NULL,
	[CRMUserID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Initial] [nvarchar](10) NULL,
	[UserName] [nvarchar](100) NULL,
	[Status] [datetime] NULL,
	[DepartmentID] [int] NULL,
	[Department] [nvarchar](50) NULL,
	[AccessLevelID] [int] NULL,
	[AccessLevel] [nvarchar](50) NULL,
	[UserRole] [nvarchar](512) NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[StatusDescription] [varchar](15) NULL,
	[PhoneNumber] [nvarchar](100) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMUser_CRMUserKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penCRMUser_CRMUserKey] ON [dbo].[penCRMUser]
(
	[CRMUserKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMUser_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMUser_CountryKey] ON [dbo].[penCRMUser]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penCRMUser_CRMUserID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMUser_CRMUserID] ON [dbo].[penCRMUser]
(
	[CRMUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penCRMUser_StatusDescription]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penCRMUser_StatusDescription] ON [dbo].[penCRMUser]
(
	[StatusDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
