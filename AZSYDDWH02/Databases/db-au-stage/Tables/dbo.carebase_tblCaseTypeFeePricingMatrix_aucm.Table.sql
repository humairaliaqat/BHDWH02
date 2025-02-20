USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblCaseTypeFeePricingMatrix_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblCaseTypeFeePricingMatrix_aucm](
	[ID] [int] NOT NULL,
	[POL_POLICY_ID] [int] NULL,
	[ChannelId] [int] NULL,
	[UCT_CASE_TYPE_ID] [int] NULL,
	[ProtocolCode] [int] NULL,
	[Fee] [money] NULL,
	[Tax] [money] NULL
) ON [PRIMARY]
GO
