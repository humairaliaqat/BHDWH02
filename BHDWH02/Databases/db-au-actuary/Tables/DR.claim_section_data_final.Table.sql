USE [db-au-actuary]
GO
/****** Object:  Table [DR].[claim_section_data_final]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[claim_section_data_final](
	[claim_hash] [varbinary](8000) NULL,
	[sectioncode] [varchar](25) NULL,
	[perilcode] [varchar](3) NOT NULL,
	[catcode] [varchar](3) NOT NULL,
	[eventcountryname] [nvarchar](45) NULL,
	[assessmentoutcome] [nvarchar](400) NULL,
	[lodgeddate] [date] NULL,
	[lossdate] [date] NULL,
	[net_incurred_cost] [numeric](38, 6) NULL,
	[recoveries_amount] [numeric](38, 6) NULL,
	[initialEstimate] [numeric](38, 6) NULL,
	[num_sections] [int] NULL,
	[finaliseddate] [datetime] NULL,
	[initialEstDate] [datetime] NULL,
	[reOpened] [int] NULL,
	[product code] [nvarchar](50) NULL,
	[destination] [nvarchar](max) NULL,
	[trip type] [nvarchar](50) NULL,
	[plan type] [nvarchar](50) NULL,
	[policy type] [nvarchar](50) NULL,
	[excess] [int] NULL,
	[issue date] [datetime] NULL,
	[departure date] [datetime] NULL,
	[return date] [datetime] NULL,
	[outlet channel] [nvarchar](100) NULL,
	[JV Description] [nvarchar](100) NULL,
	[cancellation limit] [int] NULL,
	[cancellationDate] [datetime] NULL,
	[policy status] [varchar](50) NULL,
	[state] [nvarchar](100) NULL,
	[country] [nvarchar](100) NULL,
	[Gross Premium Adventure Activities] [money] NULL,
	[Gross Premium Aged Cover] [money] NULL,
	[Gross Premium Ancillary Products] [money] NULL,
	[Gross Premium Cancel For Any Reason] [money] NULL,
	[Gross Premium Cancellation] [money] NULL,
	[Gross Premium Cruise] [money] NULL,
	[Gross Premium Electronics] [money] NULL,
	[Gross Premium Medical] [money] NULL,
	[Gross Premium Motorcycle] [money] NULL,
	[Gross Premium Luggage] [money] NULL,
	[Gross Premium Rental Car] [money] NULL,
	[Gross Premium Winter Sport] [money] NULL,
	[Gross Premium Ticket] [money] NULL,
	[Premium] [money] NULL,
	[Sell Price] [money] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[min_age] [int] NULL,
	[max_age] [int] NULL,
	[num_travlrs] [int] NULL,
	[hasEMC] [int] NULL,
	[MaxEMCscore] [numeric](18, 2) NULL,
	[Conditions] [varchar](662) NULL,
	[ProcessTypes] [varchar](560) NULL,
	[initialAssessmentOutcome] [varchar](50) NULL,
	[numberOfassessments] [varchar](50) NULL,
	[WTP_cbase] [int] NULL,
	[Fraud_investigated] [int] NOT NULL,
	[MAT_assessed] [int] NOT NULL,
	[recoveries_pursued] [int] NOT NULL,
	[complaint_received] [int] NOT NULL,
	[Audit_failed] [int] NULL,
	[CFAR] [int] NULL,
	[infection] [int] NULL,
	[heartAttack_stroke] [int] NULL,
	[cancer] [int] NULL,
	[death] [int] NULL,
	[theft] [int] NULL,
	[alcohol] [int] NULL,
	[vehicle] [int] NULL,
	[gastro] [int] NULL,
	[medical] [int] NULL,
	[hospital] [int] NULL,
	[damaged] [int] NULL,
	[flu] [int] NULL,
	[injury] [int] NULL,
	[lost] [int] NULL,
	[UTI] [int] NULL,
	[food_poisoning] [int] NULL,
	[slip_trip] [int] NULL,
	[ship_boat] [int] NULL,
	[dental] [int] NULL,
	[devicePhone] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
