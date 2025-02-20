USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCancellationValue_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCancellationValue_aucm](
	[ID] [int] NOT NULL,
	[CancellationValueSetID] [int] NOT NULL,
	[CancellationValue] [money] NOT NULL,
	[CancellationValueText] [nvarchar](50) NOT NULL,
	[CancellationValueFamily] [money] NULL,
	[SortOrder] [int] NOT NULL
) ON [PRIMARY]
GO
