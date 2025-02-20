USE [db-au-cba]
GO
/****** Object:  Table [dbo].[verOrganisation]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[verOrganisation](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[OrganisationKey] [int] NOT NULL,
	[OrganisationName] [nvarchar](255) NOT NULL,
	[OrganisationDescription] [nvarchar](255) NOT NULL,
	[Timezone] [nvarchar](50) NOT NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
