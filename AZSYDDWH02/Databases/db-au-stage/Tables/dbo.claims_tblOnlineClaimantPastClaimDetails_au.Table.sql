USE [db-au-stage]
GO
/****** Object:  Table [dbo].[claims_tblOnlineClaimantPastClaimDetails_au]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[claims_tblOnlineClaimantPastClaimDetails_au](
	[PastClaimId] [int] NOT NULL,
	[ClaimantId] [int] NOT NULL,
	[Details] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_claims_tblOnlineClaimantPastClaimDetails_au_id]    Script Date: 20/02/2025 10:25:21 AM ******/
CREATE CLUSTERED INDEX [idx_claims_tblOnlineClaimantPastClaimDetails_au_id] ON [dbo].[claims_tblOnlineClaimantPastClaimDetails_au]
(
	[ClaimantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
