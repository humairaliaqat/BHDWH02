USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpTravellers]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpTravellers](
	[CountryKey] [varchar](2) NOT NULL,
	[TravellerKey] [varchar](41) NULL,
	[RegistrationKey] [varchar](41) NULL,
	[TravellerID] [int] NULL,
	[RegistrationID] [int] NULL,
	[Title] [varchar](10) NULL,
	[FirstName] [varchar](200) NULL,
	[Surname] [varchar](200) NULL,
	[DOB] [datetime] NULL,
	[Age] [int] NULL,
	[isPrimary] [bit] NULL,
	[isAdult] [bit] NULL,
	[EMCID] [int] NULL,
	[EMCIssuedDate] [datetime] NULL,
	[EMCAssessmentNo] [varchar](50) NULL,
	[EMCLoad] [money] NULL,
	[EMCAccept] [bit] NULL,
	[ClosingID] [int] NULL,
	[ClosingIssuedDate] [datetime] NULL,
	[ClosingLoad] [money] NULL,
	[ClosingAccept] [bit] NULL,
	[ClosingExtraDays] [int] NULL,
	[FreeDaysID] [int] NULL,
	[FreeDays] [int] NULL,
	[FreeDaysLoad] [money] NULL,
	[FreeDaysIssuedDate] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpTravellers_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpTravellers_CountryKey] ON [dbo].[corpTravellers]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpTravellers_RegistrationKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpTravellers_RegistrationKey] ON [dbo].[corpTravellers]
(
	[RegistrationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpTravellers_TravellerKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpTravellers_TravellerKey] ON [dbo].[corpTravellers]
(
	[TravellerKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
