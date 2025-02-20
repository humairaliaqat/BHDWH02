USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOTP_Product_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOTP_Product_aucm](
	[ID] [int] NOT NULL,
	[OTPId] [int] NOT NULL,
	[PurchasePathTypeID] [int] NOT NULL,
	[ProductCode] [varchar](50) NOT NULL,
	[DeclarationSetID] [int] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[IsCancellation] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOTP_Product_aucm_OTPId]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblOTP_Product_aucm_OTPId] ON [dbo].[penguin_tblOTP_Product_aucm]
(
	[OTPId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
