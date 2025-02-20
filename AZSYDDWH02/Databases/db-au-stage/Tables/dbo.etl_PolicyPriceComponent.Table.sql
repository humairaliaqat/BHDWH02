USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_PolicyPriceComponent]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_PolicyPriceComponent](
	[CountrySet] [varchar](2) NOT NULL,
	[Company] [varchar](2) NOT NULL,
	[GroupID] [int] NOT NULL,
	[ComponentID] [int] NOT NULL,
	[DomainId] [int] NOT NULL,
	[PolicyTransactionID] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[etl_PolicyPriceComponent]
(
	[GroupID] ASC,
	[ComponentID] ASC,
	[CountrySet] ASC,
	[Company] ASC
)
INCLUDE([DomainId],[PolicyTransactionID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
