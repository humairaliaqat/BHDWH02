USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_emcApplications]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_emcApplications](
	[CountryKey] [varchar](2) NULL,
	[ApplicationKey] [varchar](15) NULL,
	[CompanyKey] [varchar](11) NULL,
	[AgencyKey] [varchar](10) NULL,
	[OutletAlphaKey] [varchar](48) NULL,
	[AssessorKey] [varchar](10) NULL,
	[CreatorKey] [varchar](10) NULL,
	[ApplicationID] [int] NOT NULL,
	[RecordID] [int] NOT NULL,
	[ApplicationType] [varchar](25) NULL,
	[AgencyCode] [varchar](7) NULL,
	[AssessorID] [smallint] NULL,
	[Assessor] [varchar](50) NULL,
	[CreatorID] [int] NULL,
	[Creator] [varchar](50) NULL,
	[Priority] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[ReceiveDate] [datetime] NULL,
	[AssessedDate] [datetime] NULL,
	[CreateDateOnly] [datetime] NULL,
	[AssessedDateOnly] [date] NULL,
	[IsEndorsementSigned] [bit] NULL,
	[EndorsementDate] [datetime] NULL,
	[ApplicationStatus] [varchar](22) NULL,
	[ApprovalStatus] [varchar](15) NULL,
	[AgeApprovalStatus] [varchar](12) NOT NULL,
	[MedicalRisk] [numeric](18, 2) NULL,
	[AreaName] [nvarchar](100) NULL,
	[AreaCode] [varchar](50) NULL,
	[ScreeningVersion] [varchar](10) NULL,
	[PlanCode] [nvarchar](50) NULL,
	[ProductCode] [varchar](3) NULL,
	[ProductType] [varchar](100) NULL,
	[DepartureDate] [datetime] NULL,
	[ReturnDate] [datetime] NULL,
	[TripDuration] [int] NULL,
	[Destination] [nvarchar](max) NULL,
	[TravellerCount] [tinyint] NULL,
	[ValuePerTraveller] [money] NULL,
	[TripType] [varchar](20) NULL,
	[PolicyNo] [varchar](13) NULL,
	[OtherInsurer] [varchar](50) NULL,
	[InputType] [varchar](10) NULL,
	[FileLocation] [varchar](50) NULL,
	[FileLocationDate] [datetime] NULL,
	[ClaimNo] [int] NULL,
	[ClaimDate] [datetime] NULL,
	[IsClaimRelatedToEMC] [bit] NULL,
	[IsDeclarationSigned] [bit] NULL,
	[IsAnnualBusinessPlan] [bit] NULL,
	[IsApplyingForEMCCover] [bit] NULL,
	[IsApplyingForCMCover] [bit] NULL,
	[IsSendOutcomeByEmail] [bit] NULL,
	[HasAgeDestinationDuration] [bit] NULL,
	[IsDutyOfDisclosure] [bit] NULL,
	[IsCruise] [bit] NULL,
	[isAnnualMultiTrip] [bit] NULL,
	[isWinterSport] [bit] NULL,
	[isOnlineAssessment] [int] NOT NULL,
	[OnlineAssessment] [varchar](max) NULL,
	[IsAwaitingMedicalReview] [int] NULL,
	[HasBeenTreatedLast12Months] [int] NULL,
	[HasVisitedDoctorLast90Days] [int] NULL,
	[IsSeekingMedicalOverseas] [int] NULL,
	[IsTravellingAgainstMedicalAdvice] [int] NULL,
	[HasDiagnosedTerminalCondition] [int] NULL,
	[HasReceviedAdviceTerminalCondition] [int] NULL,
	[MedicalTotalCount] [int] NOT NULL,
	[MedicalApprovedCount] [int] NOT NULL,
	[MedicalAutoAcceptCount] [int] NOT NULL,
	[MedicalDeniedCount] [int] NOT NULL,
	[MedicalAwaitingAssessmentCount] [int] NOT NULL,
	[MedicalNotAssessedCount] [int] NOT NULL,
	[IsMultipleDestinations] [bit] NULL,
	[IsAccepted] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
