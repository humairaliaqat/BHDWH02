USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrTDS_Claim]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrTDS_Claim](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[claim_number] [varchar](20) NOT NULL,
	[travel_insurance_ref_id] [varchar](255) NULL,
	[policy_number] [varchar](20) NOT NULL,
	[claim_status_code] [varchar](10) NOT NULL,
	[incident_category] [varchar](60) NULL,
	[special_claim_category] [varchar](50) NULL,
	[incident_created_date] [datetime] NULL,
	[incident_date] [datetime] NULL,
	[incident_country] [varchar](50) NULL,
	[incident_description] [varchar](4000) NULL,
	[incident_location] [varchar](1000) NULL,
	[document_rec_date] [datetime] NULL,
	[total_incurred] [money] NULL,
	[total_outstanding] [money] NULL,
	[total_paid] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ucidx_usrTDS_Claim]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ucidx_usrTDS_Claim] ON [dbo].[usrTDS_Claim]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_usrTDS_Claim_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrTDS_Claim_BatchID] ON [dbo].[usrTDS_Claim]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
