USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCreditNoteDepartment_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCreditNoteDepartment_aucm](
	[CreditNoteDepartmentId] [int] NOT NULL,
	[Name] [varchar](55) NOT NULL,
	[Code] [varchar](3) NOT NULL
) ON [PRIMARY]
GO
