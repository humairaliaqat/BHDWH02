USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutlet_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutlet_aucm](
	[OutletId] [int] NOT NULL,
	[SubGroupID] [int] NOT NULL,
	[OutletName] [nvarchar](50) NOT NULL,
	[OutletTypeID] [int] NOT NULL,
	[AlphaCode] [nvarchar](20) NOT NULL,
	[OTPId] [int] NOT NULL,
	[OTCId] [int] NOT NULL,
	[StatusValue] [int] NOT NULL,
	[CommencementDate] [datetime] NULL,
	[CloseDate] [datetime] NULL,
	[PreviousAlpha] [nvarchar](20) NULL,
	[StatusRegion] [int] NULL,
	[DomainId] [int] NOT NULL,
	[StatusReasonComment] [nvarchar](100) NULL,
	[isDefault] [bit] NULL,
	[JointVentureId] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutlet_aucm_OutletID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblOutlet_aucm_OutletID] ON [dbo].[penguin_tblOutlet_aucm]
(
	[OutletId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penguin_tblOutlet_aucm_AlphaCode]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblOutlet_aucm_AlphaCode] ON [dbo].[penguin_tblOutlet_aucm]
(
	[AlphaCode] ASC
)
INCLUDE([OutletId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutlet_aucm_DomainID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblOutlet_aucm_DomainID] ON [dbo].[penguin_tblOutlet_aucm]
(
	[OutletId] ASC
)
INCLUDE([DomainId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
