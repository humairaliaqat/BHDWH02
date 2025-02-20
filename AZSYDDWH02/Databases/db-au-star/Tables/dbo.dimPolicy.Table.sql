USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimPolicy]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimPolicy](
	[PolicySK] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](10) NOT NULL,
	[PolicyKey] [nvarchar](50) NOT NULL,
	[PolicyNumber] [varchar](50) NOT NULL,
	[PolicyStatus] [nvarchar](50) NULL,
	[IssueDate] [datetime] NULL,
	[CancelledDate] [datetime] NULL,
	[TripStart] [datetime] NULL,
	[TripEnd] [datetime] NULL,
	[GroupName] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[PolicyStart] [datetime] NULL,
	[PolicyEnd] [datetime] NULL,
	[Excess] [decimal](18, 2) NOT NULL,
	[TripType] [nvarchar](50) NULL,
	[TripCost] [nvarchar](50) NULL,
	[isCancellation] [nvarchar](1) NULL,
	[CancellationCover] [nvarchar](50) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL,
	[PurchasePath] [nvarchar](50) NULL,
	[MaxDuration] [int] NULL,
	[TravellerCount] [int] NULL,
	[AdultCount] [int] NULL,
	[ChargedAdultCount] [int] NULL,
	[TotalPremium] [float] NULL,
	[EMCFlag] [varchar](10) NULL,
	[MaxEMCScore] [decimal](18, 2) NULL,
	[TotalEMCScore] [decimal](18, 2) NULL,
	[CancellationFlag] [varchar](25) NULL,
	[CruiseFlag] [varchar](25) NULL,
	[ElectronicsFlag] [varchar](25) NULL,
	[LuggageFlag] [varchar](25) NULL,
	[MotorcycleFlag] [varchar](25) NULL,
	[RentalCarFlag] [varchar](25) NULL,
	[WinterSportFlag] [varchar](25) NULL,
	[Underwriter] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [cidx_policysk]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx_policysk] ON [dbo].[dimPolicy]
(
	[PolicySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPolicy_HashKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPolicy_HashKey] ON [dbo].[dimPolicy]
(
	[HashKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPolicy_PolicyKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPolicy_PolicyKey] ON [dbo].[dimPolicy]
(
	[PolicyKey] ASC
)
INCLUDE([PolicySK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimPolicy_PolicyNumber]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimPolicy_PolicyNumber] ON [dbo].[dimPolicy]
(
	[PolicyNumber] ASC,
	[Country] ASC
)
INCLUDE([PolicySK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
