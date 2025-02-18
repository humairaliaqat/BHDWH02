USE [db-au-actuary]
GO
/****** Object:  Table [ak].[t_recoveryflag]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[t_recoveryflag](
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[ClaimNo] [int] NOT NULL,
	[SectionID] [int] NULL,
	[Benefit] [nvarchar](255) NULL,
	[IsPotentialRecovery] [bit] NULL,
	[RecoveryEstimateValue] [money] NULL,
	[RecoveredPayment] [money] NULL,
	[PaidRecoveredPayment] [money] NULL,
	[StatusDesc] [varchar](50) NULL,
	[RecoveryType] [tinyint] NULL,
	[RecoveryOutcome] [tinyint] NULL,
	[RecoveryTypeDesc] [varchar](255) NULL,
	[RecoveryOutcomeDesc] [varchar](255) NULL
) ON [PRIMARY]
GO
