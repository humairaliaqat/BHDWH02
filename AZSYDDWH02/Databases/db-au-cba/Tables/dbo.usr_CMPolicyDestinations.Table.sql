USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usr_CMPolicyDestinations]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usr_CMPolicyDestinations](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[PolicyCount] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
