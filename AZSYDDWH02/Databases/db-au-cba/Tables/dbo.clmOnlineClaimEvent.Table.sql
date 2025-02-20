USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmOnlineClaimEvent]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmOnlineClaimEvent](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[ClaimKey] [varchar](40) NULL,
	[OnlineClaimKey] [varchar](40) NOT NULL,
	[ClaimNo] [int] NULL,
	[OnlineClaimID] [int] NOT NULL,
	[EventDateTime] [datetime] NULL,
	[EventCountry] [nvarchar](50) NULL,
	[EventLocation] [nvarchar](200) NULL,
	[PerilCode] [varchar](5) NULL,
	[PerilDescription] [varchar](65) NULL,
	[Detail] [nvarchar](max) NULL,
	[AdditionalDetail] [nvarchar](max) NULL,
	[IllnessPreviousOccurence] [bit] NULL,
	[IllnessOtherTraveller] [bit] NULL,
	[LossHasHCInsurance] [bit] NULL,
	[LossHCClaimable] [bit] NULL,
	[LossHCInsurer] [nvarchar](max) NULL,
	[LossConfirmInsurer] [bit] NULL,
	[LossWithTransportProvider] [bit] NULL,
	[LossConfirmProvider] [bit] NULL,
	[LossType] [varchar](max) NULL,
	[LossWithOthers] [bit] NULL,
	[LossOtherFirstName] [varchar](max) NULL,
	[LossOtherSurname] [varchar](max) NULL,
	[LossOtherTelephone] [varchar](max) NULL,
	[LossOtherEmail] [varchar](max) NULL,
	[LossAuthorityNotified] [bit] NULL,
	[LossAuthorityReference] [varchar](max) NULL,
	[LossAuthorityExplanation] [varchar](max) NULL,
	[CanxUnforseenReason] [varchar](max) NULL,
	[CanxOutOfControlReason] [varchar](max) NULL,
	[DelayPlannedDepartDate] [datetime] NULL,
	[DelayActualDepartDate] [datetime] NULL,
	[DelayDueToWeather] [bit] NULL,
	[LuggageFlightArriveDate] [datetime] NULL,
	[LuggageReceivedDate] [datetime] NULL,
	[LuggageCount] [int] NULL,
	[LuggageDelayedCount] [int] NULL,
	[LuggageReturned] [bit] NULL,
	[VehicleExcess] [money] NULL,
	[VehiclePerilType] [varchar](max) NULL,
	[VehicleOnUnsealedSurface] [bit] NULL,
	[VehicleCost] [money] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_clmOnlineClaimEvent_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmOnlineClaimEvent_BIRowID] ON [dbo].[clmOnlineClaimEvent]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimEvent_ClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimEvent_ClaimKey] ON [dbo].[clmOnlineClaimEvent]
(
	[ClaimKey] ASC
)
INCLUDE([BIRowID],[Detail],[AdditionalDetail],[EventLocation],[LossAuthorityNotified]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmOnlineClaimEvent_EventDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimEvent_EventDate] ON [dbo].[clmOnlineClaimEvent]
(
	[EventDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmOnlineClaimEvent_OnlineClaimKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmOnlineClaimEvent_OnlineClaimKey] ON [dbo].[clmOnlineClaimEvent]
(
	[OnlineClaimKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
