USE [db-au-cba]
GO
/****** Object:  Table [dbo].[cbMedicalCodingType]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cbMedicalCodingType](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Tag] [varchar](100) NULL,
	[Type] [nvarchar](300) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_cbMedicalCodingType_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_cbMedicalCodingType_BIRowID] ON [dbo].[cbMedicalCodingType]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_cbMedicalCodingType_Tag]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_cbMedicalCodingType_Tag] ON [dbo].[cbMedicalCodingType]
(
	[Tag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
