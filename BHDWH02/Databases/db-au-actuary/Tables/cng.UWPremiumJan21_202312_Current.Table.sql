USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumJan21_202312_Current]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumJan21_202312_Current](
	[issue_mth] [datetime2](7) NULL,
	[Rating_Group] [nvarchar](400) NULL,
	[JV_Description_Orig] [nvarchar](400) NULL,
	[Domain_Country] [nvarchar](400) NULL,
	[PolicyKey] [nvarchar](400) NULL,
	[UW_Policy_Status] [nvarchar](400) NULL,
	[Medical_Freq_Pred] [float] NULL,
	[Medical_ACS_Pred] [float] NULL,
	[Cancellation_Freq_Pred] [float] NULL,
	[Cancellation_ACS_Pred] [float] NULL,
	[Additional_Freq_Pred] [float] NULL,
	[Additional_ACS_Pred] [float] NULL,
	[Other_Freq_Pred] [float] NULL,
	[Other_ACS_Pred] [float] NULL,
	[Freq_Pred] [float] NULL,
	[ACS_Pred] [float] NULL,
	[UW_Premium] [float] NULL,
	[Medical] [float] NULL,
	[Cancellation] [float] NULL,
	[Additional] [float] NULL,
	[Other] [float] NULL,
	[RP_Pred] [float] NULL,
	[AdditionalDirectCoverageCPP] [float] NULL,
	[Segment] [nvarchar](400) NULL
) ON [PRIMARY]
GO
