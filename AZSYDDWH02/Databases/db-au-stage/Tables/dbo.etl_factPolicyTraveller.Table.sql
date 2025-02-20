USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_factPolicyTraveller]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_factPolicyTraveller](
	[DateSK] [int] NULL,
	[DomainSK] [int] NOT NULL,
	[TravellerSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[PolicySK] [int] NOT NULL,
	[ConsultantSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[PolicyTransactionKey] [varchar](41) NOT NULL,
	[TravellersCount] [int] NULL
) ON [PRIMARY]
GO
