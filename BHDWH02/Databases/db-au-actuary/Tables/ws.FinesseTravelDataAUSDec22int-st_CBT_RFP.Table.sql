USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSDec22int-st_CBT_RFP]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSDec22int-st_CBT_RFP](
	[Sample Number] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[ExcessAPC] [varchar](50) NULL,
	[ExcessAHM] [varchar](50) NULL,
	[ExcessMBC] [varchar](50) NULL,
	[ExcessCBT] [varchar](50) NULL,
	[ExcessCBE] [varchar](50) NULL,
	[CanxInt_STAPC] [varchar](50) NULL,
	[CanxInt_STAHM] [varchar](50) NULL,
	[CanxInt_STMBC] [varchar](50) NULL,
	[CanxInt_STCBT] [varchar](50) NULL,
	[CanxInt_STCBE] [varchar](50) NULL,
	[CBE_BaseSP] [varchar](50) NULL,
	[CBE_CanxSP] [varchar](50) NULL,
	[CBE_SP] [varchar](50) NULL,
	[CBT_BaseSP] [varchar](50) NULL,
	[CBT_CanxSP] [varchar](50) NULL,
	[CBT_SP] [varchar](50) NULL,
	[CBA_Ess_New] [varchar](50) NULL,
	[CBA_Comp_New] [varchar](50) NULL
) ON [PRIMARY]
GO
