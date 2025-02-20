USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimExcess]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimExcess](
	[ExcessSK] [bigint] IDENTITY(1,1) NOT NULL,
	[Excess] [decimal](16, 2) NULL,
	[ExcessString] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimExcess_ExcessSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE UNIQUE CLUSTERED INDEX [idx_dimExcess_ExcessSK] ON [dbo].[dimExcess]
(
	[ExcessSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimExcess_Excess]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimExcess_Excess] ON [dbo].[dimExcess]
(
	[Excess] ASC
)
INCLUDE([ExcessString]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
