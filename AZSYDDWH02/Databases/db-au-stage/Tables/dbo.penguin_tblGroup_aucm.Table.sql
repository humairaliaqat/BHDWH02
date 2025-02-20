USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblGroup_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblGroup_aucm](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[Street] [nvarchar](100) NULL,
	[Suburb] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[PostCode] [nvarchar](10) NULL,
	[MailSuburb] [nvarchar](50) NULL,
	[MailState] [nvarchar](100) NULL,
	[MailPostCode] [nvarchar](10) NULL,
	[DomainId] [int] NOT NULL,
	[POBox] [nvarchar](50) NULL,
	[EmcCompanyId] [int] NOT NULL,
	[LoginMethod] [nvarchar](15) NOT NULL,
	[IsSuperUser] [bit] NULL,
	[ConsultantAccessLevelGroupID] [int] NULL,
	[CompanyId] [tinyint] NULL,
	[PaymentProcessType] [varchar](15) NULL,
	[isDefault] [bit] NULL,
	[DistributorId] [int] NULL,
	[CoolingOffPeriod] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblGroup_aucm_ID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblGroup_aucm_ID] ON [dbo].[penguin_tblGroup_aucm]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
