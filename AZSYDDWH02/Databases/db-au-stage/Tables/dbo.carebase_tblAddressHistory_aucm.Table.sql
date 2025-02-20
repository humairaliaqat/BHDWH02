USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblAddressHistory_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblAddressHistory_aucm](
	[HistoryID] [int] NOT NULL,
	[ModifiedBy] [varchar](30) NULL,
	[AddressID] [int] NULL,
	[ArrivedDate] [datetime] NULL,
	[AddedDate] [datetime] NULL,
	[CaseNo] [varchar](30) NULL
) ON [PRIMARY]
GO
