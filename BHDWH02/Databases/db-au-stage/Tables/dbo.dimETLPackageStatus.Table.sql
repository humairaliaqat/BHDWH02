USE [db-au-stage]
GO
/****** Object:  Table [dbo].[dimETLPackageStatus]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimETLPackageStatus](
	[PackageID] [int] NOT NULL,
	[PackageSubGroupID] [int] NOT NULL,
	[PackageName] [nvarchar](250) NULL,
	[PackageSubGroupName] [nvarchar](250) NULL,
	[PackageLoadType] [nvarchar](1) NULL,
	[PackageForceLoad] [nvarchar](1) NULL,
	[DeltaLoadStartDate] [datetime] NULL,
	[DeltaLoadToDate] [datetime] NULL,
	[LastRunStartDate] [datetime] NULL,
	[LastRunEndDate] [datetime] NULL,
	[LastRunStatus] [nvarchar](20) NULL,
	[LastRunDescription] [nvarchar](2000) NULL,
	[CurrentRunStartDate] [datetime] NULL,
	[CurrentRunEndDate] [datetime] NULL,
	[CurrentRunStatus] [nvarchar](20) NULL,
	[CurrentRunDescription] [nvarchar](2000) NULL
) ON [PRIMARY]
GO
