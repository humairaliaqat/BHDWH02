USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_audit_claims_payment_firstoccur]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_audit_claims_payment_firstoccur](
	[AuditKey] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
