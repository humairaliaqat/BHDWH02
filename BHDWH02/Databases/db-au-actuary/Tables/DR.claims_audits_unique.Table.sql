USE [db-au-actuary]
GO
/****** Object:  Table [DR].[claims_audits_unique]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[claims_audits_unique](
	[Claimno] [varchar](50) NULL,
	[AuditFail] [int] NULL
) ON [PRIMARY]
GO
