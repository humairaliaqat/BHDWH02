USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[tmp_Finance_Credit_Note]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_Finance_Credit_Note](
	[Country Key] [varchar](2) NULL,
	[Company Key] [varchar](3) NOT NULL,
	[Domain Id] [int] NOT NULL,
	[Domain Key] [varchar](8) NULL,
	[Credit Note Id] [int] NOT NULL,
	[Credit Note PolicyKey] [varchar](18) NULL,
	[Credit Note Number] [nvarchar](15) NOT NULL,
	[Credit Note Issue Date] [datetime] NOT NULL,
	[Credit Note Start Date] [datetime] NULL,
	[Credit Note Expiry Date] [datetime] NULL,
	[Credit Note Transaction Date] [datetime] NULL,
	[Credit Note Transaction Month] [datetime] NULL,
	[Credit Note Transaction Order] [bigint] NULL,
	[Credit Note Status] [varchar](15) NOT NULL,
	[Credit Note Status Fix] [varchar](16) NOT NULL,
	[Credit Note Comments] [nvarchar](max) NULL,
	[Credit Note Redeemed Status] [varchar](200) NULL,
	[Credit Note Issued Amount] [money] NULL,
	[Credit Note Issued Commission] [money] NULL,
	[Credit Note Expired Amount] [money] NOT NULL,
	[Credit Note Expired Commission] [money] NULL,
	[Credit Note Redeemed Amount] [money] NULL,
	[Credit Note Redeemed Commission] [money] NULL,
	[Credit Note Refunded Amount] [money] NOT NULL,
	[Credit Note Refunded Commission] [money] NULL,
	[Credit Note Balance Amount] [money] NULL,
	[Credit Note Balance Commission] [money] NULL,
	[Credit Note Balance Amount Total] [money] NULL,
	[Credit Note Balance Commission Total] [money] NULL,
	[Original PolicyId] [int] NOT NULL,
	[Original PolicyKey] [varchar](18) NULL,
	[Original PolicyNumber] [varchar](50) NULL,
	[Original Issue Date] [datetime] NULL,
	[Original JV] [nvarchar](55) NULL,
	[Original JV Code] [nvarchar](10) NULL,
	[Redeemed PolicyId] [int] NULL,
	[Redeemed PolicyKey] [varchar](18) NULL,
	[Redeemed PolicyNumber] [varchar](50) NULL,
	[Redeemed Issue Date] [datetime] NULL,
	[Redeemed JV] [nvarchar](55) NULL,
	[Redeemed JV Code] [nvarchar](10) NULL,
	[Original UW Premium] [float] NULL,
	[Expired UW Premium] [float] NULL,
	[Redeemed UW Premium] [float] NULL,
	[Refunded UW Premium] [float] NULL,
	[Additional UW Premium] [float] NULL,
	[Balance UW Premium] [float] NULL,
	[Balance UW Premium Total] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
