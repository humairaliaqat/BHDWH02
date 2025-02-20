USE [db-au-star]
GO
/****** Object:  Table [dbo].[Fact_GL]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Fact_GL](
	[Account_SID] [int] NULL,
	[Business_Unit_SK] [int] NULL,
	[Channel_SK] [int] NULL,
	[Currency_SK] [int] NULL,
	[Joint_Venture_SK] [int] NULL,
	[Department_SK] [int] NULL,
	[Date_SK] [int] NULL,
	[Scenario_SK] [int] NULL,
	[Source_Business_Unit_SK] [int] NULL,
	[Client_SK] [int] NULL,
	[GL_Product_SK] [int] NULL,
	[Project_Codes_SK] [int] NULL,
	[State_SK] [int] NULL,
	[Journal_Type_SK] [int] NULL,
	[General_Ledger_Amount] [numeric](18, 3) NULL,
	[Report_Amount] [numeric](18, 3) NULL,
	[Other_Amount] [numeric](18, 3) NULL,
	[Create_Date] [datetime] NOT NULL,
	[Insert_Batch_ID] [int] NOT NULL,
	[Update_Batch_ID] [int] NULL,
	[Fiscal_Period_Code] [int] NOT NULL,
	[Fact_GL_ID] [bigint] IDENTITY(1,1) NOT NULL,
	[GST_SK] [int] NULL,
 CONSTRAINT [PK_Fact_GL] PRIMARY KEY CLUSTERED 
(
	[Fact_GL_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [period]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [period] ON [dbo].[Fact_GL]
(
	[Fiscal_Period_Code] ASC,
	[Business_Unit_SK] ASC,
	[Scenario_SK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Fact_GL] ADD  DEFAULT ((-1)) FOR [GST_SK]
GO
