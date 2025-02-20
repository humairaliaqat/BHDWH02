USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyKeyValueTypes_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyKeyValueTypes_aucm](
	[ID] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[GroupId] [int] NOT NULL,
	[Code] [varchar](100) NOT NULL,
	[Status] [varchar](15) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penguin_tblPolicyKeyValueTypes_aucm_ID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblPolicyKeyValueTypes_aucm_ID] ON [dbo].[penguin_tblPolicyKeyValueTypes_aucm]
(
	[ID] ASC,
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
