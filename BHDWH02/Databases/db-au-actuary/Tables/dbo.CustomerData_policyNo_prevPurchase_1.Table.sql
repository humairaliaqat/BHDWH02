USE [db-au-actuary]
GO
/****** Object:  Table [dbo].[CustomerData_policyNo_prevPurchase_1]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerData_policyNo_prevPurchase_1](
	[key2019] [nvarchar](290) NULL,
	[policy2019] [varchar](50) NULL,
	[policyPrevious] [varchar](50) NULL,
	[fromPartner] [nvarchar](100) NULL,
	[keyPrevious] [nvarchar](290) NULL,
	[date2019] [datetime] NULL,
	[datePrevious] [datetime] NULL,
	[issueMonth] [int] NULL
) ON [PRIMARY]
GO
