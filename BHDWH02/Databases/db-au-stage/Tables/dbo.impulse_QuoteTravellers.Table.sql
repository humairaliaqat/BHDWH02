USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteTravellers]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteTravellers](
	[QuoteID] [varchar](50) NULL,
	[TravellerIdentifier] [nvarchar](4000) NULL,
	[Title] [nvarchar](4000) NULL,
	[firstName] [nvarchar](4000) NULL,
	[lastName] [nvarchar](4000) NULL,
	[memberId] [nvarchar](4000) NULL,
	[PrimaryTraveller] [nvarchar](4000) NULL,
	[age] [nvarchar](4000) NULL,
	[isPlaceholderAge] [nvarchar](4000) NULL,
	[dateOfBirth] [date] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_QuoteTravellers]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_QuoteTravellers] ON [dbo].[impulse_QuoteTravellers]
(
	[QuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
