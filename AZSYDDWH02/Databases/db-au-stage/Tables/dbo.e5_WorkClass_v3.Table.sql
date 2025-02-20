USE [db-au-stage]
GO
/****** Object:  Table [dbo].[e5_WorkClass_v3]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5_WorkClass_v3](
	[ExternalId] [uniqueidentifier] NOT NULL,
	[Id] [int] NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[DiariseList_Id] [int] NOT NULL,
	[AlwaysViewAttachments] [bit] NOT NULL,
	[MatchFindId] [int] NULL,
	[MatchProperty] [nvarchar](32) NULL,
	[MatchStatus] [int] NULL,
	[PreProcessorAssembly] [varchar](256) NULL,
	[PreProcessorClass] [varchar](256) NULL,
	[PreProcessorMethod] [varchar](256) NULL,
	[PostProcessorAssembly] [varchar](256) NULL,
	[PostProcessorClass] [varchar](256) NULL,
	[PostProcessorMethod] [varchar](256) NULL,
	[WorkWindowX] [int] NULL,
	[WorkWindowY] [int] NULL,
	[WorkWindowW] [int] NULL,
	[WorkWindowH] [int] NULL,
	[WorkWindowLayout] [int] NULL,
	[AttachmentWindowX] [int] NULL,
	[AttachmentWindowY] [int] NULL,
	[AttachmentWindowW] [int] NULL,
	[AttachmentWindowH] [int] NULL,
	[ChildrenFindId] [int] NULL,
	[SLAMode] [tinyint] NOT NULL,
	[BusinessHoursProviderType] [nvarchar](1024) NULL,
	[CreatedDateTime] [datetime2](7) NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ModifiedDateTime] [datetime2](7) NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[EndGetNextReasonList_Id] [int] NULL,
	[ParentFindId] [int] NULL,
	[TemplateFolderProperty] [nvarchar](32) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [e5_WorkClass_v31]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [e5_WorkClass_v31] ON [dbo].[e5_WorkClass_v3]
(
	[Id] ASC
)
INCLUDE([Name]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
