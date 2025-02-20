USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penUserAudit]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penUserAudit](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[UserAuditKey] [varchar](71) NULL,
	[UserKey] [varchar](71) NULL,
	[OutletKey] [varchar](71) NULL,
	[DomainID] [int] NULL,
	[UserAuditId] [int] NOT NULL,
	[AuditDateTime] [datetime] NULL,
	[AuditDateTimeUTC] [datetime] NULL,
	[UserID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Login] [nvarchar](100) NULL,
	[Password] [int] NULL,
	[Initial] [nvarchar](50) NOT NULL,
	[ASICNumber] [varchar](50) NULL,
	[AgreementDate] [datetime] NULL,
	[AccessLevel] [int] NOT NULL,
	[AccessLevelName] [nvarchar](50) NULL,
	[AccreditationNumber] [varchar](50) NULL,
	[AllowAdjustPricing] [bit] NULL,
	[Status] [varchar](8) NOT NULL,
	[InactiveDate] [datetime] NULL,
	[AgentCode] [nvarchar](50) NULL,
	[DateOfBirth] [datetime] NULL,
	[ASICCheck] [nvarchar](50) NULL,
	[Email] [nvarchar](200) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[MustChangePassword] [bit] NOT NULL,
	[AccountLocked] [bit] NOT NULL,
	[LoginFailedTimes] [int] NOT NULL,
	[IsSuperUser] [bit] NOT NULL,
	[LastUpdateUserId] [int] NULL,
	[LastUpdateCrmUserId] [int] NULL,
	[LastLoggedIn] [datetime] NULL,
	[LastLoggedInUTC] [datetime] NULL
) ON [PRIMARY]
GO
