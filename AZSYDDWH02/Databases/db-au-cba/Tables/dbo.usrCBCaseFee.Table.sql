USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrCBCaseFee]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrCBCaseFee](
	[BIRowID] [bigint] NOT NULL,
	[CountryKey] [varchar](2) NULL,
	[ClientCode] [varchar](2) NULL,
	[ProgramCode] [varchar](2) NULL,
	[FeeDescription] [varchar](100) NULL,
	[BusinessUnit] [varchar](50) NULL,
	[DebtorsCode] [varchar](30) NULL,
	[Quotation] [varchar](50) NULL,
	[SimpleMedicalCaseFee] [money] NOT NULL,
	[SimpleTechnicalCaseFee] [money] NOT NULL,
	[MediumMedicalCaseFee] [money] NOT NULL,
	[MediumTechnicalCaseFee] [money] NOT NULL,
	[ComplexMedicalCaseFee] [money] NOT NULL,
	[ComplexTechnicalCaseFee] [money] NOT NULL,
	[EvacuationCaseFee] [money] NOT NULL,
	[GST] [numeric](5, 2) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_usrCBCaseFee_ClientCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_usrCBCaseFee_ClientCode] ON [dbo].[usrCBCaseFee]
(
	[ClientCode] ASC,
	[ProgramCode] ASC,
	[CountryKey] ASC
)
INCLUDE([DebtorsCode],[SimpleMedicalCaseFee],[SimpleTechnicalCaseFee],[MediumMedicalCaseFee],[MediumTechnicalCaseFee],[ComplexMedicalCaseFee],[ComplexTechnicalCaseFee],[EvacuationCaseFee],[GST]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
