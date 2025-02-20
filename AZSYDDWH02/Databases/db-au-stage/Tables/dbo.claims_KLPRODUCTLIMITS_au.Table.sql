USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_KLPRODUCTLIMITS_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_KLPRODUCTLIMITS_au](
	[KI_ID] [int] NOT NULL,
	[KIPlan_ID] [int] NULL,
	[KIPerson_ID] [int] NULL,
	[KILimitAmt] [money] NULL,
	[KIProduct_ID] [int] NULL
) ON [PRIMARY]
GO
