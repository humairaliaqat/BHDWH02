USE [db-au-cba]
GO
/****** Object:  Table [dbo].[glJointVentures]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[glJointVentures](
	[BIRowID] [bigint] NOT NULL,
	[JVCode] [varchar](50) NOT NULL,
	[JVDescription] [nvarchar](255) NULL,
	[TypeOfJVCode] [varchar](50) NULL,
	[TypeOfJVDescription] [nvarchar](200) NULL,
	[DistributionTypeCode] [varchar](50) NULL,
	[DistributionTypeDescription] [nvarchar](200) NULL,
	[SuperGroupCode] [varchar](50) NULL,
	[SuperGroupDescription] [nvarchar](200) NULL,
	[CreateBatchID] [int] NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateBatchID] [int] NULL,
	[UpdateDateTime] [datetime] NULL,
	[DeleteDateTime] [datetime] NULL
) ON [PRIMARY]
GO
