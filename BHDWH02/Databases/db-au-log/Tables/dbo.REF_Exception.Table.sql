USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[REF_Exception]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REF_Exception](
	[REF_ExceptionID] [int] NULL,
	[Entity] [varchar](50) NULL,
	[KeyAttributes] [varchar](255) NULL,
	[ExceptionDesc] [varchar](255) NULL,
	[DistributedEmail] [varchar](255) NULL,
	[isValid] [char](1) NULL
) ON [PRIMARY]
GO
