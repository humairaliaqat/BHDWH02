USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[impulse_QuotePromo]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuotePromo](
	[QuoteID] [varchar](50) NULL,
	[PromoOrder] [nvarchar](4000) NOT NULL,
	[PromoCode] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
