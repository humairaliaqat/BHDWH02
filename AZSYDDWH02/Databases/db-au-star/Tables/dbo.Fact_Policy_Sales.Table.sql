USE [db-au-star]
GO
/****** Object:  Table [dbo].[Fact_Policy_Sales]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_Policy_Sales](
	[Age_Band_SK] [int] NULL,
	[Outlet_SK] [int] NULL,
	[Business_Unit_SK] [int] NULL,
	[Currency_SK] [int] NULL,
	[Cancellation_Cover_SK] [int] NULL,
	[Consultant_SK] [int] NULL,
	[Date_SK] [int] NULL,
	[Excess_SK] [int] NULL,
	[Product_SK] [int] NULL,
	[Travel_Destination_SK] [int] NULL,
	[Trip_Duration_SK] [int] NULL,
	[Number_of_Policies] [int] NULL,
	[Number_of_Quotes] [int] NULL,
	[Premium_Amount] [decimal](18, 4) NULL,
	[Commission_Amount] [decimal](18, 4) NULL,
	[Premium_SD_Amount] [decimal](18, 4) NULL,
	[Premium_GST_Amount] [decimal](18, 4) NULL,
	[Commission_SD_Amount] [decimal](18, 4) NULL,
	[Commission_GST_Amount] [decimal](18, 4) NULL,
	[Domain_ID] [int] NOT NULL,
	[Source_System_Code] [varchar](20) NOT NULL,
	[Create_Date] [datetime] NOT NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [IX01_Fact_Policy_Sales]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [IX01_Fact_Policy_Sales] ON [dbo].[Fact_Policy_Sales]
(
	[Date_SK] ASC,
	[Outlet_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
