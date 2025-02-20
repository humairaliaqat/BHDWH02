USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuotePromo]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuotePromo](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[PromoOrder] [int] NULL,
	[PromoCode] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
