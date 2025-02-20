USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_tblOnlineClaimEventCauses_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_tblOnlineClaimEventCauses_au](
	[EventCauseId] [int] NOT NULL,
	[DateTimeIncident] [datetime] NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[Location] [nvarchar](200) NULL,
	[KLPER_ID] [int] NULL,
	[DetailDescription] [ntext] NULL,
	[GroupId] [int] NULL,
	[SectionSelected] [int] NULL,
	[TravelAgentLiaise] [bit] NULL,
	[TravelAgent] [nvarchar](35) NULL,
	[TravelAgentPhone] [nvarchar](35) NULL,
	[TravelAgentEmail] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_tblOnlineClaimEventCauses_au_id]    Script Date: 20/02/2025 10:25:21 AM ******/
CREATE CLUSTERED INDEX [idx_claims_tblOnlineClaimEventCauses_au_id] ON [dbo].[claims_tblOnlineClaimEventCauses_au]
(
	[EventCauseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
