USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcHealix]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcHealix](
	[SessionID] [varchar](max) NULL,
	[AssessmentDatePosixTimestamp] [bigint] NULL,
	[AssessmentDateUTC] [datetime] NULL,
	[AssessmentDateAusLocalTime] [datetime] NULL,
	[DOB] [datetime] NULL,
	[FirstName] [varchar](max) NULL,
	[LastName] [varchar](max) NULL,
	[impulse_response] [varchar](max) NULL,
	[verisk_response] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
