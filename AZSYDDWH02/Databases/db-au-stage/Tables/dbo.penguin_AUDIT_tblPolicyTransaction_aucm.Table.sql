USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_AUDIT_tblPolicyTransaction_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_AUDIT_tblPolicyTransaction_aucm](
	[AUDIT_USERNAME] [varchar](255) NULL,
	[AUDIT_RECORDTYPE] [varchar](255) NULL,
	[AUDIT_DATETIME] [datetime] NULL,
	[AUDIT_tblPolicyTransaction_ID] [int] NOT NULL,
	[ID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[TripsPolicyNumber] [varchar](25) NULL,
	[TransactionType] [int] NOT NULL,
	[GrossPremium] [money] NOT NULL,
	[IssueDate] [datetime] NOT NULL,
	[AccountingPeriod] [datetime] NOT NULL,
	[CRMUserID] [int] NULL,
	[TransactionStatus] [int] NOT NULL,
	[Transferred] [bit] NOT NULL,
	[UserComments] [nvarchar](1000) NULL,
	[CommissionTier] [varchar](50) NULL,
	[VolumeCommission] [numeric](18, 9) NULL,
	[Discount] [numeric](18, 9) NULL,
	[IsExpo] [bit] NOT NULL,
	[IsPriceBeat] [bit] NOT NULL,
	[NoOfBonusDaysApplied] [int] NULL,
	[IsAgentSpecial] [bit] NOT NULL,
	[ParentID] [int] NULL,
	[ConsultantID] [int] NULL,
	[IsClientCall] [bit] NULL,
	[RiskNet] [money] NULL,
	[AutoComments] [nvarchar](2000) NULL,
	[TripCost] [nvarchar](50) NULL,
	[AllocationNumber] [int] NULL,
	[PaymentDate] [datetime] NULL,
	[TransactionStart] [datetime] NULL,
	[TransactionEnd] [datetime] NULL,
	[StoreCode] [varchar](10) NULL,
	[TotalCommission] [money] NULL,
	[TotalNet] [money] NULL,
	[TransactionDateTime] [datetime] NULL,
	[PaymentMode] [nvarchar](20) NULL,
	[IssuingConsultantId] [int] NOT NULL,
	[GigyaId] [nvarchar](300) NULL,
	[LeadTimeDate] [date] NOT NULL,
	[RefundTransactionId] [int] NULL
) ON [PRIMARY]
GO
