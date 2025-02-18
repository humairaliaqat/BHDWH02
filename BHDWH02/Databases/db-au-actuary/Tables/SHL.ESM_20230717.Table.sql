USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[ESM_20230717]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[ESM_20230717](
	[ClaimKey] [nvarchar](50) NULL,
	[Claim_Number] [int] NULL,
	[Status] [nvarchar](50) NULL,
	[Acturial_AssessmentOutcome] [nvarchar](50) NULL,
	[Sum_of_Acturial_NetIncurredMovementIncRecoveries] [nvarchar](50) NULL,
	[Sum_of_Acturial_NetPaymentMovementIncRecoveries] [nvarchar](50) NULL,
	[Sum_of_Acturial_EstimateMovement] [nvarchar](50) NULL,
	[Count_of_Acturial_SectionCode] [nvarchar](50) NULL,
	[Count_of_Acturial_SectionCode_1] [nvarchar](50) NULL,
	[Size] [nvarchar](50) NULL,
	[Claim_Size] [nvarchar](50) NULL,
	[Payment_9] [nvarchar](50) NULL,
	[Payment_after_9] [nvarchar](50) NULL,
	[Check] [nvarchar](50) NULL,
	[Date_of_transaction] [datetime2](7) NULL,
	[Pmt_prior_to_10th] [nvarchar](50) NULL,
	[not_completed_or_rejected] [nvarchar](50) NULL,
	[Assess] [nvarchar](50) NULL,
	[Estimate_incl_Recy_at_end_of_1st_day] [float] NULL,
	[Incurred_at_end_of_1st_day] [float] NULL,
	[Payment_on_day_of_1st_transaction] [float] NULL,
	[Claim_size_band] [int] NULL,
	[est0] [nvarchar](50) NULL,
	[Recy] [nvarchar](50) NULL,
	[denied] [nvarchar](50) NULL,
	[special_measure_anyway] [nvarchar](50) NULL,
	[special_measure_with_leakage] [nvarchar](50) NULL,
	[not_special_measure_owing_to_size] [nvarchar](50) NULL,
	[Check_complete] [nvarchar](50) NULL,
	[est0_special_measure_anyway] [nvarchar](50) NULL,
	[est0_special_measure_with_leakage] [nvarchar](50) NULL,
	[est0_not_special_measure] [nvarchar](50) NULL,
	[estimate_not_nilled] [nvarchar](50) NULL,
	[Status2] [nvarchar](50) NULL,
	[Sp_5] [nvarchar](50) NULL,
	[Med_and_US] [nvarchar](50) NULL,
	[Statuson9th] [nvarchar](50) NULL,
	[pmt_prior_to_10th_and_complete] [nvarchar](50) NULL,
	[Medical_US_and_Access] [nvarchar](50) NULL,
	[people] [nvarchar](50) NULL,
	[Pmt_prior_to_10th_and_not_complete] [nvarchar](50) NULL,
	[Check2] [nvarchar](50) NULL,
	[StatusHistory] [nvarchar](50) NULL,
	[Status_Flag] [nvarchar](50) NULL
) ON [PRIMARY]
GO
