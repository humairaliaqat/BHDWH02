USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyCOIByPost_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyCOIByPost_aucm](
	[ID] [int] NOT NULL,
	[POLICYNUMBER] [varchar](25) NOT NULL,
	[CREATEDATETIME] [datetime] NOT NULL,
	[UPDATEDATETIME] [datetime] NOT NULL,
	[POSTCODE] [varchar](50) NULL,
	[ADDRESSLINE1] [nvarchar](200) NULL,
	[ADDRESSLINE2] [nvarchar](200) NULL,
	[SUBURB] [nvarchar](100) NULL,
	[STATE] [nvarchar](200) NULL,
	[COUNTRYNAME] [nvarchar](200) NULL,
	[COUNTRYCODE] [char](3) NULL,
	[COMMENTS] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
