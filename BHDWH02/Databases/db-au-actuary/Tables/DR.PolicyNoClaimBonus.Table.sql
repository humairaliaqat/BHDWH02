USE [db-au-actuary]
GO
/****** Object:  Table [DR].[PolicyNoClaimBonus]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[PolicyNoClaimBonus](
	[Base Policy No] [nvarchar](50) NULL,
	[isNoClaimBonus] [bit] NULL
) ON [PRIMARY]
GO
