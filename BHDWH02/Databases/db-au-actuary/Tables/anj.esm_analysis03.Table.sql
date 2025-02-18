USE [db-au-actuary]
GO
/****** Object:  Table [anj].[esm_analysis03]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [anj].[esm_analysis03](
	[work_id] [varchar](50) NULL,
	[claimnumber] [int] NULL,
	[policynumber] [varchar](50) NULL,
	[first_completion_date] [datetime] NULL,
	[First_complete_2019] [int] NOT NULL,
	[First_complete_2023] [int] NOT NULL,
	[reopen_date] [datetime] NULL,
	[reopened_2019] [int] NULL,
	[reopened_2023] [int] NULL,
	[esm_anyway] [int] NULL,
	[esm_leak] [int] NULL,
	[esm_date] [date] NULL,
	[esm_list] [int] NULL
) ON [PRIMARY]
GO
