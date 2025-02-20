USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyCOIByPost]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyCOIByPost](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[PolicyCOIByPostKey] [varchar](41) NOT NULL,
	[PolicyKey] [varchar](41) NOT NULL,
	[DomainID] [int] NOT NULL,
	[PolicyCOIByPostID] [int] NOT NULL,
	[PolicyNumber] [varchar](50) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Postcode] [varchar](50) NULL,
	[AddressLine1] [nvarchar](200) NULL,
	[AddressLine2] [nvarchar](200) NULL,
	[Suburb] [nvarchar](100) NULL,
	[State] [nvarchar](200) NULL,
	[CountryName] [nvarchar](200) NULL,
	[CountryCode] [char](3) NULL,
	[Comments] [nvarchar](max) NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyCOIByPost_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyCOIByPost_BIRowID] ON [dbo].[penPolicyCOIByPost]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyCOIByPost_PolicyCOIByPostKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyCOIByPost_PolicyCOIByPostKey] ON [dbo].[penPolicyCOIByPost]
(
	[PolicyCOIByPostKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyCOIByPost_PolicyKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyCOIByPost_PolicyKey] ON [dbo].[penPolicyCOIByPost]
(
	[PolicyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
