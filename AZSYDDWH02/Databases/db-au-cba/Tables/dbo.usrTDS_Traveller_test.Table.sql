USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrTDS_Traveller_test]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrTDS_Traveller_test](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[policy_number] [varchar](20) NOT NULL,
	[travel_insurance_ref_id] [varchar](55) NULL,
	[traveller_id] [varchar](10) NOT NULL,
	[hashed_cif_id] [varchar](255) NULL,
	[role_code] [varchar](15) NOT NULL,
	[pre_existing] [char](1) NULL,
	[Title] [varchar](20) NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[DOB] [datetime] NULL,
	[address_line_1] [varchar](100) NULL,
	[address_line_2] [varchar](100) NULL,
	[post_code] [varchar](50) NULL,
	[Suburb] [varchar](50) NULL,
	[State] [varchar](20) NULL,
	[country] [varchar](50) NULL,
	[home_phone] [varchar](20) NULL,
	[work_phone] [varchar](20) NULL,
	[Mobilephone] [varchar](20) NULL,
	[email_address] [varchar](200) NULL,
	[opted_contact] [varchar](5) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ucidx_usrTDS_Traveller]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ucidx_usrTDS_Traveller] ON [dbo].[usrTDS_Traveller_test]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_usrTDS_Traveller_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrTDS_Traveller_BatchID] ON [dbo].[usrTDS_Traveller_test]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
