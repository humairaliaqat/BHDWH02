USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penAUDIT_PolicyDetails]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penAUDIT_PolicyDetails](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[AuditPolicyDetailsKey] [varchar](71) NULL,
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_RECORDTYPE] [varchar](255) NULL,
	[Audit_DateTime] [datetime] NULL,
	[AUDIT_DATETIME_UTC] [datetime] NULL,
	[ID] [int] NOT NULL,
	[AUDIT_tblPolicyDetails_ID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[UniquePlanID] [int] NOT NULL,
	[Excess] [money] NOT NULL,
	[AreaName] [nvarchar](100) NULL,
	[PolicyStart] [datetime] NOT NULL,
	[PolicyEnd] [datetime] NOT NULL,
	[DaysCovered] [int] NULL,
	[MaxDuration] [int] NULL,
	[PlanName] [nvarchar](50) NULL,
	[PlanType] [nvarchar](50) NULL,
	[PlanID] [int] NULL,
	[TripDuration] [int] NULL,
	[EmailConsent] [bit] NULL,
	[ShowDiscount] [bit] NULL,
	[AreaCode] [nvarchar](3) NULL,
	[IsUnbundled] [bit] NULL
) ON [PRIMARY]
GO
