USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_Penguin]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_StagingIndex_Penguin]
as
begin
/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20130810 - LS - performance fix
20130812 - LS - further performance fixes
20140620 - LS - TFS 12416 & 12623, new column references
20150601 - LS - TFS 16953, Penguin 14.0
20160318 - LT - Penguin 18.0 release, added US penguin instance
*/

    set nocount on

    --AU CM
    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblReferenceValue_aucm_ID')
        create clustered index idx_penguin_tblReferenceValue_aucm_ID on penguin_tblReferenceValue_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblDomain_aucm_DomainID')
        create clustered index idx_penguin_tblDomain_aucm_DomainID on penguin_tblDomain_aucm(DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_aucm_OutletID')
        create clustered index idx_penguin_tblOutlet_aucm_OutletID on penguin_tblOutlet_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_aucm_DomainID')
        create index idx_penguin_tblOutlet_aucm_DomainID on penguin_tblOutlet_aucm(OutletID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_aucm_PolicyID')
        create clustered index idx_penguin_tblPolicy_aucm_PolicyID on penguin_tblPolicy_aucm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_aucm_DomainID')
        create index idx_penguin_tblPolicy_aucm_DomainID on penguin_tblPolicy_aucm(PolicyID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyDetails_aucm_PolicyID')
        create clustered index idx_penguin_tblPolicyDetails_aucm_PolicyID on penguin_tblPolicyDetails_aucm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_aucm_ID')
        create clustered index idx_penguin_tblPolicyTransaction_aucm_ID on penguin_tblPolicyTransaction_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_aucm_PolicyID')
        create index idx_penguin_tblPolicyTransaction_aucm_PolicyID on penguin_tblPolicyTransaction_aucm(PolicyID) include (TripCost)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_aucm_DomainID')
        create index idx_penguin_tblPolicyTransaction_aucm_DomainID on penguin_tblPolicyTransaction_aucm(ID) include (PolicyID, CRMUserID, ConsultantID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_aucm_QuoteID')
        create clustered index idx_penguin_tblQuote_aucm_QuoteID on penguin_tblQuote_aucm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_aucm_DomainID')
        create index idx_penguin_tblQuote_aucm_DomainID on penguin_tblQuote_aucm(QuoteID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPromo_aucm_PromoID')
        create clustered index idx_penguin_tblPromo_aucm_PromoID on penguin_tblPromo_aucm(PromoID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionType_aucm_ID')
        create clustered index idx_penguin_tblPolicyTransactionType_aucm_ID on penguin_tblPolicyTransactionType_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_aucm_ID')
        create clustered index idx_penguin_tblCRMUser_aucm_ID on penguin_tblCRMUser_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_aucm_UserName')
        create index idx_penguin_tblCRMUser_aucm_UserName on penguin_tblCRMUser_aucm(ID) include (UserName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionStatus_aucm_ID')
        create clustered index idx_penguin_tblPolicyTransactionStatus_aucm_ID on penguin_tblPolicyTransactionStatus_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionPromo_aucm_PolicyTransactionID')
        create clustered index idx_penguin_tblPolicyTransactionPromo_aucm_PolicyTransactionID on penguin_tblPolicyTransactionPromo_aucm(PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_aucm_QuotePlanID')
        create index idx_penguin_tblPolicy_aucm_QuotePlanID on penguin_tblPolicy_aucm(QuotePlanID) include (PolicyNumber, PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_aucm_QuoteID')
        create clustered index idx_penguin_tblQuotePlan_aucm_QuoteID on penguin_tblQuotePlan_aucm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_aucm_GrossPremium')
        create index idx_penguin_tblQuotePlan_aucm_GrossPremium on penguin_tblQuotePlan_aucm(QuoteID) include (GrossPremium, ProductCode, QuotePlanID, IsSelected)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlanPromo_aucm_QuotePlanID')
        create clustered index idx_penguin_tblQuotePlanPromo_aucm_QuotePlanID on penguin_tblQuotePlanPromo_aucm(QuotePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_aucm_QuoteCustomerID')
        create clustered index idx_penguin_tblQuoteCustomer_aucm_QuoteCustomerID on penguin_tblQuoteCustomer_aucm(QuoteCustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_aucm_CustomerID')
        create index idx_penguin_tblQuoteCustomer_aucm_CustomerID on penguin_tblQuoteCustomer_aucm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletContactInfo_aucm_OutletID')
        create clustered index idx_penguin_tblOutletContactInfo_aucm_OutletID on penguin_tblOutletContactInfo_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFinancialInfo_aucm_OutletID')
        create clustered index idx_penguin_tblOutletFinancialInfo_aucm_OutletID on penguin_tblOutletFinancialInfo_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFSRInfo_aucm_OutletID')
        create clustered index idx_penguin_tblOutletFSRInfo_aucm_OutletID on penguin_tblOutletFSRInfo_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletManagerInfo_aucm_OutletID')
        create clustered index idx_penguin_tblOutletManagerInfo_aucm_OutletID on penguin_tblOutletManagerInfo_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletShopInfo_aucm_OutletID')
        create clustered index idx_penguin_tblOutletShopInfo_aucm_OutletID on penguin_tblOutletShopInfo_aucm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblSubGroup_aucm_ID')
        create clustered index idx_penguin_tblSubGroup_aucm_ID on penguin_tblSubGroup_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblGroup_aucm_ID')
        create clustered index idx_penguin_tblGroup_aucm_ID on penguin_tblGroup_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletType_aucm_OutletTypeID')
        create clustered index idx_penguin_tblOutletType_aucm_OutletTypeID on penguin_tblOutletType_aucm(OutletTypeID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAddonValue_aucm_AddOnValueID')
        create clustered index idx_penguin_tblAddonValue_aucm_AddOnValueID on penguin_tblAddonValue_aucm(AddOnValueID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyAddon_aucm_ID')
        create clustered index idx_penguin_tblPolicyAddon_aucm_ID on penguin_tblPolicyAddon_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_aucm_ID')
        create clustered index idx_penguin_tblPolicyTravellerTransaction_aucm_ID on penguin_tblPolicyTravellerTransaction_aucm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_aucm_PolicyTransactionID')
        create index idx_penguin_tblPolicyTravellerTransaction_aucm_PolicyTransactionID on penguin_tblPolicyTravellerTransaction_aucm(ID) include (PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_aucm_UserID')
        create clustered index idx_penguin_tblUser_aucm_UserID on penguin_tblUser_aucm(UserID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_aucm_DomainID')
        create index idx_penguin_tblUser_aucm_DomainID on penguin_tblUser_aucm(UserID) include (OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_aucm_AlphaCode')
        create index idx_penguin_tblOutlet_aucm_AlphaCode on penguin_tblOutlet_aucm(AlphaCode) include (OutletId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_aucm_Login')
        create index idx_penguin_tblUser_aucm_Login on penguin_tblUser_aucm(Login, OutletID) include (FirstName, LastName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCustomer_aucm_CustomerID')
        create clustered index idx_penguin_tblCustomer_aucm_CustomerID on penguin_tblCustomer_aucm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitTransaction_aucm_BenefitID')
        create clustered index idx_penguin_tblAdditionalBenefitTransaction_aucm_BenefitID on penguin_tblAdditionalBenefitTransaction_aucm(BenefitID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitDetails_aucm_ABTId')
        create clustered index idx_penguin_tblAdditionalBenefitDetails_aucm_ABTId on penguin_tblAdditionalBenefitDetails_aucm(AdditionalBenefitTransactionId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyEMC_aucm_PolicyTravellerTransactionID')
        create nonclustered index idx_penguin_tblPolicyEMC_aucm_PolicyTravellerTransactionID on penguin_tblPolicyEMC_aucm (PolicyTravellerTransactionID) include (EMCRef, EMCScore, AddOnId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlan_aucm_UniquePlanID')
        create clustered index idx_penguin_tblPlan_aucm_UniquePlanID on penguin_tblPlan_aucm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlanArea_aucm_PlanID')
        create clustered index idx_penguin_tblPlanArea_aucm_PlanID on penguin_tblPlanArea_aucm(PlanID, AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblArea_aucm_AreaID')
        create clustered index idx_penguin_tblArea_aucm_AreaID on penguin_tblArea_aucm(AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblquotesave_aucm_QuoteID')
        create clustered index idx_penguin_tblquotesave_aucm_QuoteID on penguin_tblquotesave_aucm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlan_aucm_OutletProductID')
        create index idx_penguin_tblOutlet_ProductPlan_aucm_OutletProductID on penguin_tblOutlet_ProductPlan_aucm(OutletProductID) include (UniquePlanID, ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_Product_aucm_OutletID')
        create index idx_penguin_tblOutlet_Product_aucm_OutletID on penguin_tblOutlet_Product_aucm(ID) include(OutletID, CommissionTierID, VolumeCommission, Discount, ProductPricingTierID, DeclarationSetID, IsStocked)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlanSettings_aucm_OutletProductPlanID')
        create index idx_penguin_tblOutlet_ProductPlanSettings_aucm_OutletProductPlanID on penguin_tblOutlet_ProductPlanSettings_aucm(OutletProductPlanID) include(DefaultExcess, MaxAdminFee, IsUpsell)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblProduct_aucm_ProductID')
        create clustered index idx_penguin_tblProduct_aucm_ProductID on penguin_tblProduct_aucm(ProductID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_Product_aucm_OTPId')
        create clustered index idx_penguin_tblOTP_Product_aucm_OTPId on penguin_tblOTP_Product_aucm(OTPId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_PlanProduct_aucm_UniquePlanID')
        create index idx_penguin_tblOTP_PlanProduct_aucm_UniquePlanID on penguin_tblOTP_PlanProduct_aucm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValueTypes_aucm_ID')
        create nonclustered index idx_penguin_tblPolicyKeyValueTypes_aucm_ID on penguin_tblPolicyKeyValueTypes_aucm(ID,Code)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValues_aucm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyKeyValues_aucm_PolicyId on penguin_tblPolicyKeyValues_aucm(PolicyId) include(TypeId,Value)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionKeyValues_aucm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyTransactionKeyValues_aucm_PolicyId on penguin_tblPolicyTransactionKeyValues_aucm(PolicyTransactionId) include(TypeId,Value)
        
    --AU TIP
    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblReferenceValue_autp_ID')
        create clustered index idx_penguin_tblReferenceValue_autp_ID on penguin_tblReferenceValue_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblDomain_autp_DomainID')
        create clustered index idx_penguin_tblDomain_autp_DomainID on penguin_tblDomain_autp(DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_autp_OutletID')
        create clustered index idx_penguin_tblOutlet_autp_OutletID on penguin_tblOutlet_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_autp_DomainID')
        create index idx_penguin_tblOutlet_autp_DomainID on penguin_tblOutlet_autp(OutletID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_autp_PolicyID')
        create clustered index idx_penguin_tblPolicy_autp_PolicyID on penguin_tblPolicy_autp(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_autp_DomainID')
        create index idx_penguin_tblPolicy_autp_DomainID on penguin_tblPolicy_autp(PolicyID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyDetails_autp_PolicyID')
        create clustered index idx_penguin_tblPolicyDetails_autp_PolicyID on penguin_tblPolicyDetails_autp(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_autp_ID')
        create clustered index idx_penguin_tblPolicyTransaction_autp_ID on penguin_tblPolicyTransaction_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_autp_PolicyID')
        create index idx_penguin_tblPolicyTransaction_autp_PolicyID on penguin_tblPolicyTransaction_autp(PolicyID) include (TripCost)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_autp_DomainID')
        create index idx_penguin_tblPolicyTransaction_autp_DomainID on penguin_tblPolicyTransaction_autp(ID) include (PolicyID, CRMUserID, ConsultantID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_autp_QuoteID')
        create clustered index idx_penguin_tblQuote_autp_QuoteID on penguin_tblQuote_autp(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_autp_DomainID')
        create index idx_penguin_tblQuote_autp_DomainID on penguin_tblQuote_autp(QuoteID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPromo_autp_PromoID')
        create clustered index idx_penguin_tblPromo_autp_PromoID on penguin_tblPromo_autp(PromoID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionType_autp_ID')
        create clustered index idx_penguin_tblPolicyTransactionType_autp_ID on penguin_tblPolicyTransactionType_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_autp_ID')
        create clustered index idx_penguin_tblCRMUser_autp_ID on penguin_tblCRMUser_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_autp_UserName')
        create index idx_penguin_tblCRMUser_autp_UserName on penguin_tblCRMUser_autp(ID) include (UserName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionStatus_autp_ID')
        create clustered index idx_penguin_tblPolicyTransactionStatus_autp_ID on penguin_tblPolicyTransactionStatus_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionPromo_autp_PolicyTransactionID')
        create clustered index idx_penguin_tblPolicyTransactionPromo_autp_PolicyTransactionID on penguin_tblPolicyTransactionPromo_autp(PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_autp_QuotePlanID')
        create index idx_penguin_tblPolicy_autp_QuotePlanID on penguin_tblPolicy_autp(QuotePlanID) include (PolicyNumber, PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_autp_QuoteID')
        create clustered index idx_penguin_tblQuotePlan_autp_QuoteID on penguin_tblQuotePlan_autp(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_autp_GrossPremium')
        create index idx_penguin_tblQuotePlan_autp_GrossPremium on penguin_tblQuotePlan_autp(QuoteID) include (GrossPremium, ProductCode, QuotePlanID, IsSelected)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlanPromo_autp_QuotePlanID')
        create clustered index idx_penguin_tblQuotePlanPromo_autp_QuotePlanID on penguin_tblQuotePlanPromo_autp(QuotePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_autp_QuoteCustomerID')
        create clustered index idx_penguin_tblQuoteCustomer_autp_QuoteCustomerID on penguin_tblQuoteCustomer_autp(QuoteCustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_autp_CustomerID')
        create index idx_penguin_tblQuoteCustomer_autp_CustomerID on penguin_tblQuoteCustomer_autp(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletContactInfo_autp_OutletID')
        create clustered index idx_penguin_tblOutletContactInfo_autp_OutletID on penguin_tblOutletContactInfo_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFinancialInfo_autp_OutletID')
        create clustered index idx_penguin_tblOutletFinancialInfo_autp_OutletID on penguin_tblOutletFinancialInfo_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFSRInfo_autp_OutletID')
        create clustered index idx_penguin_tblOutletFSRInfo_autp_OutletID on penguin_tblOutletFSRInfo_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletManagerInfo_autp_OutletID')
        create clustered index idx_penguin_tblOutletManagerInfo_autp_OutletID on penguin_tblOutletManagerInfo_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletShopInfo_autp_OutletID')
        create clustered index idx_penguin_tblOutletShopInfo_autp_OutletID on penguin_tblOutletShopInfo_autp(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblSubGroup_autp_ID')
        create clustered index idx_penguin_tblSubGroup_autp_ID on penguin_tblSubGroup_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblGroup_autp_ID')
        create clustered index idx_penguin_tblGroup_autp_ID on penguin_tblGroup_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletType_autp_OutletTypeID')
        create clustered index idx_penguin_tblOutletType_autp_OutletTypeID on penguin_tblOutletType_autp(OutletTypeID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAddonValue_autp_AddOnValueID')
        create clustered index idx_penguin_tblAddonValue_autp_AddOnValueID on penguin_tblAddonValue_autp(AddOnValueID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyAddon_autp_ID')
        create clustered index idx_penguin_tblPolicyAddon_autp_ID on penguin_tblPolicyAddon_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_autp_ID')
        create clustered index idx_penguin_tblPolicyTravellerTransaction_autp_ID on penguin_tblPolicyTravellerTransaction_autp(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_autp_PolicyTransactionID')
        create index idx_penguin_tblPolicyTravellerTransaction_autp_PolicyTransactionID on penguin_tblPolicyTravellerTransaction_autp(ID) include (PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_autp_UserID')
        create clustered index idx_penguin_tblUser_autp_UserID on penguin_tblUser_autp(UserID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_autp_DomainID')
        create index idx_penguin_tblUser_autp_DomainID on penguin_tblUser_autp(UserID) include (OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_autp_AlphaCode')
        create index idx_penguin_tblOutlet_autp_AlphaCode on penguin_tblOutlet_autp(AlphaCode) include (OutletId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_autp_Login')
        create index idx_penguin_tblUser_autp_Login on penguin_tblUser_autp(Login, OutletID) include (FirstName, LastName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCustomer_autp_CustomerID')
        create clustered index idx_penguin_tblCustomer_autp_CustomerID on penguin_tblCustomer_autp(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitTransaction_autp_BenefitID')
        create clustered index idx_penguin_tblAdditionalBenefitTransaction_autp_BenefitID on penguin_tblAdditionalBenefitTransaction_autp(BenefitID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitDetails_autp_ABTId')
        create clustered index idx_penguin_tblAdditionalBenefitDetails_autp_ABTId on penguin_tblAdditionalBenefitDetails_autp(AdditionalBenefitTransactionId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyEMC_autp_PolicyTravellerTransactionID')
        create nonclustered index idx_penguin_tblPolicyEMC_autp_PolicyTravellerTransactionID on penguin_tblPolicyEMC_autp (PolicyTravellerTransactionID) include (EMCRef, EMCScore, AddOnId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlan_autp_UniquePlanID')
        create clustered index idx_penguin_tblPlan_autp_UniquePlanID on penguin_tblPlan_autp(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlanArea_autp_PlanID')
        create clustered index idx_penguin_tblPlanArea_autp_PlanID on penguin_tblPlanArea_autp(PlanID, AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblArea_autp_AreaID')
        create clustered index idx_penguin_tblArea_autp_AreaID on penguin_tblArea_autp(AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblquotesave_autp_QuoteID')
        create clustered index idx_penguin_tblquotesave_autp_QuoteID on penguin_tblquotesave_autp(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlan_autp_OutletProductID')
        create index idx_penguin_tblOutlet_ProductPlan_autp_OutletProductID on penguin_tblOutlet_ProductPlan_autp(OutletProductID) include (UniquePlanID, ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_Product_autp_OutletID')
        create index idx_penguin_tblOutlet_Product_autp_OutletID on penguin_tblOutlet_Product_autp(ID) include(OutletID, CommissionTierID, VolumeCommission, Discount, ProductPricingTierID, DeclarationSetID, IsStocked)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlanSettings_autp_OutletProductPlanID')
        create index idx_penguin_tblOutlet_ProductPlanSettings_autp_OutletProductPlanID on penguin_tblOutlet_ProductPlanSettings_autp(OutletProductPlanID) include(DefaultExcess, MaxAdminFee, IsUpsell)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblProduct_autp_ProductID')
        create clustered index idx_penguin_tblProduct_autp_ProductID on penguin_tblProduct_autp(ProductID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_Product_autp_OTPId')
        create clustered index idx_penguin_tblOTP_Product_autp_OTPId on penguin_tblOTP_Product_autp(OTPId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_PlanProduct_autp_UniquePlanID')
        create index idx_penguin_tblOTP_PlanProduct_autp_UniquePlanID on penguin_tblOTP_PlanProduct_autp(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValueTypes_autp_ID')
        create nonclustered index idx_penguin_tblPolicyKeyValueTypes_autp_ID on penguin_tblPolicyKeyValueTypes_autp(ID,Code)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValues_autp_PolicyId')
        create nonclustered index idx_penguin_tblPolicyKeyValues_autp_PolicyId on penguin_tblPolicyKeyValues_autp(PolicyId) include(TypeId,Value)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionKeyValues_autp_PolicyId')
        create nonclustered index idx_penguin_tblPolicyTransactionKeyValues_autp_PolicyId on penguin_tblPolicyTransactionKeyValues_autp(PolicyTransactionId) include(TypeId,Value)

    --UK CM
    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblReferenceValue_ukcm_ID')
        create clustered index idx_penguin_tblReferenceValue_ukcm_ID on penguin_tblReferenceValue_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblDomain_ukcm_DomainID')
        create clustered index idx_penguin_tblDomain_ukcm_DomainID on penguin_tblDomain_ukcm(DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ukcm_OutletID')
        create clustered index idx_penguin_tblOutlet_ukcm_OutletID on penguin_tblOutlet_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ukcm_DomainID')
        create index idx_penguin_tblOutlet_ukcm_DomainID on penguin_tblOutlet_ukcm(OutletID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyDetails_ukcm_PolicyID')
        create clustered index idx_penguin_tblPolicyDetails_ukcm_PolicyID on penguin_tblPolicyDetails_ukcm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_ukcm_PolicyID')
        create clustered index idx_penguin_tblPolicy_ukcm_PolicyID on penguin_tblPolicy_ukcm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_ukcm_DomainID')
        create index idx_penguin_tblPolicy_ukcm_DomainID on penguin_tblPolicy_ukcm(PolicyID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_ukcm_ID')
        create clustered index idx_penguin_tblPolicyTransaction_ukcm_ID on penguin_tblPolicyTransaction_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_ukcm_PolicyID')
        create index idx_penguin_tblPolicyTransaction_ukcm_PolicyID on penguin_tblPolicyTransaction_ukcm(PolicyID) include (TripCost)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_ukcm_DomainID')
        create index idx_penguin_tblPolicyTransaction_ukcm_DomainID on penguin_tblPolicyTransaction_ukcm(ID) include (PolicyID, CRMUserID, ConsultantID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_ukcm_QuoteID')
        create clustered index idx_penguin_tblQuote_ukcm_QuoteID on penguin_tblQuote_ukcm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_ukcm_DomainID')
        create index idx_penguin_tblQuote_ukcm_DomainID on penguin_tblQuote_ukcm(QuoteID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPromo_ukcm_PromoID')
        create clustered index idx_penguin_tblPromo_ukcm_PromoID on penguin_tblPromo_ukcm(PromoID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionType_ukcm_ID')
        create clustered index idx_penguin_tblPolicyTransactionType_ukcm_ID on penguin_tblPolicyTransactionType_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_ukcm_ID')
        create clustered index idx_penguin_tblCRMUser_ukcm_ID on penguin_tblCRMUser_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_ukcm_UserName')
        create index idx_penguin_tblCRMUser_ukcm_UserName on penguin_tblCRMUser_ukcm(ID) include (UserName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionStatus_ukcm_ID')
        create clustered index idx_penguin_tblPolicyTransactionStatus_ukcm_ID on penguin_tblPolicyTransactionStatus_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionPromo_ukcm_PolicyTransactionID')
        create clustered index idx_penguin_tblPolicyTransactionPromo_ukcm_PolicyTransactionID on penguin_tblPolicyTransactionPromo_ukcm(PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_ukcm_QuotePlanID')
        create index idx_penguin_tblPolicy_ukcm_QuotePlanID on penguin_tblPolicy_ukcm(QuotePlanID) include (PolicyNumber, PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_ukcm_QuoteID')
        create clustered index idx_penguin_tblQuotePlan_ukcm_QuoteID on penguin_tblQuotePlan_ukcm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_ukcm_GrossPremium')
        create index idx_penguin_tblQuotePlan_ukcm_GrossPremium on penguin_tblQuotePlan_ukcm(QuoteID) include (GrossPremium, ProductCode, QuotePlanID, IsSelected)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlanPromo_ukcm_QuotePlanID')
        create clustered index idx_penguin_tblQuotePlanPromo_ukcm_QuotePlanID on penguin_tblQuotePlanPromo_ukcm(QuotePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_ukcm_QuoteCustomerID')
        create clustered index idx_penguin_tblQuoteCustomer_ukcm_QuoteCustomerID on penguin_tblQuoteCustomer_ukcm(QuoteCustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_ukcm_CustomerID')
        create index idx_penguin_tblQuoteCustomer_ukcm_CustomerID on penguin_tblQuoteCustomer_ukcm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletContactInfo_ukcm_OutletID')
        create clustered index idx_penguin_tblOutletContactInfo_ukcm_OutletID on penguin_tblOutletContactInfo_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFinancialInfo_ukcm_OutletID')
        create clustered index idx_penguin_tblOutletFinancialInfo_ukcm_OutletID on penguin_tblOutletFinancialInfo_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFSRInfo_ukcm_OutletID')
        create clustered index idx_penguin_tblOutletFSRInfo_ukcm_OutletID on penguin_tblOutletFSRInfo_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletManagerInfo_ukcm_OutletID')
        create clustered index idx_penguin_tblOutletManagerInfo_ukcm_OutletID on penguin_tblOutletManagerInfo_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletShopInfo_ukcm_OutletID')
        create clustered index idx_penguin_tblOutletShopInfo_ukcm_OutletID on penguin_tblOutletShopInfo_ukcm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblSubGroup_ukcm_ID')
        create clustered index idx_penguin_tblSubGroup_ukcm_ID on penguin_tblSubGroup_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblGroup_ukcm_ID')
        create clustered index idx_penguin_tblGroup_ukcm_ID on penguin_tblGroup_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletType_ukcm_OutletTypeID')
        create clustered index idx_penguin_tblOutletType_ukcm_OutletTypeID on penguin_tblOutletType_ukcm(OutletTypeID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAddonValue_ukcm_AddOnValueID')
        create clustered index idx_penguin_tblAddonValue_ukcm_AddOnValueID on penguin_tblAddonValue_ukcm(AddOnValueID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyAddon_ukcm_ID')
        create clustered index idx_penguin_tblPolicyAddon_ukcm_ID on penguin_tblPolicyAddon_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_ukcm_ID')
        create clustered index idx_penguin_tblPolicyTravellerTransaction_ukcm_ID on penguin_tblPolicyTravellerTransaction_ukcm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_ukcm_PolicyTransactionID')
        create index idx_penguin_tblPolicyTravellerTransaction_ukcm_PolicyTransactionID on penguin_tblPolicyTravellerTransaction_ukcm(ID) include (PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_ukcm_UserID')
        create clustered index idx_penguin_tblUser_ukcm_UserID on penguin_tblUser_ukcm(UserID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_ukcm_DomainID')
        create index idx_penguin_tblUser_ukcm_DomainID on penguin_tblUser_ukcm(UserID) include (OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ukcm_AlphaCode')
        create index idx_penguin_tblOutlet_ukcm_AlphaCode on penguin_tblOutlet_ukcm(AlphaCode) include (OutletId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_ukcm_Login')
        create index idx_penguin_tblUser_ukcm_Login on penguin_tblUser_ukcm(Login, OutletID) include (FirstName, LastName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCustomer_ukcm_CustomerID')
        create clustered index idx_penguin_tblCustomer_ukcm_CustomerID on penguin_tblCustomer_ukcm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitTransaction_ukcm_BenefitID')
        create clustered index idx_penguin_tblAdditionalBenefitTransaction_ukcm_BenefitID on penguin_tblAdditionalBenefitTransaction_ukcm(BenefitID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitDetails_ukcm_ABTId')
        create clustered index idx_penguin_tblAdditionalBenefitDetails_ukcm_ABTId on penguin_tblAdditionalBenefitDetails_ukcm(AdditionalBenefitTransactionId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyEMC_ukcm_PolicyTravellerTransactionID')
        create nonclustered index idx_penguin_tblPolicyEMC_ukcm_PolicyTravellerTransactionID on penguin_tblPolicyEMC_ukcm (PolicyTravellerTransactionID) include (EMCRef, EMCScore, AddOnId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlan_ukcm_UniquePlanID')
        create clustered index idx_penguin_tblPlan_ukcm_UniquePlanID on penguin_tblPlan_ukcm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlanArea_ukcm_PlanID')
        create clustered index idx_penguin_tblPlanArea_ukcm_PlanID on penguin_tblPlanArea_ukcm(PlanID, AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblArea_ukcm_AreaID')
        create clustered index idx_penguin_tblArea_ukcm_AreaID on penguin_tblArea_ukcm(AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblquotesave_ukcm_QuoteID')
        create clustered index idx_penguin_tblquotesave_ukcm_QuoteID on penguin_tblquotesave_ukcm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlan_ukcm_OutletProductID')
        create index idx_penguin_tblOutlet_ProductPlan_ukcm_OutletProductID on penguin_tblOutlet_ProductPlan_ukcm(OutletProductID) include (UniquePlanID, ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_Product_ukcm_OutletProductID')
        create index idx_penguin_tblOutlet_Product_ukcm_OutletProductID on penguin_tblOutlet_Product_ukcm(ID) include(OutletID, CommissionTierID, VolumeCommission, Discount, ProductPricingTierID, DeclarationSetID, IsStocked)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlanSettings_ukcm_OutletProductPlanID')
        create index idx_penguin_tblOutlet_ProductPlanSettings_ukcm_OutletProductPlanID on penguin_tblOutlet_ProductPlanSettings_ukcm(OutletProductPlanID) include(DefaultExcess, MaxAdminFee, IsUpsell)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblProduct_ukcm_ProductID')
        create clustered index idx_penguin_tblProduct_ukcm_ProductID on penguin_tblProduct_ukcm(ProductID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_Product_ukcm_OTPId')
        create clustered index idx_penguin_tblOTP_Product_ukcm_OTPId on penguin_tblOTP_Product_ukcm(OTPId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_PlanProduct_ukcm_UniquePlanID')
        create index idx_penguin_tblOTP_PlanProduct_ukcm_UniquePlanID on penguin_tblOTP_PlanProduct_ukcm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValueTypes_ukcm_ID')
        create nonclustered index idx_penguin_tblPolicyKeyValueTypes_ukcm_ID on penguin_tblPolicyKeyValueTypes_ukcm(ID,Code)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValues_ukcm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyKeyValues_ukcm_PolicyId on penguin_tblPolicyKeyValues_ukcm(PolicyId) include(TypeId,Value)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionKeyValues_ukcm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyTransactionKeyValues_ukcm_PolicyId on penguin_tblPolicyTransactionKeyValues_ukcm(PolicyTransactionId) include(TypeId,Value)


    --US CM
    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblReferenceValue_uscm_ID')
        create clustered index idx_penguin_tblReferenceValue_uscm_ID on penguin_tblReferenceValue_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblDomain_uscm_DomainID')
        create clustered index idx_penguin_tblDomain_uscm_DomainID on penguin_tblDomain_uscm(DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_uscm_OutletID')
        create clustered index idx_penguin_tblOutlet_uscm_OutletID on penguin_tblOutlet_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_uscm_DomainID')
        create index idx_penguin_tblOutlet_uscm_DomainID on penguin_tblOutlet_uscm(OutletID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyDetails_uscm_PolicyID')
        create clustered index idx_penguin_tblPolicyDetails_uscm_PolicyID on penguin_tblPolicyDetails_uscm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_uscm_PolicyID')
        create clustered index idx_penguin_tblPolicy_uscm_PolicyID on penguin_tblPolicy_uscm(PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_uscm_DomainID')
        create index idx_penguin_tblPolicy_uscm_DomainID on penguin_tblPolicy_uscm(PolicyID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_uscm_ID')
        create clustered index idx_penguin_tblPolicyTransaction_uscm_ID on penguin_tblPolicyTransaction_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_uscm_PolicyID')
        create index idx_penguin_tblPolicyTransaction_uscm_PolicyID on penguin_tblPolicyTransaction_uscm(PolicyID) include (TripCost)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransaction_uscm_DomainID')
        create index idx_penguin_tblPolicyTransaction_uscm_DomainID on penguin_tblPolicyTransaction_uscm(ID) include (PolicyID, CRMUserID, ConsultantID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_uscm_QuoteID')
        create clustered index idx_penguin_tblQuote_uscm_QuoteID on penguin_tblQuote_uscm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuote_uscm_DomainID')
        create index idx_penguin_tblQuote_uscm_DomainID on penguin_tblQuote_uscm(QuoteID) include (DomainID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPromo_uscm_PromoID')
        create clustered index idx_penguin_tblPromo_uscm_PromoID on penguin_tblPromo_uscm(PromoID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionType_uscm_ID')
        create clustered index idx_penguin_tblPolicyTransactionType_uscm_ID on penguin_tblPolicyTransactionType_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_uscm_ID')
        create clustered index idx_penguin_tblCRMUser_uscm_ID on penguin_tblCRMUser_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCRMUser_uscm_UserName')
        create index idx_penguin_tblCRMUser_uscm_UserName on penguin_tblCRMUser_uscm(ID) include (UserName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionStatus_uscm_ID')
        create clustered index idx_penguin_tblPolicyTransactionStatus_uscm_ID on penguin_tblPolicyTransactionStatus_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionPromo_uscm_PolicyTransactionID')
        create clustered index idx_penguin_tblPolicyTransactionPromo_uscm_PolicyTransactionID on penguin_tblPolicyTransactionPromo_uscm(PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicy_uscm_QuotePlanID')
        create index idx_penguin_tblPolicy_uscm_QuotePlanID on penguin_tblPolicy_uscm(QuotePlanID) include (PolicyNumber, PolicyID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_uscm_QuoteID')
        create clustered index idx_penguin_tblQuotePlan_uscm_QuoteID on penguin_tblQuotePlan_uscm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlan_uscm_GrossPremium')
        create index idx_penguin_tblQuotePlan_uscm_GrossPremium on penguin_tblQuotePlan_uscm(QuoteID) include (GrossPremium, ProductCode, QuotePlanID, IsSelected)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuotePlanPromo_uscm_QuotePlanID')
        create clustered index idx_penguin_tblQuotePlanPromo_uscm_QuotePlanID on penguin_tblQuotePlanPromo_uscm(QuotePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_uscm_QuoteCustomerID')
        create clustered index idx_penguin_tblQuoteCustomer_uscm_QuoteCustomerID on penguin_tblQuoteCustomer_uscm(QuoteCustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblQuoteCustomer_uscm_CustomerID')
        create index idx_penguin_tblQuoteCustomer_uscm_CustomerID on penguin_tblQuoteCustomer_uscm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletContactInfo_uscm_OutletID')
        create clustered index idx_penguin_tblOutletContactInfo_uscm_OutletID on penguin_tblOutletContactInfo_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFinancialInfo_uscm_OutletID')
        create clustered index idx_penguin_tblOutletFinancialInfo_uscm_OutletID on penguin_tblOutletFinancialInfo_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletFSRInfo_uscm_OutletID')
        create clustered index idx_penguin_tblOutletFSRInfo_uscm_OutletID on penguin_tblOutletFSRInfo_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletManagerInfo_uscm_OutletID')
        create clustered index idx_penguin_tblOutletManagerInfo_uscm_OutletID on penguin_tblOutletManagerInfo_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletShopInfo_uscm_OutletID')
        create clustered index idx_penguin_tblOutletShopInfo_uscm_OutletID on penguin_tblOutletShopInfo_uscm(OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblSubGroup_uscm_ID')
        create clustered index idx_penguin_tblSubGroup_uscm_ID on penguin_tblSubGroup_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblGroup_uscm_ID')
        create clustered index idx_penguin_tblGroup_uscm_ID on penguin_tblGroup_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletType_uscm_OutletTypeID')
        create clustered index idx_penguin_tblOutletType_uscm_OutletTypeID on penguin_tblOutletType_uscm(OutletTypeID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAddonValue_uscm_AddOnValueID')
        create clustered index idx_penguin_tblAddonValue_uscm_AddOnValueID on penguin_tblAddonValue_uscm(AddOnValueID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyAddon_uscm_ID')
        create clustered index idx_penguin_tblPolicyAddon_uscm_ID on penguin_tblPolicyAddon_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_uscm_ID')
        create clustered index idx_penguin_tblPolicyTravellerTransaction_uscm_ID on penguin_tblPolicyTravellerTransaction_uscm(ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTravellerTransaction_uscm_PolicyTransactionID')
        create index idx_penguin_tblPolicyTravellerTransaction_uscm_PolicyTransactionID on penguin_tblPolicyTravellerTransaction_uscm(ID) include (PolicyTransactionID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_uscm_UserID')
        create clustered index idx_penguin_tblUser_uscm_UserID on penguin_tblUser_uscm(UserID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_uscm_DomainID')
        create index idx_penguin_tblUser_uscm_DomainID on penguin_tblUser_uscm(UserID) include (OutletID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_uscm_AlphaCode')
        create index idx_penguin_tblOutlet_uscm_AlphaCode on penguin_tblOutlet_uscm(AlphaCode) include (OutletId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblUser_uscm_Login')
        create index idx_penguin_tblUser_uscm_Login on penguin_tblUser_uscm(Login, OutletID) include (FirstName, LastName)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblCustomer_uscm_CustomerID')
        create clustered index idx_penguin_tblCustomer_uscm_CustomerID on penguin_tblCustomer_uscm(CustomerID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitTransaction_uscm_BenefitID')
        create clustered index idx_penguin_tblAdditionalBenefitTransaction_uscm_BenefitID on penguin_tblAdditionalBenefitTransaction_uscm(BenefitID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblAdditionalBenefitDetails_uscm_ABTId')
        create clustered index idx_penguin_tblAdditionalBenefitDetails_uscm_ABTId on penguin_tblAdditionalBenefitDetails_uscm(AdditionalBenefitTransactionId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyEMC_uscm_PolicyTravellerTransactionID')
        create nonclustered index idx_penguin_tblPolicyEMC_uscm_PolicyTravellerTransactionID on penguin_tblPolicyEMC_uscm (PolicyTravellerTransactionID) include (EMCRef, EMCScore, AddOnId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlan_uscm_UniquePlanID')
        create clustered index idx_penguin_tblPlan_uscm_UniquePlanID on penguin_tblPlan_uscm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPlanArea_uscm_PlanID')
        create clustered index idx_penguin_tblPlanArea_uscm_PlanID on penguin_tblPlanArea_uscm(PlanID, AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblArea_uscm_AreaID')
        create clustered index idx_penguin_tblArea_uscm_AreaID on penguin_tblArea_uscm(AreaID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblquotesave_uscm_QuoteID')
        create clustered index idx_penguin_tblquotesave_uscm_QuoteID on penguin_tblquotesave_uscm(QuoteID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlan_uscm_OutletProductID')
        create index idx_penguin_tblOutlet_ProductPlan_uscm_OutletProductID on penguin_tblOutlet_ProductPlan_uscm(OutletProductID) include (UniquePlanID, ID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_Product_uscm_OutletProductID')
        create index idx_penguin_tblOutlet_Product_uscm_OutletProductID on penguin_tblOutlet_Product_uscm(ID) include(OutletID, CommissionTierID, VolumeCommission, Discount, ProductPricingTierID, DeclarationSetID, IsStocked)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutlet_ProductPlanSettings_uscm_OutletProductPlanID')
        create index idx_penguin_tblOutlet_ProductPlanSettings_uscm_OutletProductPlanID on penguin_tblOutlet_ProductPlanSettings_uscm(OutletProductPlanID) include(DefaultExcess, MaxAdminFee, IsUpsell)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblProduct_uscm_ProductID')
        create clustered index idx_penguin_tblProduct_uscm_ProductID on penguin_tblProduct_uscm(ProductID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_Product_uscm_OTPId')
        create clustered index idx_penguin_tblOTP_Product_uscm_OTPId on penguin_tblOTP_Product_uscm(OTPId)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOTP_PlanProduct_uscm_UniquePlanID')
        create index idx_penguin_tblOTP_PlanProduct_uscm_UniquePlanID on penguin_tblOTP_PlanProduct_uscm(UniquePlanID)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValueTypes_uscm_ID')
        create nonclustered index idx_penguin_tblPolicyKeyValueTypes_uscm_ID on penguin_tblPolicyKeyValueTypes_uscm(ID,Code)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyKeyValues_uscm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyKeyValues_uscm_PolicyId on penguin_tblPolicyKeyValues_uscm(PolicyId) include(TypeId,Value)

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblPolicyTransactionKeyValues_uscm_PolicyId')
        create nonclustered index idx_penguin_tblPolicyTransactionKeyValues_uscm_PolicyId on penguin_tblPolicyTransactionKeyValues_uscm(PolicyTransactionId) include(TypeId,Value)
end
GO
