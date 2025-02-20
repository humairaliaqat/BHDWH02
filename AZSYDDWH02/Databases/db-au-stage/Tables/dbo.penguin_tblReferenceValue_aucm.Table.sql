USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblReferenceValue_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblReferenceValue_aucm](
	[ID] [int] NOT NULL,
	[GroupID] [int] NOT NULL,
	[Value] [nvarchar](200) NULL,
	[ParentID] [int] NULL,
	[Code] [nvarchar](50) NULL,
	[SortOrder] [numeric](18, 0) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblReferenceValue_aucm_ID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblReferenceValue_aucm_ID] ON [dbo].[penguin_tblReferenceValue_aucm]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
