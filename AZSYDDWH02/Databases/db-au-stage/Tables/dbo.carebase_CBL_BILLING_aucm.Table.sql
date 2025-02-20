USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_CBL_BILLING_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_CBL_BILLING_aucm](
	[CASE_NO] [varchar](14) NULL,
	[OPEN_DATE] [datetime] NULL,
	[ITEM] [varchar](20) NULL,
	[PROVIDERNO] [varchar](8) NULL,
	[PROVIDER] [nvarchar](200) NULL,
	[LOG_NAME] [varchar](20) NULL,
	[LOG_SENT] [datetime] NULL,
	[LOG_CODE] [varchar](5) NULL,
	[INIT_AC] [varchar](30) NULL,
	[CURRENCY] [varchar](3) NULL,
	[LOCAL_EST] [money] NULL,
	[AUD_EST] [money] NULL,
	[LOCAL_ACT] [money] NULL,
	[AUD_ACT] [money] NULL,
	[LOCAL_REV] [money] NULL,
	[AUD_REV] [money] NULL,
	[EXCHANGE] [money] NULL,
	[NET_SAVING] [money] NULL,
	[PROV_DATE] [date] NULL,
	[PROV_SAC] [varchar](8) NULL,
	[AUTH_DATE] [date] NULL,
	[AUTH_SAC] [varchar](30) NULL,
	[DEP_AUD] [money] NULL,
	[DEP_DATE] [date] NULL,
	[PRE_AUD] [money] NULL,
	[PRE_DATE] [date] NULL,
	[PFP_DATE] [date] NULL,
	[BILL_DATE] [datetime] NULL,
	[CLAIMS_NO] [varchar](6) NULL,
	[POL_EXCESS] [float] NULL,
	[INC_CR] [varchar](1) NULL,
	[CCTYPE] [varchar](2) NULL,
	[CCNUMBER] [varchar](20) NULL,
	[CCAMEXID] [varchar](4) NULL,
	[CCNAME] [varchar](30) NULL,
	[CCEXPIRY] [varchar](5) NULL,
	[CCAPPROVAL] [varchar](25) NULL,
	[ACCAUTHDATE] [date] NULL,
	[ACCAUTHBY] [varchar](30) NULL,
	[PREPAIDA24] [float] NULL,
	[SENTTOCLIENT] [datetime] NULL,
	[CCINOUT] [int] NULL,
	[PPO_FEE] [money] NULL,
	[PPO_NETWORK] [char](25) NULL,
	[ROWID] [int] NOT NULL,
	[NOTES] [nvarchar](1500) NULL,
	[INVOICE_NO] [nvarchar](50) NULL,
	[ISIMPORTED] [bit] NULL,
	[BACK_FRONT_END] [nvarchar](50) NULL,
	[CUST_PAYMENT] [money] NULL,
	[CLIENT_PAYMENT] [money] NULL,
	[CCA_CCFEE] [money] NULL,
	[BillingType_ID] [int] NULL,
	[Address_ID] [int] NULL,
	[PaymentBy_ID] [int] NULL,
	[AUD_GST] [money] NULL,
	[ISDELETED] [bit] NULL,
	[BillingItem_ID] [numeric](3, 0) NULL
) ON [PRIMARY]
GO
