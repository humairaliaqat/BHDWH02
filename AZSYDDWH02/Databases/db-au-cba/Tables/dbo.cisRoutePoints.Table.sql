USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cisRoutePoints]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cisRoutePoints](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[RoutePoint] [nvarchar](30) NULL,
	[InternalName] [nvarchar](100) NULL,
	[GroupName] [nvarchar](100) NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
