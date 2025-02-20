USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penCRMUser]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penCRMUser](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[CRMUserKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[CRMUserID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[Initial] [nvarchar](10) NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](100) NULL,
	[Status] [datetime] NULL,
	[StatusDescription] [varchar](15) NOT NULL,
	[DepartmentID] [int] NULL,
	[Department] [nvarchar](50) NULL,
	[AccessLevelID] [int] NULL,
	[AccessLevel] [nvarchar](50) NULL,
	[UserRole] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
