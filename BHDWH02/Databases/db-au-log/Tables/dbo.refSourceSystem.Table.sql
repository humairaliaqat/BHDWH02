USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[refSourceSystem]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[refSourceSystem](
	[srcID] [int] IDENTITY(0,1) NOT NULL,
	[srcCountry] [nvarchar](50) NULL,
	[srcDBName] [nvarchar](50) NULL,
	[isTrustEnabled] [bit] NULL,
	[srcUserName] [nvarchar](50) NULL,
	[srcPassword] [nvarchar](50) NULL,
	[isEnabled] [bit] NULL
) ON [PRIMARY]
GO
