USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbMedicalTags]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbMedicalTags](
	[CaseKey] [nvarchar](20) NOT NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[DiagnosticCategory] [nvarchar](250) NULL,
	[TagCategory] [nvarchar](200) NULL,
	[Symptom] [nvarchar](max) NULL,
	[MedicalCondition] [nvarchar](max) NULL,
	[Hospital] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
