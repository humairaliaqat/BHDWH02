USE [db-au-actuary]
GO
/****** Object:  Table [ws].[DWHDataSet]    Script Date: 20/02/2025 10:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[DWHDataSet](
	[BIRowID] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Domain Country] [varchar](2) NULL,
	[Company] [varchar](5) NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyTransactionKey] [varchar](41) NULL,
	[isParent] [int] NULL,
	[Base Policy No] [varchar](50) NULL,
	[Policy No] [varchar](50) NULL,
	[Issue Date] [datetime] NULL,
	[Transaction Issue Date] [datetime] NULL,
	[Posting Date] [datetime] NULL,
	[Transaction Type] [varchar](50) NULL,
	[Policy Status] [varchar](50) NULL,
	[Transaction Status] [varchar](50) NULL,
	[Departure Date] [datetime] NULL,
	[Return Date] [datetime] NULL,
	[Lead Time] [int] NULL,
	[Maximum Trip Length] [int] NULL,
	[Trip Duration] [int] NULL,
	[Trip Length] [int] NULL,
	[Area Name] [nvarchar](150) NULL,
	[Area Number] [varchar](100) NULL,
	[Destination] [nvarchar](max) NULL,
	[Excess] [int] NULL,
	[Group Policy] [int] NULL,
	[Has Rental Car] [bit] NULL,
	[Has Motorcycle] [bit] NULL,
	[Has Wintersport] [bit] NULL,
	[Has Medical] [bit] NULL,
	[Single/Family] [nvarchar](1) NULL,
	[Purchase Path] [nvarchar](50) NULL,
	[TRIPS Policy] [bit] NULL,
	[Product Code] [nvarchar](50) NULL,
	[Plan Code] [nvarchar](50) NULL,
	[Product Name] [nvarchar](100) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Product Type] [nvarchar](100) NULL,
	[Product Group] [nvarchar](100) NULL,
	[Policy Type] [nvarchar](50) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[Trip Type] [nvarchar](50) NULL,
	[Product Classification] [nvarchar](100) NULL,
	[Finance Product Code] [nvarchar](50) NULL,
	[OutletKey] [varchar](33) NULL,
	[Alpha Code] [nvarchar](20) NULL,
	[Original Alpha Code] [nvarchar](20) NULL,
	[Transaction Alpha Code] [nvarchar](20) NULL,
	[Transaction OutletKey] [varchar](33) NULL,
	[Customer Post Code] [nvarchar](50) NULL,
	[Unique Traveller Count] [int] NULL,
	[Unique Charged Traveller Count] [int] NULL,
	[Traveller Count] [int] NULL,
	[Charged Traveller Count] [int] NULL,
	[Adult Traveller Count] [int] NULL,
	[EMC Traveller Count] [int] NULL,
	[Youngest Charged DOB] [datetime] NULL,
	[Oldest Charged DOB] [datetime] NULL,
	[Youngest Age] [int] NULL,
	[Oldest Age] [int] NULL,
	[Youngest Charged Age] [int] NULL,
	[Oldest Charged Age] [int] NULL,
	[Max EMC Score] [numeric](18, 2) NULL,
	[Total EMC Score] [numeric](18, 2) NULL,
	[Charged Traveller 1 Gender] [nchar](2) NULL,
	[Charged Traveller 1 DOB] [date] NULL,
	[Charged Traveller 1 Has EMC] [smallint] NULL,
	[Charged Traveller 1 Has Manual EMC] [bit] NULL,
	[Charged Traveller 1 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 1 EMC Reference] [int] NULL,
	[Charged Traveller 2 Gender] [nchar](2) NULL,
	[Charged Traveller 2 DOB] [date] NULL,
	[Charged Traveller 2 Has EMC] [smallint] NULL,
	[Charged Traveller 2 Has Manual EMC] [bit] NULL,
	[Charged Traveller 2 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 2 EMC Reference] [int] NULL,
	[Charged Traveller 3 Gender] [nchar](2) NULL,
	[Charged Traveller 3 DOB] [date] NULL,
	[Charged Traveller 3 Has EMC] [smallint] NULL,
	[Charged Traveller 3 Has Manual EMC] [bit] NULL,
	[Charged Traveller 3 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 3 EMC Reference] [int] NULL,
	[Charged Traveller 4 Gender] [nchar](2) NULL,
	[Charged Traveller 4 DOB] [date] NULL,
	[Charged Traveller 4 Has EMC] [smallint] NULL,
	[Charged Traveller 4 Has Manual EMC] [bit] NULL,
	[Charged Traveller 4 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 4 EMC Reference] [int] NULL,
	[Charged Traveller 5 Gender] [nchar](2) NULL,
	[Charged Traveller 5 DOB] [date] NULL,
	[Charged Traveller 5 Has EMC] [smallint] NULL,
	[Charged Traveller 5 Has Manual EMC] [bit] NULL,
	[Charged Traveller 5 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 5 EMC Reference] [int] NULL,
	[Charged Traveller 6 Gender] [nchar](2) NULL,
	[Charged Traveller 6 DOB] [date] NULL,
	[Charged Traveller 6 Has EMC] [smallint] NULL,
	[Charged Traveller 6 Has Manual EMC] [bit] NULL,
	[Charged Traveller 6 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 6 EMC Reference] [int] NULL,
	[Charged Traveller 7 Gender] [nchar](2) NULL,
	[Charged Traveller 7 DOB] [date] NULL,
	[Charged Traveller 7 Has EMC] [smallint] NULL,
	[Charged Traveller 7 Has Manual EMC] [bit] NULL,
	[Charged Traveller 7 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 7 EMC Reference] [int] NULL,
	[Charged Traveller 8 Gender] [nchar](2) NULL,
	[Charged Traveller 8 DOB] [date] NULL,
	[Charged Traveller 8 Has EMC] [smallint] NULL,
	[Charged Traveller 8 Has Manual EMC] [bit] NULL,
	[Charged Traveller 8 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 8 EMC Reference] [int] NULL,
	[Charged Traveller 9 Gender] [nchar](2) NULL,
	[Charged Traveller 9 DOB] [date] NULL,
	[Charged Traveller 9 Has EMC] [smallint] NULL,
	[Charged Traveller 9 Has Manual EMC] [bit] NULL,
	[Charged Traveller 9 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 9 EMC Reference] [int] NULL,
	[Charged Traveller 10 Gender] [nchar](2) NULL,
	[Charged Traveller 10 DOB] [date] NULL,
	[Charged Traveller 10 Has EMC] [smallint] NULL,
	[Charged Traveller 10 Has Manual EMC] [bit] NULL,
	[Charged Traveller 10 EMC Score] [decimal](18, 2) NULL,
	[Charged Traveller 10 EMC Reference] [int] NULL,
	[Commission Tier] [varchar](50) NULL,
	[Volume Commission] [money] NULL,
	[Discount] [money] NULL,
	[Base Base Premium] [money] NULL,
	[Base Premium] [money] NULL,
	[Canx Premium] [money] NULL,
	[Undiscounted Canx Premium] [money] NULL,
	[Rental Car Premium] [money] NULL,
	[Motorcycle Premium] [money] NULL,
	[Luggage Premium] [money] NULL,
	[Medical Premium] [money] NULL,
	[Winter Sport Premium] [money] NULL,
	[Luggage Increase] [money] NULL,
	[Rental Car Increase] [money] NULL,
	[Trip Cost] [int] NULL,
	[Unadjusted Sell Price] [money] NULL,
	[Unadjusted GST on Sell Price] [money] NULL,
	[Unadjusted Stamp Duty on Sell Price] [money] NULL,
	[Unadjusted Agency Commission] [money] NULL,
	[Unadjusted GST on Agency Commission] [money] NULL,
	[Unadjusted Stamp Duty on Agency Commission] [money] NULL,
	[Unadjusted Admin Fee] [money] NULL,
	[Sell Price] [money] NULL,
	[GST on Sell Price] [money] NULL,
	[Stamp Duty on Sell Price] [money] NULL,
	[Premium] [money] NULL,
	[Risk Nett] [money] NULL,
	[GUG] [money] NULL,
	[Agency Commission] [money] NULL,
	[GST on Agency Commission] [money] NULL,
	[Stamp Duty on Agency Commission] [money] NULL,
	[Admin Fee] [money] NULL,
	[NAP] [money] NULL,
	[NAP (incl Tax)] [money] NULL,
	[Policy Count] [int] NULL,
	[Price Beat Policy] [bit] NULL,
	[Competitor Name] [nvarchar](50) NULL,
	[Competitor Price] [money] NULL,
	[PolicyID] [int] NULL,
	[Category] [varchar](100) NOT NULL,
	[EMC Tier Oldest Charged] [int] NULL,
	[EMC Tier Youngest Charged] [int] NULL,
	[Has Cruise] [bit] NULL,
	[Cruise Premium] [money] NULL,
	[Plan Name] [varchar](100) NULL,
 CONSTRAINT [PK_DWHDataSet_20230325] PRIMARY KEY NONCLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_DWHDataSet_BIRowID]    Script Date: 20/02/2025 10:01:18 AM ******/
