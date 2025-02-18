USE [db-au-actuary]
GO
/****** Object:  Table [ws].[FinesseTravelDataAUSMar22int-st_CMplus_FYPICCnew]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ws].[FinesseTravelDataAUSMar22int-st_CMplus_FYPICCnew](
	[Period] [varchar](50) NULL,
	[Sample Number] [varchar](50) NULL,
	[Factor] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Destination] [varchar](50) NULL,
	[GeoZone] [varchar](50) NULL,
	[PlanType] [varchar](50) NULL,
	[Number of Travellers] [varchar](50) NULL,
	[Travel Group] [varchar](50) NULL,
	[Number of Adults] [varchar](50) NULL,
	[Number of Children] [varchar](50) NULL,
	[Age of oldest adult] [varchar](50) NULL,
	[Age of second oldest adult] [varchar](50) NULL,
	[Age of oldest dependent] [varchar](50) NULL,
	[Age of second oldest dependent] [varchar](50) NULL,
	[Age of third oldest dependent] [varchar](50) NULL,
	[age0order] [varchar](50) NULL,
	[age1order] [varchar](50) NULL,
	[age2order] [varchar](50) NULL,
	[age3order] [varchar](50) NULL,
	[age4order] [varchar](50) NULL,
	[Travel Duration] [varchar](50) NULL,
	[Destination Region] [varchar](50) NULL,
	[Lead Time] [varchar](50) NULL,
	[Profile] [varchar](50) NULL,
	[Travel Group Detailed] [varchar](50) NULL,
	[Age of oldest adult - Band] [varchar](50) NULL,
	[Age of second oldest adult - Band] [varchar](50) NULL,
	[Age of oldest dependent - Band] [varchar](50) NULL,
	[Age of second oldest dependent - Band] [varchar](50) NULL,
	[Age of third oldest dependent - Band] [varchar](50) NULL,
	[Travel Duration - Band] [varchar](50) NULL,
	[Lead time - Band] [varchar](50) NULL,
	[TripType] [varchar](50) NULL,
	[Age of oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Age of second oldest adult (Detailed) - Band] [varchar](50) NULL,
	[Travel Duration (Detailed) - Band] [varchar](50) NULL,
	[ExcessFYP] [varchar](50) NULL,
	[ExcessICC] [varchar](50) NULL,
	[ExcessCPC] [varchar](50) NULL,
	[CanxInt_STFYP] [varchar](50) NULL,
	[CanxInt_STICC] [varchar](50) NULL,
	[CanxInt_STCPC] [varchar](50) NULL,
	[FYP_BaseSP] [varchar](50) NULL,
	[FYP_CanxSP] [varchar](50) NULL,
	[FYP_SP] [varchar](50) NULL,
	[ICC_BaseSP] [varchar](50) NULL,
	[ICC_CanxSP] [varchar](50) NULL,
	[ICC_SP] [varchar](50) NULL,
	[CPC_BaseSP] [varchar](50) NULL,
	[CPC_CanxSP] [varchar](50) NULL,
	[CPC_SP] [varchar](50) NULL
) ON [PRIMARY]
GO
