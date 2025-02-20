USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyImport_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyImport_aucm](
	[ID] [int] NOT NULL,
	[DataImportID] [int] NOT NULL,
	[PolicyXML] [xml] NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[PolicyStatus] [varchar](15) NULL,
	[PolicyID] [int] NULL,
	[RowID] [int] NOT NULL,
	[PolicyNumber] [varchar](25) NULL,
	[ParentID] [int] NULL,
	[BusinessUnit] [nvarchar](50) NULL,
	[UnAdjustedTotal] [money] NULL,
	[AdjustedTotal] [money] NULL,
	[PenguinUnAdjustedTotal] [money] NULL,
	[Comment] [nvarchar](1000) NULL,
	[Agent] [nvarchar](2000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
