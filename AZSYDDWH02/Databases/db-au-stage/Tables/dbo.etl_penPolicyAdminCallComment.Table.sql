USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyAdminCallComment]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyAdminCallComment](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[CallCommentKey] [varchar](71) NULL,
	[PolicyKey] [varchar](71) NULL,
	[CRMUserKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[CallCommentID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[PolicyNumber] [varchar](25) NULL,
	[CRMUserID] [int] NOT NULL,
	[CallDate] [datetime] NULL,
	[CallDateUTC] [datetime] NOT NULL,
	[CallReason] [nvarchar](50) NULL,
	[CallComment] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
