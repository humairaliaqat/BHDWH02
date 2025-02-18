USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_TravellerPolicyPrice]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_TravellerPolicyPrice](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[quoteID] [nvarchar](50) NULL,
	[sessionID] [nvarchar](50) NULL,
	[grossPrice] [nvarchar](50) NULL,
	[baseNet] [nvarchar](50) NULL,
	[isDiscount] [nvarchar](50) NULL,
	[discountRate] [nvarchar](50) NULL,
	[displayPrice] [nvarchar](50) NULL,
	[discountedGross] [nvarchar](50) NULL,
	[grossEmc] [nvarchar](50) NULL,
	[isDiscountEmc] [nvarchar](50) NULL,
	[discountRateEmc] [nvarchar](50) NULL,
	[displayPriceEmc] [nvarchar](50) NULL,
	[discountedGrossEmc] [nvarchar](50) NULL,
	[acceptedEmc] [nvarchar](50) NULL,
	[assessmentIDEmc] [nvarchar](50) NULL,
	[age] [nvarchar](50) NULL,
	[gender] [nvarchar](50) NULL,
	[isAdult] [nvarchar](50) NULL,
	[lastName] [nvarchar](50) NULL,
	[memberId] [nvarchar](50) NULL,
	[firstName] [nvarchar](50) NULL,
	[isPrimary] [nvarchar](50) NULL,
	[chargeRate] [nvarchar](50) NULL,
	[dateOfBirth] [nvarchar](50) NULL,
	[identifier] [nvarchar](50) NULL,
	[isChargeable] [nvarchar](50) NULL,
	[treatAsAdult] [nvarchar](50) NULL,
	[acceptedOffer] [nvarchar](50) NULL,
	[isPlaceholderAge] [nvarchar](50) NULL,
	[unroundedGross] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_impulse_TravellerPolicyPrice_SrcRowID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE CLUSTERED INDEX [idx_impulse_TravellerPolicyPrice_SrcRowID] ON [dbo].[impulse_TravellerPolicyPrice]
(
	[SrcRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_TravellerPolicyPrice_quoteID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_TravellerPolicyPrice_quoteID] ON [dbo].[impulse_TravellerPolicyPrice]
(
	[quoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
