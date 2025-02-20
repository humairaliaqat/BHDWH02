USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[tmp_cba_dns_impact]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_cba_dns_impact](
	[Day of Week] [nvarchar](30) NULL,
	[Hour] [nvarchar](33) NULL,
	[Date Time] [datetime] NULL,
	[Session Count] [bigint] NULL,
	[Policy Count] [bigint] NULL
) ON [PRIMARY]
GO
