USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_Quote]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_Quote](
	[SrcRowID] [bigint] IDENTITY(0,1) NOT NULL,
	[sessionID] [nvarchar](max) NULL,
	[quoteID] [nvarchar](50) NULL,
	[tripRegionID] [nvarchar](50) NULL,
	[id] [nvarchar](50) NULL,
	[tripCost] [nvarchar](50) NULL,
	[endDate] [nvarchar](50) NULL,
	[regionID] [nvarchar](50) NULL,
	[regionName] [nvarchar](50) NULL,
	[regionSiteID] [nvarchar](50) NULL,
	[regionAreaCode] [nvarchar](50) NULL,
	[regionRiskRank] [nvarchar](50) NULL,
	[regionHealixCode] [nvarchar](50) NULL,
	[regionDestinationType] [nvarchar](50) NULL,
	[regionCountries] [nvarchar](4000) NULL,
	[startDate] [nvarchar](50) NULL,
	[departureAirportCodes] [nvarchar](4000) NULL,
	[departureCountryCodes] [nvarchar](4000) NULL,
	[destinationAirportCodes] [nvarchar](4000) NULL,
	[destinationCountryCodes] [nvarchar](4000) NULL,
	[excess] [nvarchar](50) NULL,
	[duration] [nvarchar](50) NULL,
	[quoteRegionID] [nvarchar](50) NULL,
	[productID] [nvarchar](50) NULL,
	[grossPolicyPrice] [nvarchar](50) NULL,
	[isDiscountPolicyPrice] [nvarchar](50) NULL,
	[discountRatePolicyPrice] [nvarchar](50) NULL,
	[displayPricePolicyPrice] [nvarchar](50) NULL,
	[discountedGrossPolicyPrice] [nvarchar](50) NULL,
	[token] [nvarchar](50) NULL,
	[consultant] [nvarchar](50) NULL,
	[affiliateCode] [nvarchar](50) NULL,
	[culture] [nvarchar](50) NULL,
	[isClosed] [nvarchar](50) NULL,
	[channelID] [nvarchar](50) NULL,
	[quoteDate] [nvarchar](50) NULL,
	[campaignID] [nvarchar](50) NULL,
	[promoCodes] [nvarchar](50) NULL,
	[isPurchased] [nvarchar](50) NULL,
	[businessUnitID] [nvarchar](50) NULL,
	[chargeRegionID] [nvarchar](50) NULL,
	[createdDateTime] [nvarchar](50) NULL,
	[appliedPromoCodes] [nvarchar](50) NULL,
	[chargeCountryCode] [nvarchar](50) NULL,
	[lastTransactionTime] [nvarchar](50) NULL,
	[partnerTransactionID] [nvarchar](50) NULL,
	[email] [nvarchar](255) NULL,
	[city] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[suburb] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[street1] [nvarchar](255) NULL,
	[street2] [nvarchar](255) NULL,
	[postCode] [nvarchar](50) NULL,
	[optInMarketing] [nvarchar](50) NULL,
	[datePayment] [nvarchar](50) NULL,
	[amountPayment] [nvarchar](50) NULL,
	[paymentType] [nvarchar](50) NULL,
	[ReferenceNumber] [nvarchar](50) NULL,
	[policies] [nvarchar](4000) NULL,
	[accrualRate] [nvarchar](50) NULL,
	[pointsAccrued] [nvarchar](50) NULL,
	[transactionTime] [datetime] NULL,
	[batchID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [idx_impulse_Quote_SrcRowID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE CLUSTERED INDEX [idx_impulse_Quote_SrcRowID] ON [dbo].[impulse_Quote]
(
	[SrcRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_impulse_Quote_quoteID]    Script Date: 18/02/2025 11:53:55 AM ******/
CREATE NONCLUSTERED INDEX [idx_impulse_Quote_quoteID] ON [dbo].[impulse_Quote]
(
	[quoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
GO
