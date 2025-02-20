USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL004_ClaimsDataModel_DeleteNonCBA]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_ETL004_ClaimsDataModel_DeleteNonCBA]
as
begin
	--20180927, LT, Created

    delete
    from
        [db-au-stage]..claims_KLREG_au
    where
		KLALPHA is null or
        not
        (
            KLDOMAINID = 7 and
            (
                KLALPHA like 'CB%' or
                KLALPHA like 'BW%'
            )
        )


    delete t
    from
        [db-au-stage].dbo.claims_AUDIT_KLEVENT_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KECLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_AUDIT_KLNAMES_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KNCLAIM_ID
        )


    delete t
    from
        [db-au-stage].dbo.claims_AUDIT_KLPAYMENTS_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KPCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_AUDIT_KLREG_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KLCLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_AUDIT_KLSECTION_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KSCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_CHQRUNEXT_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.CHCLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLAUDIT_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.CHCLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLESTHIST_au t
		inner join [db-au-stage].dbo.claims_KLSECTION_au s on t.EHIS_ID = s.KS_ID
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = s.KSCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLEVENT_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KECLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLINVOICES_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KVCLAIM_ID
        )


    delete t
    from
        [db-au-stage].dbo.claims_KLLOCATION_au t
		inner join [db-au-stage].dbo.claims_KLLOCHIST_AU s on t.LO_ID = s.LHLOC_ID
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = s.LHCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLLOCHIST_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.LHCLAIM_ID
        )


    delete t
    from
        [db-au-stage].dbo.claims_KLMAPCustomerClaim_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KLCLAIM
        )


    delete t
    from
        [db-au-stage].dbo.claims_KLNAMES_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KNCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLPAYMENTS_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KPCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_KLSECTION_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.KSCLAIM_ID
        )

    delete t
    from
        [db-au-stage].dbo.claims_SECHEQUE_AU t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.SECLAIM
        )

    delete t
    from
        [db-au-stage].dbo.claims_tblOnlineClaimantCreditCards_AU t
		inner join [db-au-stage].dbo.claims_tblOnlineClaimants_au s on t.ClaimantId = s.ClaimantId
		inner join [db-au-stage].dbo.claims_tblOnlineClaims_au c on s.OnlineClaimId = c.OnlineClaimId
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = c.ClaimId
        )

    delete t
    from
        [db-au-stage].dbo.claims_tblOnlineClaimantOtherSourceDetails_AU t
		inner join [db-au-stage].dbo.claims_tblOnlineClaimants_au s on t.ClaimantId = s.ClaimantId
		inner join [db-au-stage].dbo.claims_tblOnlineClaims_au c on s.OnlineClaimId = c.OnlineClaimId
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = c.ClaimId
        )

    delete t
    from
        [db-au-stage].dbo.claims_tblOnlineClaimantPastClaimDetails_au t
		inner join [db-au-stage].dbo.claims_tblOnlineClaimants_au s on t.ClaimantId = s.ClaimantId
		inner join [db-au-stage].dbo.claims_tblOnlineClaims_au c on s.OnlineClaimId = c.OnlineClaimId
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = c.ClaimId
        )

    delete t
    from
		[db-au-stage].dbo.claims_tblOnlineClaimants_au t
		inner join [db-au-stage].dbo.claims_tblOnlineClaims_au c on t.OnlineClaimId = c.OnlineClaimId
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = c.ClaimId
        )

    delete t
    from
		[db-au-stage].dbo.claims_tblOnlineClaims_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.ClaimId
        )

    delete t
    from
		[db-au-stage].dbo.claims_UploadedDocuments_au t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..claims_KLREG_au r
            where
                r.KLCLAIM = t.ClaimId
        )
end
GO
