USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrPublicHoliday_Claims]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrPublicHoliday_Claims](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[Date] [date] NULL,
	[Description] [varchar](100) NULL,
	[StateLocation] [varchar](100) NULL,
	[DomainCountry] [varchar](5) NULL,
	[isHoliday] [int] NULL
) ON [PRIMARY]
GO
