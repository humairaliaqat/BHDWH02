USE [db-au-cba]
GO
/****** Object:  Table [dbo].[e5Work_v3]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5Work_v3](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Domain] [varchar](5) NULL,
	[Country] [varchar](5) NULL,
	[Work_ID] [varchar](50) NULL,
	[Original_Work_ID] [uniqueidentifier] NOT NULL,
	[Parent_ID] [varchar](50) NULL,
	[Original_Parent_ID] [uniqueidentifier] NULL,
	[OriginWork_ID] [uniqueidentifier] NULL,
	[Reference] [int] NULL,
	[ClaimKey] [varchar](40) NULL,
	[AgencyCode] [nvarchar](20) NULL,
	[ClaimNumber] [int] NULL,
	[PolicyNumber] [varchar](50) NULL,
	[OnlineClaim] [bit] NULL,
	[ClaimType] [nvarchar](255) NULL,
	[ClaimDescription] [nvarchar](255) NULL,
	[SectionCheckList] [nvarchar](512) NULL,
	[ClaimantTitle] [nvarchar](50) NULL,
	[ClaimantFirstName] [nvarchar](100) NULL,
	[ClaimantSurname] [nvarchar](100) NULL,
	[WorkClassName] [nvarchar](100) NULL,
	[BusinessName] [nvarchar](100) NULL,
	[WorkType] [nvarchar](100) NULL,
	[GroupType] [nvarchar](100) NULL,
	[StatusName] [nvarchar](100) NULL,
	[AssignedDate] [datetime] NULL,
	[AssignedUserID] [nvarchar](100) NULL,
	[AssignedUser] [nvarchar](445) NULL,
	[CreationDate] [datetime] NOT NULL,
	[CreationUserID] [nvarchar](100) NULL,
	[CreationUser] [nvarchar](445) NULL,
	[CompletionDate] [datetime] NULL,
	[CompletionUserID] [nvarchar](100) NULL,
	[CompletionUser] [nvarchar](445) NULL,
	[DiarisedToDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[SLAStartDate] [datetime] NULL,
	[SLAExpiryDate] [datetime] NULL,
	[SiteGroup] [int] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL,
	[DeleteBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5Work_v3_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_e5Work_v3_BIRowID] ON [dbo].[e5Work_v3]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5Work_v3_Assigned]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_Assigned] ON [dbo].[e5Work_v3]
(
	[AssignedUser] ASC,
	[StatusName] ASC
)
INCLUDE([Work_ID],[CompletionDate],[SLAExpiryDate],[ClaimNumber],[ClaimKey],[Country]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5Work_v3_Claim]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_Claim] ON [dbo].[e5Work_v3]
(
	[ClaimKey] ASC,
	[WorkType] ASC
)
INCLUDE([Work_ID],[CreationDate],[Reference],[AssignedUser],[Country]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5Work_v3_ClaimNumber]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_ClaimNumber] ON [dbo].[e5Work_v3]
(
	[ClaimNumber] ASC
)
INCLUDE([Work_ID],[Country],[WorkType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5Work_v3_CreationDate]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_CreationDate] ON [dbo].[e5Work_v3]
(
	[CreationDate] ASC
)
INCLUDE([Work_ID],[WorkType],[Country],[ClaimKey],[ClaimNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5Work_v3_ID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_ID] ON [dbo].[e5Work_v3]
(
	[Work_ID] ASC
)
INCLUDE([Reference],[ClaimKey],[ClaimNumber],[Country],[Original_Work_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5Work_v3_OriginalID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_OriginalID] ON [dbo].[e5Work_v3]
(
	[Original_Work_ID] ASC
)
INCLUDE([Work_ID],[SLAStartDate],[SLAExpiryDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5Work_v3_Parent]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_Parent] ON [dbo].[e5Work_v3]
(
	[Parent_ID] ASC,
	[Domain] ASC
)
INCLUDE([Work_ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_e5Work_v3_Reference]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_Reference] ON [dbo].[e5Work_v3]
(
	[Reference] ASC
)
INCLUDE([Work_ID],[Country],[WorkType],[ClaimKey],[ClaimNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_e5Work_v3_WorkType]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_e5Work_v3_WorkType] ON [dbo].[e5Work_v3]
(
	[WorkType] ASC,
	[StatusName] ASC
)
INCLUDE([Original_Work_ID],[Domain],[Work_ID],[AssignedUser],[CompletionDate],[SLAExpiryDate],[ClaimNumber],[ClaimKey],[GroupType],[CreationDate],[SLAStartDate],[Reference],[AssignedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
