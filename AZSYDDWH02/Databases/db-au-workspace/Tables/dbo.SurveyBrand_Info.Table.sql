USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[SurveyBrand_Info]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyBrand_Info](
	[Rowid] [int] NULL,
	[Journey] [varchar](500) NULL,
	[Survey_Brand] [varchar](200) NULL,
	[Account_Manager_Name] [varchar](500) NULL,
	[Account_Manager_EMail] [varchar](500) NULL,
	[Account_Manager_EMPId] [varchar](500) NULL,
	[OutletKey] [varchar](500) NULL,
	[GroupName] [varchar](500) NULL,
	[SuperGroup] [varchar](500) NULL,
	[SubGroup] [varchar](500) NULL,
	[Active] [varchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[SurveyBrand_Logo] [varchar](250) NULL,
	[CustomerEmail] [varchar](500) NULL,
	[Voc_Status] [int] NULL
) ON [PRIMARY]
GO
