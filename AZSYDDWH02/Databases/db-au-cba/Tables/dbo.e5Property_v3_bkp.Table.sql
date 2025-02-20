USE [db-au-cba]
GO
/****** Object:  Table [dbo].[e5Property_v3_bkp]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5Property_v3_bkp](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [varchar](5) NULL,
	[PropertyKey] [nvarchar](40) NULL,
	[ID] [nvarchar](32) NULL,
	[PropertyLabel] [nvarchar](100) NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[DeleteBatchID] [int] NULL
) ON [PRIMARY]
GO
