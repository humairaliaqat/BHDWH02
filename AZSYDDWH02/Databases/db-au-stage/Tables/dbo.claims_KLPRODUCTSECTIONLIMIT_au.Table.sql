USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPRODUCTSECTIONLIMIT_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPRODUCTSECTIONLIMIT_au](
	[KE_ID] [int] NOT NULL,
	[KESection_ID] [int] NOT NULL,
	[KELimit_ID] [int] NOT NULL
) ON [PRIMARY]
GO
