USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblMedicalTreatmentDetails_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblMedicalTreatmentDetails_AU](
	[RxDetsID] [int] NOT NULL,
	[ClientID] [int] NULL,
	[MedRxID] [int] NULL,
	[RxDate] [datetime] NULL,
	[RxDetails] [varchar](2000) NULL
) ON [PRIMARY]
GO
