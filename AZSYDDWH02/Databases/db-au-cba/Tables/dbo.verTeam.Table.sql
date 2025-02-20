USE [db-au-cba]
GO
/****** Object:  Table [dbo].[verTeam]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[verTeam](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NULL,
	[EmployeeKey] [int] NULL,
	[OrganisationKey] [int] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
