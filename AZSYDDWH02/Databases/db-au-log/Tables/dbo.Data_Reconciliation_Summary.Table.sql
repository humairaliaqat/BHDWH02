USE [db-au-log]
GO
/****** Object:  Table [dbo].[Data_Reconciliation_Summary]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Data_Reconciliation_Summary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MetadataID] [int] NULL,
	[CountryCode] [varchar](10) NULL,
	[Source1Value] [numeric](16, 2) NULL,
	[Source2Value] [numeric](16, 2) NULL,
	[Source3Value] [numeric](16, 2) NULL,
	[Date] [date] NULL,
	[Valid] [tinyint] NULL,
	[InsertDatetime] [datetime2](7) NULL,
	[UpdateDatetime] [datetime2](7) NULL,
	[Comment] [varchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
