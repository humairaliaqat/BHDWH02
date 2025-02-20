USE [db-au-cba]
GO
/****** Object:  Table [dbo].[clmBenefit]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[clmBenefit](
	[CountryKey] [varchar](2) NOT NULL,
	[BenefitSectionKey] [varchar](40) NULL,
	[BenefitSectionID] [int] NOT NULL,
	[BenefitCode] [nvarchar](25) NULL,
	[BenefitDesc] [nvarchar](255) NULL,
	[ProductCode] [nvarchar](5) NULL,
	[BenefitValidFrom] [datetime] NULL,
	[BenefitValidTo] [datetime] NULL,
	[BenefitLimit] [money] NULL,
	[PrintOrder] [smallint] NULL,
	[CommonCategory] [nvarchar](25) NULL,
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateBatchID] [int] NULL,
	[UpdateBatchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_clmBenefit_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_clmBenefit_BIRowID] ON [dbo].[clmBenefit]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmBenefit_BenefitSectionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmBenefit_BenefitSectionKey] ON [dbo].[clmBenefit]
(
	[BenefitSectionKey] ASC
)
INCLUDE([BenefitCode],[BenefitDesc],[CountryKey],[CommonCategory],[ProductCode],[BenefitValidFrom],[BenefitValidTo],[BenefitLimit]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_clmBenefit_ProductCode]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_clmBenefit_ProductCode] ON [dbo].[clmBenefit]
(
	[ProductCode] ASC,
	[BenefitValidFrom] ASC,
	[BenefitValidTo] ASC
)
INCLUDE([BenefitCode],[BenefitDesc],[BenefitLimit],[BenefitSectionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
