USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblFinanceGroup_ServiceFees_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblFinanceGroup_ServiceFees_aucm](
	[GroupID] [int] NULL,
	[ServiceTypeID] [int] NULL,
	[FEE] [money] NULL
) ON [PRIMARY]
GO
