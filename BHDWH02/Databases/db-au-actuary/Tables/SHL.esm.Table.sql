USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[esm]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[esm](
	[ClaimKey] [nvarchar](50) NOT NULL,
	[Claim_Number] [int] NOT NULL,
	[Status] [nvarchar](50) NOT NULL,
	[Acturial_AssessmentOutcome] [nvarchar](50) NOT NULL,
	[Sum_of_Acturial_NetIncurredMovementIncRecoveries] [nvarchar](50) NOT NULL,
	[Sum_of_Acturial_NetPaymentMovementIncRecoveries] [nvarchar](50) NOT NULL,
	[Sum_of_Acturial_EstimateMovement] [nvarchar](50) NOT NULL,
	[Count_of_Acturial_SectionCode] [nvarchar](50) NOT NULL,
	[Count_of_Acturial_SectionCode_1] [nvarchar](50) NOT NULL,
	[Size] [nvarchar](50) NOT NULL,
	[Claim_Size] [nvarchar](50) NOT NULL,
	[Payment_9] [nvarchar](50) NOT NULL,
	[Payment_after_9] [nvarchar](50) NOT NULL,
	[Check] [nvarchar](50) NOT NULL,
	[Date_of_transaction] [datetime2](7) NOT NULL,
	[Pmt_prior_to_10th] [nvarchar](50) NOT NULL,
	[not_completed_or_rejected] [nvarchar](50) NOT NULL,
	[Assess] [nvarchar](50) NOT NULL,
	[Estimate_incl_Recy_at_end_of_1st_day] [float] NOT NULL,
	[Incurred_at_end_of_1st_day] [float] NOT NULL,
	[Payment_on_day_of_1st_transaction] [float] NOT NULL,
	[Claim_size_band] [int] NOT NULL,
	[est0] [nvarchar](50) NOT NULL,
	[Recy] [nvarchar](50) NOT NULL,
	[denied] [nvarchar](50) NOT NULL,
	[special_measure_anyway] [nvarchar](50) NOT NULL,
	[special_measure_with_leakage] [nvarchar](50) NOT NULL,
	[not_special_measure_owing_to_size] [nvarchar](50) NOT NULL,
	[Check_complete] [nvarchar](50) NOT NULL,
	[est0_special_measure_anyway] [nvarchar](50) NOT NULL,
	[est0_special_measure_with_leakage] [nvarchar](50) NOT NULL,
	[est0_not_special_measure] [nvarchar](50) NOT NULL,
	[estimate_not_nilled] [nvarchar](50) NOT NULL,
	[Status2] [nvarchar](50) NOT NULL,
	[Sp_5] [nvarchar](50) NOT NULL,
	[Med_and_US] [nvarchar](50) NOT NULL,
	[Statuson9th] [nvarchar](50) NOT NULL,
	[pmt_prior_to_10th_and_complete] [nvarchar](50) NOT NULL,
	[Medical_US_and_Access] [nvarchar](50) NOT NULL,
	[people] [nvarchar](50) NOT NULL,
	[Pmt_prior_to_10th_and_not_complete] [nvarchar](50) NOT NULL,
	[Check2] [nvarchar](50) NOT NULL,
	[StatusHistory] [nvarchar](50) NOT NULL,
	[Status_Flag] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
