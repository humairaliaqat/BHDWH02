USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[tbl_recon_analytics1]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_recon_analytics1](
	[Date] [date] NULL,
	[Partner] [varchar](max) NULL,
	[UpperThreshold] [float] NULL,
	[LowerThreshold] [float] NULL,
	[IncomingDataCount] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
