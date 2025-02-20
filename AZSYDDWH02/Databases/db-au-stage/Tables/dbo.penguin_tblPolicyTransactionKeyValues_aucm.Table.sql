USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPolicyTransactionKeyValues_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPolicyTransactionKeyValues_aucm](
	[PolicyTransactionId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[Value] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPolicyTransactionKeyValues_aucm_PolicyId]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblPolicyTransactionKeyValues_aucm_PolicyId] ON [dbo].[penguin_tblPolicyTransactionKeyValues_aucm]
(
	[PolicyTransactionId] ASC
)
INCLUDE([TypeId],[Value]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
