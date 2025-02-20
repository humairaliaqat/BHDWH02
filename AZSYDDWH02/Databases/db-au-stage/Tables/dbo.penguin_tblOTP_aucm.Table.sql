USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOTP_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOTP_aucm](
	[ID] [int] NOT NULL,
	[OutletTypeID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[EffectiveDate] [datetime] NULL,
	[DomainId] [int] NOT NULL,
	[SubGroupId] [int] NOT NULL
) ON [PRIMARY]
GO
