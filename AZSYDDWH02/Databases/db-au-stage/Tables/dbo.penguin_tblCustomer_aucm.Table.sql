USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblCustomer_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblCustomer_aucm](
	[CustomerID] [int] NOT NULL,
	[QuoteCustomerID] [int] NULL,
	[Title] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [datetime] NULL,
	[AddressLine1] [nvarchar](100) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Town] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[HomePhone] [varchar](50) NULL,
	[WorkPhone] [varchar](50) NULL,
	[MobilePhone] [varchar](50) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[OptFurtherContact] [bit] NULL,
	[MemberNumber] [nvarchar](25) NULL,
	[MarketingConsent] [bit] NULL,
	[Gender] [nchar](1) NULL,
	[PersonalIdentifierID] [int] NULL,
	[PersonalIdentifierValue] [nvarchar](256) NULL,
	[StateOfArrival] [varchar](100) NULL,
	[MemberTypeId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblCustomer_aucm_CustomerID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblCustomer_aucm_CustomerID] ON [dbo].[penguin_tblCustomer_aucm]
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
