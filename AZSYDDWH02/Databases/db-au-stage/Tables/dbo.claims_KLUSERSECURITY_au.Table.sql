USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLUSERSECURITY_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLUSERSECURITY_au](
	[ID] [int] NOT NULL,
	[KLUSERID] [int] NOT NULL,
	[KLSECURITYLEVEL] [int] NULL,
	[KLSIGNLEVEL1] [nvarchar](50) NULL,
	[KLSIGNLEVEL2] [nvarchar](50) NULL,
	[KLSIGNLEVEL3] [nvarchar](50) NULL
) ON [PRIMARY]
GO