CREATE CLUSTERED INDEX [idx_DWHDataSet_BIRowID] ON [ws].[DWHDataSet]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DWHDataSet_BasePolicyNo]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx_DWHDataSet_BasePolicyNo] ON [ws].[DWHDataSet]
(
	[Base Policy No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_DWHDataSet_IssueDate]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx_DWHDataSet_IssueDate] ON [ws].[DWHDataSet]
(
	[Issue Date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DWHDataSet_PolicyKey]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx_DWHDataSet_PolicyKey] ON [ws].[DWHDataSet]
(
	[PolicyKey] ASC
)
INCLUDE([TRIPS Policy],[Transaction Type],[Transaction Status],[Issue Date],[Posting Date],[Departure Date],[Return Date],[Has Rental Car],[Has Motorcycle],[Has Wintersport],[Has Medical],[Has Cruise],[Base Base Premium],[Base Premium],[Canx Premium],[Undiscounted Canx Premium],[Rental Car Premium],[Motorcycle Premium],[Luggage Premium],[Medical Premium],[Winter Sport Premium],[Cruise Premium],[Luggage Increase],[Rental Car Increase],[Trip Cost],[Unadjusted Sell Price],[Unadjusted GST on Sell Price],[Unadjusted Stamp Duty on Sell Price],[Unadjusted Agency Commission],[Unadjusted GST on Agency Commission],[Unadjusted Stamp Duty on Agency Commission],[Unadjusted Admin Fee],[Sell Price],[GST on Sell Price],[Stamp Duty on Sell Price],[Premium],[Risk Nett],[GUG],[Agency Commission],[GST on Agency Commission],[Stamp Duty on Agency Commission],[Admin Fee],[NAP],[NAP (incl Tax)],[Policy Count],[Price Beat Policy],[Competitor Name],[Competitor Price],[PolicyID],[PolicyTransactionKey],[Category]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_DWHDataSet_PolicyNo]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx_DWHDataSet_PolicyNo] ON [ws].[DWHDataSet]
(
	[Policy No] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_DWHDataSet_PostingDate]    Script Date: 20/02/2025 10:01:19 AM ******/
CREATE NONCLUSTERED INDEX [idx_DWHDataSet_PostingDate] ON [ws].[DWHDataSet]
(
	[Posting Date] ASC
)
INCLUDE([Domain Country],[Company],[PolicyKey],[PolicyTransactionKey],[Policy No],[Issue Date],[Finance Product Code],[OutletKey],[Alpha Code],[Policy Count],[Sell Price],[Agency Commission],[Premium]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [ws].[DWHDataSet] ADD  DEFAULT ('') FOR [Category]
GO
