USE [db-au-actuary]
GO
/****** Object:  Table [me].[performance_NZ_Aug1]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [me].[performance_NZ_Aug1](
	[JV Code] [nvarchar](20) NULL,
	[Policy Status] [varchar](50) NULL,
	[Issue MMYY] [date] NULL,
	[Return MMYY] [date] NULL,
	[Region Name] [nvarchar](255) NULL,
	[Excess] [int] NULL,
	[Plan Type] [nvarchar](50) NULL,
	[Bdgt Dest] [nvarchar](50) NULL,
	[Channel] [varchar](14) NOT NULL,
	[PPM Group] [varchar](6) NOT NULL,
	[Lead Band] [varchar](24) NOT NULL,
	[Duration Band] [varchar](24) NOT NULL,
	[Age Band] [varchar](18) NOT NULL,
	[UW Premium] [float] NULL,
	[UW Premium COVID19] [float] NULL,
	[ClaimCount] [int] NULL,
	[SectionCount] [int] NULL,
	[NetIncurredMovementIncRecoveries] [numeric](38, 6) NULL,
	[NetPaymentMovementIncRecoveries] [numeric](38, 6) NULL,
	[Sections MED] [int] NULL,
	[Payments MED] [numeric](38, 6) NULL,
	[Incurred MED] [numeric](38, 6) NULL,
	[Sections MED_LGE] [int] NULL,
	[Payments MED_LGE] [numeric](38, 6) NULL,
	[Incurred MED_LGE] [numeric](38, 6) NULL,
	[Sections CAN] [int] NULL,
	[Payments CAN] [numeric](38, 6) NULL,
	[Incurred CAN] [numeric](38, 6) NULL,
	[Sections CAN_LGE] [int] NULL,
	[Payments CAN_LGE] [numeric](38, 6) NULL,
	[Incurred CAN_LGE] [numeric](38, 6) NULL,
	[Sections ADD] [int] NULL,
	[Payments ADD] [numeric](38, 6) NULL,
	[Incurred ADD] [numeric](38, 6) NULL,
	[Sections ADD_LGE] [int] NULL,
	[Payments ADD_LGE] [numeric](38, 6) NULL,
	[Incurred ADD_LGE] [numeric](38, 6) NULL,
	[Sections MIS] [int] NULL,
	[Payments MIS] [numeric](38, 6) NULL,
	[Incurred MIS] [numeric](38, 6) NULL,
	[Sections MIS_LGE] [int] NULL,
	[Payments MIS_LGE] [numeric](38, 6) NULL,
	[Incurred MIS_LGE] [numeric](38, 6) NULL,
	[Sections CAT] [int] NULL,
	[Payments CAT] [numeric](38, 6) NULL,
	[Incurred CAT] [numeric](38, 6) NULL,
	[Sections COV] [int] NULL,
	[Payments COV] [numeric](38, 6) NULL,
	[Incurred COV] [numeric](38, 6) NULL,
	[Sections OTH] [int] NULL,
	[Payments OTH] [numeric](38, 6) NULL,
	[Incurred OTH] [numeric](38, 6) NULL,
	[Premium] [float] NULL,
	[Policy Count] [int] NULL
) ON [PRIMARY]
GO
