USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLEVENT_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLEVENT_au](
	[KE_ID] [int] NOT NULL,
	[KECLAIM] [int] NULL,
	[KEEMC_ID] [int] NULL,
	[KEPERIL] [varchar](3) NULL,
	[KECOUNTRY] [varchar](3) NULL,
	[KEDLOSS] [datetime] NULL,
	[KEDESC] [nvarchar](100) NULL,
	[KEDCREATED] [datetime] NULL,
	[KECREATEDBY_ID] [int] NULL,
	[KECASE_ID] [varchar](15) NULL,
	[KECATASTROPHE] [varchar](3) NULL,
	[KMOTORCYCLING] [bit] NULL,
	[KSKIINGSNOWBOARDING] [bit] NULL
) ON [PRIMARY]
GO
