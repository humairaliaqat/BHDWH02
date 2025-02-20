USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuotePolicies]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuotePolicies](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[PolicyOrder] [int] NULL,
	[PolicyID] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
