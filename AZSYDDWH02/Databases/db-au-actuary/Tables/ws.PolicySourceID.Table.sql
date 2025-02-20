USE [db-au-actuary]
GO
/****** Object:  Table [ws].[PolicySourceID]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[PolicySourceID](
	[Country] [varchar](2) NOT NULL,
	[PolicyNo] [int] NOT NULL,
	[OldPolicyNo] [int] NULL,
	[AgencyCode] [varchar](7) NULL,
	[PolicyID] [int] NOT NULL,
	[DepartureDate] [datetime] NULL,
	[ReturnDate] [datetime] NULL,
	[GroupPolicy] [bit] NOT NULL,
	[Destination] [varchar](50) NULL,
	[Suburb] [varchar](30) NULL,
	[State] [varchar](20) NULL,
	[PostCode] [varchar](50) NULL,
	[AddressCountry] [varchar](20) NULL,
	[BIRowID] [bigint] NOT NULL
) ON [PRIMARY]
GO
