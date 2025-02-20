USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[live_dashboard_claims_closerate]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[live_dashboard_claims_closerate](
	[CloseDate] [date] NULL,
	[TeleFlag] [bit] NULL,
	[ClosedClaimCount] [int] NULL,
	[Closed1Week] [int] NULL,
	[Closed2Week] [int] NULL
) ON [PRIMARY]
GO
