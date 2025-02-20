USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimConsultant]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimConsultant](
	[ConsultantSK] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](10) NOT NULL,
	[ConsultantKey] [nvarchar](50) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NOT NULL,
	[Firstname] [nvarchar](50) NULL,
	[Lastname] [nvarchar](50) NULL,
	[ConsultantName] [nvarchar](100) NULL,
	[UserName] [nvarchar](100) NULL,
	[ASICNumber] [int] NULL,
	[AgreementDate] [datetime] NULL,
	[Status] [nvarchar](20) NULL,
	[InactiveDate] [datetime] NULL,
	[RefereeName] [nvarchar](255) NULL,
	[AccreditationDate] [datetime] NULL,
	[DeclaredDate] [datetime] NULL,
	[PreviouslyKnownAs] [nvarchar](100) NULL,
	[YearsOfExperience] [nvarchar](15) NULL,
	[DateOfBirth] [datetime] NULL,
	[ASICCheck] [nvarchar](50) NULL,
	[Email] [nvarchar](200) NULL,
	[FirstSellDate] [datetime] NULL,
	[LastSellDate] [datetime] NULL,
	[ConsultantType] [nvarchar](50) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimConsultant_ConsultantSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_dimConsultant_ConsultantSK] ON [dbo].[dimConsultant]
(
	[ConsultantSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimConsultant_ConsultantKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimConsultant_ConsultantKey] ON [dbo].[dimConsultant]
(
	[ConsultantKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimConsultant_ConsultantName]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimConsultant_ConsultantName] ON [dbo].[dimConsultant]
(
	[ConsultantName] ASC,
	[OutletAlphaKey] ASC
)
INCLUDE([ConsultantSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimConsultant_Country]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimConsultant_Country] ON [dbo].[dimConsultant]
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimConsultant_InactiveDate]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimConsultant_InactiveDate] ON [dbo].[dimConsultant]
(
	[InactiveDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimConsultant_Status]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimConsultant_Status] ON [dbo].[dimConsultant]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
