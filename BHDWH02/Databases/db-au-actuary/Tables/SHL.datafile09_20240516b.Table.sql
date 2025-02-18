USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[datafile09_20240516b]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[datafile09_20240516b](
	[BIRowID] [numeric](20, 0) NULL,
	[Domain_Country] [varchar](2) NULL,
	[Company] [varchar](5) NULL,
	[PolicyKey] [varchar](41) NULL,
	[Base_Policy_No] [varchar](50) NULL,
	[Policy_Status] [varchar](50) NULL,
	[Issue_Date] [datetime] NULL,
	[Posting_Date] [datetime] NULL,
	[Last_Transaction_Issue_Date] [datetime] NULL,
	[Last_Transaction_posting_Date] [datetime] NULL,
	[Transaction_Type] [varchar](50) NULL,
	[Departure_Date] [datetime] NULL,
	[Return_Date] [datetime] NULL,
	[lead_actual] [numeric](11, 0) NULL,
	[Maximum_Trip_Length] [numeric](11, 0) NULL,
	[trip_duration_actual] [numeric](11, 0) NULL,
	[Trip_Length] [numeric](11, 0) NULL,
	[Area_Name] [varchar](150) NULL,
	[Area_Number] [varchar](20) NULL,
	[Destination] [varchar](1024) NULL,
	[Excess] [numeric](11, 0) NULL,
	[Group_Policy] [numeric](11, 0) NULL,
	[Has_Rental_Car] [smallint] NULL,
	[Has_Motorcycle] [smallint] NULL,
	[Has_Wintersport] [smallint] NULL,
	[Has_Medical] [smallint] NULL,
	[Single_Family] [varchar](1) NULL,
	[Purchase_Path] [varchar](50) NULL,
	[TRIPS_Policy] [smallint] NULL,
	[Product_Code] [varchar](50) NULL,
	[Plan_Code] [varchar](50) NULL,
	[Product_Name] [varchar](100) NULL,
	[Product_Plan] [varchar](100) NULL,
	[Product_Type] [varchar](100) NULL,
	[Product_Group] [varchar](100) NULL,
	[Policy_Type] [varchar](50) NULL,
	[Plan_Type] [varchar](50) NULL,
	[Trip_Type] [varchar](50) NULL,
	[Product_Classification] [varchar](100) NULL,
	[Finance_Product_Code] [varchar](50) NULL,
	[OutletKey] [varchar](33) NULL,
	[Alpha_Code] [varchar](20) NULL,
	[Customer_Post_Code] [varchar](50) NULL,
	[Unique_Traveller_Count] [numeric](11, 0) NULL,
	[Unique_Charged_Traveller_Count] [numeric](11, 0) NULL,
	[Traveller_Count] [numeric](11, 0) NULL,
	[Charged_Traveller_Count] [numeric](11, 0) NULL,
	[Adult_Traveller_Count] [numeric](11, 0) NULL,
	[EMC_Traveller_Count] [numeric](11, 0) NULL,
	[Youngest_Charged_DOB] [datetime] NULL,
	[Oldest_Charged_DOB] [datetime] NULL,
	[Youngest_Age] [numeric](11, 0) NULL,
	[Oldest_Age] [numeric](11, 0) NULL,
	[Youngest_Charged_Age] [numeric](11, 0) NULL,
	[Oldest_Charged_Age] [numeric](11, 0) NULL,
	[Max_EMC_Score] [numeric](19, 2) NULL,
	[Total_EMC_Score] [numeric](19, 2) NULL,
	[Gender] [varchar](2) NULL,
	[Has_EMC] [varchar](1) NULL,
	[Has_Manual_EMC] [varchar](1) NULL,
	[Charged_Traveller_1_Gender] [varchar](2) NULL,
	[Charged_Traveller_1_DOB] [varchar](10) NULL,
	[Charged_Traveller_1_Has_EMC] [int] NULL,
	[Charged_Traveller_1_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_1_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_1_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_2_Gender] [varchar](2) NULL,
	[Charged_Traveller_2_DOB] [varchar](10) NULL,
	[Charged_Traveller_2_Has_EMC] [int] NULL,
	[Charged_Traveller_2_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_2_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_2_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_3_Gender] [varchar](2) NULL,
	[Charged_Traveller_3_DOB] [varchar](10) NULL,
	[Charged_Traveller_3_Has_EMC] [int] NULL,
	[Charged_Traveller_3_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_3_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_3_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_4_Gender] [varchar](2) NULL,
	[Charged_Traveller_4_DOB] [varchar](10) NULL,
	[Charged_Traveller_4_Has_EMC] [int] NULL,
	[Charged_Traveller_4_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_4_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_4_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_5_Gender] [varchar](2) NULL,
	[Charged_Traveller_5_DOB] [varchar](10) NULL,
	[Charged_Traveller_5_Has_EMC] [int] NULL,
	[Charged_Traveller_5_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_5_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_5_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_6_Gender] [varchar](2) NULL,
	[Charged_Traveller_6_DOB] [varchar](10) NULL,
	[Charged_Traveller_6_Has_EMC] [int] NULL,
	[Charged_Traveller_6_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_6_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_6_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_7_Gender] [varchar](2) NULL,
	[Charged_Traveller_7_DOB] [varchar](10) NULL,
	[Charged_Traveller_7_Has_EMC] [int] NULL,
	[Charged_Traveller_7_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_7_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_7_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_8_Gender] [varchar](2) NULL,
	[Charged_Traveller_8_DOB] [varchar](10) NULL,
	[Charged_Traveller_8_Has_EMC] [int] NULL,
	[Charged_Traveller_8_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_8_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_8_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_9_Gender] [varchar](2) NULL,
	[Charged_Traveller_9_DOB] [varchar](10) NULL,
	[Charged_Traveller_9_Has_EMC] [int] NULL,
	[Charged_Traveller_9_Has_Manual_E] [smallint] NULL,
	[Charged_Traveller_9_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_9_EMC_Referenc] [numeric](11, 0) NULL,
	[Charged_Traveller_10_Gender] [varchar](2) NULL,
	[Charged_Traveller_10_DOB] [varchar](10) NULL,
	[Charged_Traveller_10_Has_EMC] [int] NULL,
	[Charged_Traveller_10_Has_Manual_] [smallint] NULL,
	[Charged_Traveller_10_EMC_Score] [numeric](19, 2) NULL,
	[Charged_Traveller_10_EMC_Referen] [numeric](11, 0) NULL,
	[Commission_Tier] [varchar](50) NULL,
	[Volume_Commission] [float] NULL,
	[Discount] [float] NULL,
	[Base_Base_Premium] [float] NULL,
	[Base_Premium] [float] NULL,
	[Canx_Premium] [float] NULL,
	[Undiscounted_Canx_Premium] [float] NULL,
	[Rental_Car_Premium] [float] NULL,
	[Motorcycle_Premium] [float] NULL,
	[Luggage_Premium] [float] NULL,
	[Medical_Premium] [float] NULL,
	[Winter_Sport_Premium] [float] NULL,
	[Luggage_Increase] [float] NULL,
	[Trip_Cost] [numeric](11, 0) NULL,
	[Unadjusted_Sell_Price] [float] NULL,
	[Unadjusted_GST_on_Sell_Price] [float] NULL,
	[Unadjusted_Stamp_Duty_on_Sell_Pr] [float] NULL,
	[Unadjusted_Agency_Commission] [float] NULL,
	[Unadjusted_GST_on_Agency_Commiss] [float] NULL,
	[Unadjusted_Stamp_Duty_on_Agency_] [float] NULL,
	[Unadjusted_Admin_Fee] [float] NULL,
	[Sell_Price] [float] NULL,
	[GST_on_Sell_Price] [float] NULL,
	[Stamp_Duty_on_Sell_Price] [float] NULL,
	[Premium] [float] NULL,
	[Risk_Nett] [float] NULL,
	[GUG] [float] NULL,
	[Agency_Commission] [float] NULL,
	[GST_on_Agency_Commission] [float] NULL,
	[Stamp_Duty_on_Agency_Commission] [float] NULL,
	[Admin_Fee] [float] NULL,
	[NAP] [float] NULL,
	[NAP__incl_Tax_] [float] NULL,
	[Policy_Count] [numeric](11, 0) NULL,
	[Price_Beat_Policy] [smallint] NULL,
	[Competitor_Name] [varchar](50) NULL,
	[Competitor_Price] [float] NULL,
	[Category] [varchar](100) NULL,
	[Rental_Car_Increase] [float] NULL,
	[ActuarialPolicyID] [varchar](102) NULL,
	[EMC_Tier_Oldest_Charged] [numeric](11, 0) NULL,
	[EMC_Tier_Youngest_Charged] [numeric](11, 0) NULL,
	[Has_Cruise] [smallint] NULL,
	[Cruise_Premium] [float] NULL,
	[Plan_Name] [varchar](100) NULL,
	[Outlet_Name] [varchar](50) NULL,
	[Outlet_Sub_Group_Code] [varchar](50) NULL,
	[Outlet_Sub_Group_Name] [varchar](50) NULL,
	[Outlet_Group_Code] [varchar](50) NULL,
	[Outlet_Group_Name] [varchar](50) NULL,
	[Outlet_Super_Group] [varchar](255) NULL,
	[Outlet_Channel] [varchar](100) NULL,
	[Outlet_BDM] [varchar](100) NULL,
	[Outlet_Post_Code] [varchar](50) NULL,
	[Outlet_Sales_State_Area] [varchar](50) NULL,
	[Outlet_Trading_Status] [varchar](50) NULL,
	[Outlet_Type] [varchar](50) NULL,
	[Derived_Purchase_Path] [varchar](50) NULL,
	[Derived_Product_Name] [varchar](200) NULL,
	[Derived_Product_Plan] [varchar](200) NULL,
	[Derived_Product_Type] [varchar](200) NULL,
	[Derived_Product_Group] [varchar](200) NULL,
	[Derived_Policy_Type] [varchar](100) NULL,
	[Derived_Plan_Type] [varchar](50) NULL,
	[Derived_Trip_Type] [varchar](50) NULL,
	[Derived_Product_Classification] [varchar](100) NULL,
	[Derived_Finance_Product_Code] [varchar](50) NULL,
	[JV_Code] [varchar](20) NULL,
	[JV_Description] [varchar](100) NULL,
	[Underwriter] [varchar](10) NULL,
	[TripStart] [datetime] NULL,
	[TripEnd] [datetime] NULL,
	[Gross_Premium_Adventure_Activiti] [float] NULL,
	[Gross_Premium_Aged_Cover] [float] NULL,
	[Gross_Premium_Ancillary_Products] [float] NULL,
	[Gross_Premium_Cancel_For_Any_Rea] [float] NULL,
	[Gross_Premium_Cancellation] [float] NULL,
	[Gross_Premium_COVID_19] [float] NULL,
	[Gross_Premium_Cruise] [float] NULL,
	[Gross_Premium_Electronics] [float] NULL,
	[Gross_Premium_Freely_Packs] [float] NULL,
	[Gross_Premium_Luggage] [float] NULL,
	[Gross_Premium_Medical] [float] NULL,
	[Gross_Premium_Motorcycle] [float] NULL,
	[Gross_Premium_Rental_Car] [float] NULL,
	[Gross_Premium_Ticket] [float] NULL,
	[Gross_Premium_Winter_Sport] [float] NULL,
	[UnAdj_Gross_Premium_Adventure_Ac] [float] NULL,
	[UnAdj_Gross_Premium_Aged_Cover] [float] NULL,
	[UnAdj_Gross_Premium_Ancillary_Pr] [float] NULL,
	[UnAdj_Gross_Premium_Cancel_For_A] [float] NULL,
	[UnAdj_Gross_Premium_Cancellation] [float] NULL,
	[UnAdj_Gross_Premium_COVID_19] [float] NULL,
	[UnAdj_Gross_Premium_Cruise] [float] NULL,
	[UnAdj_Gross_Premium_Electronics] [float] NULL,
	[UnAdj_Gross_Premium_Freely_Packs] [float] NULL,
	[UnAdj_Gross_Premium_Luggage] [float] NULL,
	[UnAdj_Gross_Premium_Medical] [float] NULL,
	[UnAdj_Gross_Premium_Motorcycle] [float] NULL,
	[UnAdj_Gross_Premium_Rental_Car] [float] NULL,
	[UnAdj_Gross_Premium_Ticket] [float] NULL,
	[UnAdj_Gross_Premium_Winter_Sport] [float] NULL,
	[Addon_Count_Adventure_Activities] [numeric](11, 0) NULL,
	[Addon_Count_Aged_Cover] [numeric](11, 0) NULL,
	[Addon_Count_Ancillary_Products] [numeric](11, 0) NULL,
	[Addon_Count_Cancel_For_Any_Reaso] [numeric](11, 0) NULL,
	[Addon_Count_Cancellation] [numeric](11, 0) NULL,
	[Addon_Count_COVID_19] [numeric](11, 0) NULL,
	[Addon_Count_Cruise] [numeric](11, 0) NULL,
	[Addon_Count_Electronics] [numeric](11, 0) NULL,
	[Addon_Count_Freely_Packs] [numeric](11, 0) NULL,
	[Addon_Count_Luggage] [numeric](11, 0) NULL,
	[Addon_Count_Medical] [numeric](11, 0) NULL,
	[Addon_Count_Motorcycle] [numeric](11, 0) NULL,
	[Addon_Count_Rental_Car] [numeric](11, 0) NULL,
	[Addon_Count_Ticket] [numeric](11, 0) NULL,
	[Addon_Count_Winter_Sport] [numeric](11, 0) NULL,
	[b] [float] NULL,
	[DateChange] [varchar](1) NULL,
	[cfar_flag] [smallint] NULL,
	[issue_month] [float] NULL,
	[issue_year] [float] NULL,
	[departure_month] [float] NULL,
	[departure_year] [float] NULL,
	[return_month] [float] NULL,
	[return_year] [float] NULL,
	[issue_year_month] [smalldatetime] NULL,
	[departure_year_month] [smalldatetime] NULL,
	[return_year_month] [smalldatetime] NULL,
	[domain_country_jv_description] [varchar](100) NULL,
	[GLM_Region_2024_banded] [varchar](36) NULL,
	[Region] [varchar](31) NULL,
	[GLM_Region_2024] [varchar](46) NULL,
	[UW_Rating_Group] [varchar](19) NULL,
	[JV_Description_Orig] [varchar](8) NULL,
	[JV_Group] [varchar](3) NULL,
	[trip_duration_glm] [smallint] NULL,
	[lead_time_glm] [smallint] NULL,
	[plan_tier_grouped] [varchar](50) NULL,
	[period] [varchar](7) NULL,
	[plan_type_adj] [varchar](50) NULL,
	[adult_traveller_count_capped_4] [float] NULL,
	[trip_cost_adj] [float] NULL,
	[cancellation_group] [varchar](15) NULL,
	[traveller_1_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_2_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_3_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_4_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_5_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_6_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_7_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_8_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_9_emc_score_nonull] [numeric](5, 3) NULL,
	[traveller_10_emc_score_nonull] [numeric](5, 3) NULL,
	[value_temp] [float] NULL,
	[Selectable_Cancellation_Flag] [varchar](1) NULL,
	[value] [float] NULL,
	[uw_EMC_Multiplier] [float] NULL,
	[highest_emc_score] [numeric](5, 3) NULL,
	[highest_emc_banded_no] [float] NULL,
	[highest_EMC_banded] [varchar](17) NULL,
	[Sell_Price_Trav] [float] NULL,
	[Ticket_Band] [varchar](4) NULL,
	[Segment] [varchar](20) NULL,
	[Segment2] [varchar](20) NULL
) ON [PRIMARY]
GO
