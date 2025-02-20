USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_factPolicyTravellerTemp]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_factPolicyTravellerTemp](
	[PolicyTransactionKey] [varchar](41) NOT NULL,
	[Country] [varchar](2) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[AlphaCode] [nvarchar](60) NULL,
	[DomainID] [int] NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[AreaName] [nvarchar](100) NULL,
	[AreaType] [varchar](25) NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[ProductKey] [nvarchar](243) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[PlanID] [int] NULL,
	[PlanName] [nvarchar](50) NULL,
	[PlanDisplayName] [nvarchar](100) NULL,
	[TripDuration] [int] NULL,
	[TravellerKey] [varchar](41) NULL,
	[Age] [int] NULL,
	[UserKey] [varchar](41) NULL,
	[UserName] [nvarchar](200) NULL,
	[ConsultantID] [int] NULL,
	[IssueDate] [date] NOT NULL,
	[PostingDate] [date] NULL,
	[TripDate] [date] NULL,
	[TravellersCount] [int] NULL,
	[CRMUserName] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
