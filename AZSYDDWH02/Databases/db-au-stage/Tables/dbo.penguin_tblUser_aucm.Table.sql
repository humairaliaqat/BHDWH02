USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblUser_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblUser_aucm](
	[UserId] [int] NOT NULL,
	[OutletId] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Login] [nvarchar](100) NULL,
	[Initial] [nvarchar](50) NOT NULL,
	[ASICNumber] [varchar](50) NULL,
	[AgreementDate] [datetime] NULL,
	[AccessLevel] [int] NOT NULL,
	[AccreditationNumber] [varchar](50) NULL,
	[AllowAdjustPricing] [bit] NULL,
	[Status] [datetime] NULL,
	[AgentCode] [nvarchar](50) NULL,
	[Password] [varbinary](100) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NULL,
	[MustChangePassword] [bit] NOT NULL,
	[ASICCheck] [int] NULL,
	[AccountLocked] [bit] NOT NULL,
	[LoginFailedTimes] [int] NOT NULL,
	[Email] [nvarchar](200) NULL,
	[IsSuperUser] [bit] NOT NULL,
	[DateOfBirth] [datetime] NULL,
	[LastUpdateUserId] [int] NULL,
	[LastUpdateCrmUserId] [int] NULL,
	[LastLoggedInDateTime] [datetime] NULL,
	[IsAutomatedUser] [bit] NOT NULL,
	[ExternalIdentifier] [nvarchar](100) NULL,
	[IsUserClickedLink] [bit] NOT NULL,
	[VelocityNumber] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblUser_aucm_UserID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblUser_aucm_UserID] ON [dbo].[penguin_tblUser_aucm]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblUser_aucm_DomainID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblUser_aucm_DomainID] ON [dbo].[penguin_tblUser_aucm]
(
	[UserId] ASC
)
INCLUDE([OutletId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penguin_tblUser_aucm_Login]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblUser_aucm_Login] ON [dbo].[penguin_tblUser_aucm]
(
	[Login] ASC,
	[OutletId] ASC
)
INCLUDE([FirstName],[LastName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
