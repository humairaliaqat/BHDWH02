USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrLDAPTeam]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrLDAPTeam](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [nvarchar](320) NULL,
	[TeamLeaderID] [nvarchar](320) NULL,
	[isActive] [bit] NULL,
	[UserName] [varchar](255) NULL,
	[TeamMember] [varchar](255) NULL,
	[Email] [varchar](255) NULL,
	[TLUserName] [varchar](255) NULL,
	[TeamLeader] [varchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [idx] ON [dbo].[usrLDAPTeam]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_leader]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_leader] ON [dbo].[usrLDAPTeam]
(
	[TeamLeaderID] ASC
)
INCLUDE([UserID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_user]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_user] ON [dbo].[usrLDAPTeam]
(
	[UserID] ASC
)
INCLUDE([TeamLeaderID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[usrLDAPTeam] ADD  DEFAULT ((0)) FOR [isActive]
GO
