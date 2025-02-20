USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrTDS_Quote]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrTDS_Quote](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[quote_reference] [varchar](50) NOT NULL,
	[quote_date] [datetime] NOT NULL,
	[travel_insurance_ref_id] [varchar](50) NULL,
	[hashed_cif_id] [varchar](256) NULL,
	[type_code] [varchar](10) NOT NULL,
	[initiating_channel_code] [varchar](10) NULL,
	[csr_reference] [varchar](50) NULL,
	[travel_departure_date] [datetime] NOT NULL,
	[travel_return_date] [datetime] NOT NULL,
	[travel_countries] [varchar](200) NOT NULL,
	[promo_code] [varchar](50) NULL,
	[excess] [money] NULL,
	[trip_cost] [money] NULL,
	[total_premium] [money] NULL,
	[base_premium] [money] NULL,
	[medical_premium] [money] NULL,
	[emc_premium] [money] NULL,
	[cruise_premium] [money] NULL,
	[luggage_premium] [money] NULL,
	[winter_sport_premium] [money] NULL,
	[business_premium] [money] NULL,
	[age_cover_premium] [money] NULL,
	[rental_car_premium] [money] NULL,
	[motorcycle_premium] [money] NULL,
	[other_packs_premium] [money] NULL,
	[discount] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [ucidx_usrTDS_Quote]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE UNIQUE CLUSTERED INDEX [ucidx_usrTDS_Quote] ON [dbo].[usrTDS_Quote]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_usrTDS_Quote_BatchID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrTDS_Quote_BatchID] ON [dbo].[usrTDS_Quote]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
