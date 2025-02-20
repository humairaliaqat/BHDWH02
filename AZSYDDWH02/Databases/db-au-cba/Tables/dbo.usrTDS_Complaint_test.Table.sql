USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrTDS_Complaint_test]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrTDS_Complaint_test](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[complaint_number] [varchar](20) NOT NULL,
	[hashed_cif_id] [varchar](256) NULL,
	[claim_number] [varchar](20) NULL,
	[policy_number] [varchar](20) NULL,
	[complaint_register_date] [datetime] NULL,
	[complaint_completion_date] [datetime] NULL,
	[complaint_type] [varchar](20) NULL,
	[case_manager] [varchar](20) NULL,
	[complaint_reason] [varchar](50) NULL,
	[idr_referral_reason] [varchar](50) NULL,
	[idr_decision_reason] [varchar](50) NULL,
	[idr_outcome] [varchar](20) NULL,
	[fos_reference] [varchar](10) NULL,
	[policy_value] [money] NULL,
	[claim_initial_estimate] [money] NULL,
	[claim_paid] [money] NULL,
	[fos_fee] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ucidx_usrTDS_Complaint]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ucidx_usrTDS_Complaint] ON [dbo].[usrTDS_Complaint_test]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_usrTDS_Complaint_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrTDS_Complaint_BatchID] ON [dbo].[usrTDS_Complaint_test]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
