USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrTDS_Incurred_test]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrTDS_Incurred_test](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[claim_number] [varchar](20) NOT NULL,
	[incurred_date] [datetime] NULL,
	[cost_type] [varchar](20) NULL,
	[paid_date] [datetime] NULL,
	[outstanding_movement] [money] NULL,
	[payment_movement] [money] NULL,
	[incurred_movement] [money] NULL,
	[outstanding_end_of_day] [money] NULL,
	[payment_end_of_day] [money] NULL,
	[incurred_end_of_day] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ucidx_usrTDS_Incurred]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ucidx_usrTDS_Incurred] ON [dbo].[usrTDS_Incurred_test]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_usrTDS_Incurred_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrTDS_Incurred_BatchID] ON [dbo].[usrTDS_Incurred_test]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
