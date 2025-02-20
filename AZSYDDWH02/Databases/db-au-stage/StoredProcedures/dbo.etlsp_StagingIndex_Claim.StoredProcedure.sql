USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_Claim]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_StagingIndex_Claim]
as
begin
/*
    20140415, LS, 20728 optimise
	20180927, LT, Customised for CBA
*/

    set nocount on

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaims_au_id')
        create index idx_claims_tblOnlineClaims_au_id on claims_tblOnlineClaims_au(ClaimId) include (AlphaCode, ConsultantName, OnlineClaimId, ClaimCauseId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaims_au_eid')
        create index idx_claims_tblOnlineClaims_au_eid on claims_tblOnlineClaims_au(ClaimCauseId) include (OnlineClaimId, ClaimId, KLDOMAINID)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimEventCauses_au_id')
        create clustered index idx_claims_tblOnlineClaimEventCauses_au_id on claims_tblOnlineClaimEventCauses_au(EventCauseId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimants_au_id')
        create clustered index idx_claims_tblOnlineClaimants_au_id on claims_tblOnlineClaimants_au(OnlineClaimId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimantOtherSourceDetails_au_id')
        create clustered index idx_claims_tblOnlineClaimantOtherSourceDetails_au_id on claims_tblOnlineClaimantOtherSourceDetails_au(ClaimantId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimantCreditCards_au_id')
        create clustered index idx_claims_tblOnlineClaimantCreditCards_au_id on claims_tblOnlineClaimantCreditCards_au(ClaimantId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimantPastClaimDetails_au_id')
        create clustered index idx_claims_tblOnlineClaimantPastClaimDetails_au_id on claims_tblOnlineClaimantPastClaimDetails_au(ClaimantId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimEventSections_au_id')
        create clustered index idx_claims_tblOnlineClaimEventSections_au_id on claims_tblOnlineClaimEventSections_au(CauseId)

    if not exists (select null from sys.indexes where name = 'idx_claims_tblOnlineClaimDeclarations_au_id')
        create clustered index idx_claims_tblOnlineClaimDeclarations_au_id on claims_tblOnlineClaimDeclarations_au(declarationid)

    if not exists (select null from sys.indexes where name = 'idx_claims_klsecurity_au_id')
        create index idx_claims_klsecurity_au_id on claims_klsecurity_au(KS_ID) include (KSNAME)
        
    if not exists (select null from sys.indexes where name = 'idx_claims_klstatus_au_id')
        create index idx_claims_klstatus_au_id on claims_klstatus_au(KT_ID, KTTABLE) include (KTSTATUS, KTDESC)

    if not exists (select null from sys.indexes where name = 'idx_claims_klproducts_au_id')
        create index idx_claims_klproducts_au_id on claims_klproducts_au(KPProd_ID) include (KPPRODUCT)

    if not exists (select null from sys.indexes where name = 'idx_claims_klreg_au_id')
        create index idx_claims_klreg_au_id on claims_klreg_au(KLCLAIM) include (KLPRODUCT, KLDISS, KLDOMAINID)
      
    if not exists (select null from sys.indexes where name = 'idx_claims_klbenefit_au_id')
        create index idx_claims_klbenefit_au_id on claims_klbenefit_au(KBCODE, KBPROD, KBVALIDFROM, KBVALIDTO) include (KBSECT_ID)

    if not exists (select null from sys.indexes where name = 'idx_claims_klcatas_au_id')
        create index idx_claims_klcatas_au_id on claims_klcatas_au(KC_CODE) include (KCSHORT, KCLONG)
  
    if not exists (select null from sys.indexes where name = 'idx_claims_klperilcodes_au_id')
        create index idx_claims_klperilcodes_au_id on claims_klperilcodes_au(KLPERCODE) include (KLPERDESC)

    if not exists (select null from sys.indexes where name = 'idx_claims_klperilcodes_au_cid')
        create index idx_claims_klperilcodes_au_cid on claims_klperilcodes_au(KLPER_ID) include (KLPERCODE,KLPERDESC)

    if not exists (select null from sys.indexes where name = 'idx_claims_klcountry_au_id')
        create index idx_claims_klcountry_au_id on claims_klcountry_au(KLCNTRYCODE) include (KLCNTRYDESC)

    if not exists (select null from sys.indexes where name = 'idx_claims_chqWording_au_id')
        create index idx_claims_chqWording_au_id on claims_chqWording_au(chqBATCH,chqPAYID) include (chqWORDINGS)
       
end




GO
