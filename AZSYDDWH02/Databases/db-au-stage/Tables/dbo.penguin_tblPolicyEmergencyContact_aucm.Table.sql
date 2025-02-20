USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyEmergencyContact_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyEmergencyContact_aucm](
	[PolicyNumber] [varchar](25) NULL,
	[Title] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[SurName] [nvarchar](100) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[MobilePhone] [varchar](50) NULL,
	[WorkPhone] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL
) ON [PRIMARY]
GO
