USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPaymentCCMerchant_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPaymentCCMerchant_aucm](
	[PaymentMerchantAcctId] [int] NOT NULL,
	[DomainID] [int] NOT NULL,
	[AuthorisationCode] [varchar](50) NULL,
	[ClientID] [nvarchar](15) NOT NULL,
	[PaymentMerchantAcctName] [nvarchar](50) NOT NULL,
	[PaymentGatewayID] [varchar](50) NULL,
	[PaymentModeId] [int] NOT NULL,
	[IsSmartSpeakMerchant] [int] NULL
) ON [PRIMARY]
GO
