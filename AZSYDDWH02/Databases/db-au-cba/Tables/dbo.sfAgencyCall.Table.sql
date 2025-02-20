USE [db-au-cba]
GO
/****** Object:  Table [dbo].[sfAgencyCall]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sfAgencyCall](
	[CallID] [nvarchar](18) NULL,
	[CallNumber] [nvarchar](80) NULL,
	[AccountID] [nvarchar](18) NULL,
	[AgencyID] [nvarchar](1300) NULL,
	[CallStartTime] [datetime] NULL,
	[CallEndTime] [datetime] NULL,
	[CallDuration] [int] NULL,
	[CallDurationText] [varchar](1300) NULL,
	[CallType] [nvarchar](255) NULL,
	[CallCategory] [nvarchar](255) NULL,
	[CallSubCategory] [nvarchar](255) NULL,
	[ConsultantID] [nvarchar](18) NULL,
	[ConsultantName] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[isDeleted] [bit] NULL,
	[LastActivityDate] [date] NULL,
	[LastModifiedBy] [nvarchar](255) NULL,
	[LastModifiedDate] [datetime] NULL,
	[RecordType] [varchar](255) NULL,
	[RoleType] [nvarchar](1300) NULL,
	[StopCall] [nvarchar](1300) NULL,
	[SurveyEmail] [nvarchar](255) NULL,
	[SystemModstamp] [datetime] NULL,
	[Timezone] [nvarchar](200) NULL,
	[CallComment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
