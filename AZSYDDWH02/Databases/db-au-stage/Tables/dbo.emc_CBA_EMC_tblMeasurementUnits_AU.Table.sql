USE [db-au-stage]
GO
/****** Object:  Table [dbo].[emc_CBA_EMC_tblMeasurementUnits_AU]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emc_CBA_EMC_tblMeasurementUnits_AU](
	[UnitID] [tinyint] NOT NULL,
	[MeasurementTypeCode] [char](1) NULL,
	[Unit] [varchar](20) NULL
) ON [PRIMARY]
GO
