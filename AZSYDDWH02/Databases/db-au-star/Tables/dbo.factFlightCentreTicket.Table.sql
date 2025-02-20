USE [db-au-star]
GO
/****** Object:  Table [dbo].[factFlightCentreTicket]    Script Date: 20/02/2025 10:26:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factFlightCentreTicket](
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[FLInternationalTicketCount] [int] NULL,
	[FLDomesticTicketCount] [int] NULL,
	[CMInternationalPolicyCount] [int] NULL,
	[CMDomesticPolicyCount] [int] NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factFlightCentreTicket_DateSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE CLUSTERED INDEX [idx_factFlightCentreTicket_DateSK] ON [dbo].[factFlightCentreTicket]
(
	[DateSK] ASC,
	[OutletSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
