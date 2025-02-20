USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_tblOnlineClaimUser_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_tblOnlineClaimUser_au](
	[UserId] [int] NOT NULL,
	[PolicyNumber] [varchar](25) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [date] NULL,
	[KLDOMAINID] [int] NOT NULL
) ON [PRIMARY]
GO
