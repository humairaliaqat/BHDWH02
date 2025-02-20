USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPaymentURL_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPaymentURL_aucm](
	[UrlID] [int] NOT NULL,
	[PaymentURL] [varchar](200) NOT NULL,
	[URLDescription] [varchar](50) NOT NULL,
	[PolicyDomainID] [int] NULL
) ON [PRIMARY]
GO
