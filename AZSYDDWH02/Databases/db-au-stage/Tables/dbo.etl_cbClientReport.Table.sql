USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_cbClientReport]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_cbClientReport](
	[CountryKey] [varchar](2) NOT NULL,
	[CaseKey] [varchar](17) NULL,
	[ClientReportKey] [varchar](20) NULL,
	[CaseNo] [varchar](14) NULL,
	[ClientReportID] [int] NOT NULL,
	[CreatedByID] [varchar](30) NULL,
	[CreatedBy] [varchar](51) NULL,
	[CreateDate] [date] NULL,
	[CreateTimeUTC] [datetime] NULL,
	[NoteDate] [date] NULL,
	[NoteTime] [datetime] NULL,
	[NoteTimeUTC] [datetime] NULL,
	[NoteType] [varchar](11) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[IsChaseCover] [bit] NULL,
	[IsHeader] [int] NOT NULL,
	[IsCancelled] [int] NOT NULL,
	[UrgencyID] [int] NULL,
	[Urgency] [nvarchar](100) NULL,
	[Reason] [nvarchar](1000) NULL,
	[EmailDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[EmailDetails] [nvarchar](max) NULL,
	[ApproximateDeleteDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
