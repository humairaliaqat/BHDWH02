USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPROVIDERS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPROVIDERS_au](
	[KPROV_ID] [int] NOT NULL,
	[KPROVTYPE] [varchar](25) NULL,
	[KPROVNAME] [nvarchar](100) NULL,
	[KPROVSURNAME] [nvarchar](100) NULL,
	[KPPROVFIRST] [nvarchar](100) NULL,
	[KPSTREET] [nvarchar](100) NULL,
	[KPSUBURB] [nvarchar](50) NULL,
	[KPSTATE] [nvarchar](100) NULL,
	[KPPCODE] [nvarchar](50) NULL,
	[KPCOUNTRY] [nvarchar](100) NULL,
	[KPPHONE] [nvarchar](50) NULL,
	[KPFAX] [varchar](50) NULL,
	[KPEMAIL] [nvarchar](255) NULL,
	[KPFOREIGN] [bit] NOT NULL,
	[KPACCT] [varchar](25) NULL,
	[KPACCTNAME] [nvarchar](100) NULL,
	[KPBSB] [varchar](15) NULL,
	[KPEMAILOK] [bit] NULL,
	[KPTHIRDPARTY] [varchar](10) NULL,
	[KPGST] [bit] NULL,
	[KPGSTPERC] [float] NULL,
	[KPGOODSSUPPLIER] [bit] NULL,
	[KPSERVPROV] [bit] NULL,
	[KPSUPPLYBY] [int] NULL,
	[KPPAYMENTMETHODID] [int] NULL,
	[KPEncryptACCT] [varbinary](256) NULL,
	[KPEncryptBSB] [varbinary](256) NULL,
	[KLDOMAINID] [int] NOT NULL,
	[KPBANKNAME] [nvarchar](50) NULL
) ON [PRIMARY]
GO
