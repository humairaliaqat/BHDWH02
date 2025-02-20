USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[e5Assessments]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5Assessments](
	[AssignedTo] [nvarchar](445) NULL,
	[Reference] [int] NULL,
	[ClaimNo] [varchar](50) NULL,
	[CurrentStatus] [nvarchar](100) NULL,
	[AssessmentDate] [date] NULL,
	[AssessmentTime] [time](7) NULL,
	[AssessedBy] [nvarchar](445) NULL,
	[AssessmentOutcome] [nvarchar](445) NULL
) ON [PRIMARY]
GO
