USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbPolicy]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbPolicy](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [nvarchar](2) NOT NULL,
	[CaseKey] [nvarchar](20) NOT NULL,
	[TRIPSPolicyKey] [nvarchar](41) NULL,
	[PolicyTransactionKey] [nvarchar](41) NULL,
	[CaseNo] [nvarchar](15) NOT NULL,
	[IsMainPolicy] [bit] NOT NULL,
	[PolicyNo] [nvarchar](25) NULL,
	[IssueDate] [datetime] NULL,
	[ExpiryDate] [datetime] NULL,
	[VerifyDate] [datetime] NULL,
	[VerifiedBy] [nvarchar](10) NULL,
	[ConsultantInitial] [nvarchar](30) NULL,
	[PolicyType] [nvarchar](25) NULL,
	[SingleFamily] [nvarchar](15) NULL,
	[PlanCode] [nvarchar](15) NULL,
	[DepartureDate] [datetime] NULL,
	[InsurerName] [nvarchar](20) NULL,
	[Excess] [int] NULL,
	[ProductCode] [nvarchar](3) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbPolicy_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbPolicy_BIRowID] ON [dbo].[cbPolicy]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbPolicy_CaseKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbPolicy_CaseKey] ON [dbo].[cbPolicy]
(
	[CaseKey] ASC,
	[IsMainPolicy] ASC,
	[PolicyNo] ASC
)
INCLUDE([PolicyTransactionKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbPolicy_PolicyTransactionKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbPolicy_PolicyTransactionKey] ON [dbo].[cbPolicy]
(
	[PolicyTransactionKey] ASC,
	[CaseKey] ASC
)
INCLUDE([PolicyNo],[CaseNo]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
