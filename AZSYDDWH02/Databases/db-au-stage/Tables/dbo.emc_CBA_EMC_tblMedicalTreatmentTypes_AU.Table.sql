USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblMedicalTreatmentTypes_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblMedicalTreatmentTypes_AU](
	[RxTypeCode] [tinyint] NOT NULL,
	[RxType] [varchar](35) NULL
) ON [PRIMARY]
GO
