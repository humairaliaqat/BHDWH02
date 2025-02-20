USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblIndicentTypeFeePricingMatrix_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblIndicentTypeFeePricingMatrix_aucm](
	[ID] [int] NOT NULL,
	[NIT_INCIDENTTYPE_ID] [int] NULL,
	[ChannelId] [int] NULL,
	[Fee] [nvarchar](50) NULL,
	[Tax] [nvarchar](50) NULL
) ON [PRIMARY]
GO
