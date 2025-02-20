USE [db-au-actuary]
GO
/****** Object:  Table [ws].[CustomerOnBasePolicy]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[CustomerOnBasePolicy](
	[BIRowID] [bigint] NOT NULL,
	[PolicyKey] [varchar](41) NULL,
	[CustomerKey] [varchar](41) NULL,
	[CustomerID] [int] NULL,
	[Title] [varchar](6) NULL,
	[FirstName] [varchar](25) NULL,
	[LastName] [varchar](25) NULL,
	[DateOfBirth] [datetime] NULL,
	[AgeAtDateOfIssue] [int] NULL,
	[PersonIsAdult] [bit] NULL,
	[isPrimary] [bit] NULL,
	[ClientID] [varchar](35) NULL,
	[EMCPremiumAmount] [money] NULL
) ON [PRIMARY]
GO
