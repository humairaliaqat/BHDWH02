USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblSecurity_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblSecurity_AU](
	[UserID] [int] NOT NULL,
	[Login] [varchar](15) NULL,
	[FullName] [varchar](50) NULL,
	[SecLevel] [varchar](5) NULL,
	[Password] [varchar](10) NULL,
	[Initial] [char](2) NULL,
	[Phone] [varchar](15) NULL,
	[Email] [varchar](50) NULL,
	[ValidFrom] [datetime] NULL,
	[ValidTo] [datetime] NULL
) ON [PRIMARY]
GO
