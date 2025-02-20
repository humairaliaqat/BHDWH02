USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_tblOnlineClaims_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_tblOnlineClaims_au](
	[OnlineClaimId] [int] NOT NULL,
	[ClaimId] [int] NULL,
	[PrimaryClaimantId] [int] NULL,
	[ClaimCauseId] [int] NULL,
	[ClaimFormDetailId] [int] NULL,
	[DeclarationId] [int] NULL,
	[LatestStep] [int] NULL,
	[UpdatedOn] [datetime] NULL,
	[UserId] [int] NULL,
	[AlphaCode] [nvarchar](20) NULL,
	[ConsultantName] [nvarchar](50) NULL,
	[KLDOMAINID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[LastUpdatedBy] [nvarchar](200) NULL,
	[IsMoreDocument] [bit] NULL,
	[DocumentDescription] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_tblOnlineClaims_au_eid]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_tblOnlineClaims_au_eid] ON [dbo].[claims_tblOnlineClaims_au]
(
	[ClaimCauseId] ASC
)
INCLUDE([OnlineClaimId],[ClaimId],[KLDOMAINID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_tblOnlineClaims_au_id]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_claims_tblOnlineClaims_au_id] ON [dbo].[claims_tblOnlineClaims_au]
(
	[ClaimId] ASC
)
INCLUDE([AlphaCode],[ConsultantName],[OnlineClaimId],[ClaimCauseId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
