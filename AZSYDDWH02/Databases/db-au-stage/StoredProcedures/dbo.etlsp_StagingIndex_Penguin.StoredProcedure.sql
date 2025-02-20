USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_Penguin]    Script Date: 20/02/2025 10:25:22 AM ******/
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
20160531 - LT - Penguin 19.0 release, added tblOutletSalesTargets table
20180913 - LT - Customised for CBA
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

    if not exists(select name from  sys.indexes where  name = 'idx_penguin_tblOutletSalesTargets_aucm_OutletID')
        create clustered index idx_penguin_tblOutletSalesTargets_aucm_OutletID on penguin_tblOutletSalesTargets_aucm(OutletID)

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

end

GO
