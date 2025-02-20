USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPaymentRegisterTransaction]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPaymentRegisterTransaction](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PaymentRegisterTransactionKey] [varchar](41) NULL,
	[PaymentRegisterKey] [varchar](41) NULL,
	[PaymentAllocationKey] [varchar](41) NULL,
	[PaymentRegisterTransactionID] [int] NOT NULL,
	[PaymentRegisterID] [int] NOT NULL,
	[PaymentAllocationID] [int] NULL,
	[Payer] [varchar](50) NULL,
	[BankDate] [datetime] NULL,
	[BankDateUTC] [date] NULL,
	[BSB] [varchar](10) NULL,
	[ChequeNumber] [varchar](30) NULL,
	[Amount] [money] NOT NULL,
	[AmountType] [varchar](15) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[Comment] [varchar](500) NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[CreditNoteDepartmentID] [int] NULL,
	[CreditNoteDepartmentName] [varchar](55) NULL,
	[CreditNoteDepartmentCode] [varchar](3) NULL,
	[JointVentureID] [int] NULL,
	[JVCode] [varchar](10) NULL,
	[JVDescription] [varchar](55) NULL
) ON [PRIMARY]
GO
