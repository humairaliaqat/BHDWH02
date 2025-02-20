USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPRODUCTSECTIONS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPRODUCTSECTIONS_au](
	[KS_ID] [int] NOT NULL,
	[KSProduct_ID] [int] NULL,
	[KSSectCode] [varchar](5) NULL,
	[KSDescription] [varchar](200) NULL,
	[KSDisplayOrder] [int] NULL
) ON [PRIMARY]
GO
