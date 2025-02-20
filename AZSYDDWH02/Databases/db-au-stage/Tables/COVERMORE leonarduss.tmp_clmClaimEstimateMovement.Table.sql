USE [db-au-stage]
GO
/****** Object:  Table [COVERMORE\leonarduss].[tmp_clmClaimEstimateMovement]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [COVERMORE\leonarduss].[tmp_clmClaimEstimateMovement](
	[BIRowID] [int] IDENTITY(1,1) NOT NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[SectionKey] [varchar](40) NOT NULL,
	[BenefitCategory] [varchar](35) NOT NULL,
	[SectionCode] [varchar](25) NULL,
	[EstimateDate] [date] NULL,
	[EstimateDateUTC] [date] NULL,
	[EstimateCategory] [varchar](20) NULL,
	[EstimateMovement] [decimal](20, 6) NULL,
	[RecoveryEstimateMovement] [decimal](20, 6) NULL,
	[PaidOnPeriod] [decimal](20, 6) NULL,
	[BatchID] [int] NULL,
	[EstimateDateTime] [datetime] NULL
) ON [PRIMARY]
GO
