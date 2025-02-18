USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[Batch_Run_Status]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Batch_Run_Status](
	[Batch_ID] [int] IDENTITY(1,1) NOT NULL,
	[Batch_Date] [date] NOT NULL,
	[Batch_Start_Time] [datetime] NOT NULL,
	[Batch_Status] [varchar](10) NOT NULL,
	[Batch_End_Time] [datetime] NULL,
	[Subject_Area] [varchar](50) NOT NULL,
	[Batch_To_Date] [date] NULL,
 CONSTRAINT [pk_BatchID] PRIMARY KEY CLUSTERED 
(
	[Batch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX01_Batch_Run_Status]    Script Date: 18/02/2025 12:59:40 PM ******/
CREATE NONCLUSTERED INDEX [IX01_Batch_Run_Status] ON [dbo].[Batch_Run_Status]
(
	[Subject_Area] ASC
)
INCLUDE([Batch_ID],[Batch_Date],[Batch_To_Date],[Batch_Status]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
