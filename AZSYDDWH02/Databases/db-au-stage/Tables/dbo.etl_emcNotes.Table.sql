USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcNotes]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcNotes](
	[CountryKey] [varchar](2) NULL,
	[ApplicationKey] [varchar](15) NULL,
	[UserKey] [varchar](10) NULL,
	[NoteKey] [varchar](15) NULL,
	[ApplicationID] [int] NULL,
	[NoteID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[NoteType] [varchar](20) NULL,
	[Author] [varchar](50) NULL,
	[NoteLogin] [varchar](20) NULL
) ON [PRIMARY]
GO
