USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLINVOICES_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLINVOICES_au](
	[KV_ID] [int] NOT NULL,
	[KVPROV_ID] [int] NULL,
	[KVCLAIM_ID] [int] NULL,
	[KVINVOICE] [nvarchar](50) NULL,
	[KVTOTAL] [money] NULL,
	[KVBATCH] [int] NULL,
	[KVINVDATE] [datetime] NULL,
	[KVCURR] [varchar](3) NULL,
	[KVDFTPAYEE_ID] [int] NULL,
	[KVGST] [money] NULL,
	[KVEVENT_ID] [int] NULL
) ON [PRIMARY]
GO
