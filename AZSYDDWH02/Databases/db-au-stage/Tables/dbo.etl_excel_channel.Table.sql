USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_excel_channel]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_excel_channel](
	[ChannelID] [float] NULL,
	[Channel] [nvarchar](255) NULL
) ON [PRIMARY]
GO
