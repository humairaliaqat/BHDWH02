USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCRMUser_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCRMUser_aucm](
	[ID] [int] NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[Inital] [nvarchar](10) NULL,
	[UserName] [nvarchar](100) NULL,
	[UpdateDateTime] [datetime] NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[PhoneNumber] [nvarchar](100) NULL,
	[Email] [nvarchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblCRMUser_aucm_ID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblCRMUser_aucm_ID] ON [dbo].[penguin_tblCRMUser_aucm]
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblCRMUser_aucm_UserName]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblCRMUser_aucm_UserName] ON [dbo].[penguin_tblCRMUser_aucm]
(
	[ID] ASC
)
INCLUDE([UserName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
