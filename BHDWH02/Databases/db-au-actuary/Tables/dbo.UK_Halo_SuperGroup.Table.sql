USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[UK_Halo_SuperGroup]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UK_Halo_SuperGroup](
	[Agency Name] [nvarchar](255) NULL,
	[Customer Policy Number] [nvarchar](255) NULL,
	[Transaction Date] [smalldatetime] NULL,
	[Inception Date] [smalldatetime] NULL,
	[Expiry Date] [smalldatetime] NULL,
	[Type Of Product] [nvarchar](255) NULL,
	[Days Cover] [float] NULL,
	[Currency] [nvarchar](255) NULL,
	[Product Name] [nvarchar](255) NULL,
	[Gross Premium Exc Taxes] [float] NULL,
	[GST Cost] [float] NULL,
	[Stamp Duty] [float] NULL,
	[Gross Premium Inc Taxes] [float] NULL,
	[Underwriter Costs] [float] NULL,
	[Net Commission to Halo] [float] NULL,
	[Cancelled] [nvarchar](255) NULL,
	[Insured Name] [nvarchar](255) NULL,
	[Insured Date of Birth] [smalldatetime] NULL,
	[Underwriter Name] [nvarchar](255) NULL,
	[State] [nvarchar](255) NULL,
	[Country Of Residence] [nvarchar](255) NULL,
	[Auto Renewals] [nvarchar](255) NULL,
	[Charged To Customer] [float] NULL,
	[Admin Fee] [float] NULL,
	[Transaction Type] [nvarchar](255) NULL,
	[Transaction ID] [nvarchar](255) NULL,
	[Stripe ID] [nvarchar](255) NULL,
	[Manual Transfer] [nvarchar](255) NULL,
	[MTA Category] [nvarchar](255) NULL,
	[Payment Status] [nvarchar](255) NULL,
	[Payment Status Error] [nvarchar](255) NULL,
	[TN Check] [nvarchar](255) NULL,
	[FileName_Excel] [varchar](2000) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [NonClusteredIndex-20230602-223014]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20230602-223014] ON [dbo].[UK_Halo_SuperGroup]
(
	[Customer Policy Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
