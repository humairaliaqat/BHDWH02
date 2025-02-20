USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblAddressMaintenance_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblAddressMaintenance_aucm](
	[AddrMaint_ID] [int] NOT NULL,
	[Case_No] [varchar](14) NOT NULL,
	[Key_ID] [int] NOT NULL,
	[Value] [nvarchar](500) NOT NULL,
	[Address_ID] [int] NULL
) ON [PRIMARY]
GO
