USE [db-au-cba]
GO
/****** Object:  Table [dbo].[emcMedicalGroup]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emcMedicalGroup](
	[CountryKey] [varchar](2) NOT NULL,
	[ApplicationKey] [varchar](15) NOT NULL,
	[ApplicationID] [int] NOT NULL,
	[GroupID] [int] NULL,
	[GroupStatus] [varchar](20) NULL,
	[GroupScore] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcMedicalGroup_ApplicationKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_emcMedicalGroup_ApplicationKey] ON [dbo].[emcMedicalGroup]
(
	[ApplicationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_emcMedicalGroup_ApplicationID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcMedicalGroup_ApplicationID] ON [dbo].[emcMedicalGroup]
(
	[ApplicationID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_emcMedicalGroup_GroupID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_emcMedicalGroup_GroupID] ON [dbo].[emcMedicalGroup]
(
	[GroupID] ASC
)
INCLUDE([ApplicationID],[ApplicationKey],[CountryKey],[GroupStatus],[GroupScore]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
