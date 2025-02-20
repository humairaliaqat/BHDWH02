USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL021_PenguinDataModel_DeleteNonCBA]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_ETL021_PenguinDataModel_DeleteNonCBA]
as
begin
    --20180918, LL, pre roll deletion non CBA data instead of post ETL
	--20180927, LT, added tblPolicyCOIByPost and tblPolicyEmergencyContact tables to deletion process
	--20181113, LT, changed CB/BW identification by GroupCode as opposed to AlphaCode like 'CB%' or 'BW%'. Zurich and some Indies alphacodes starts with CB/BW.
	--20190306, LL, REQ-1166, added tblPolicyKeyValues and tblPolicyTransactionKeyValues to deletion process

    delete a
    from
        [db-au-stage]..penguin_tblOutlet_aucm a
		inner join [db-au-stage]..penguin_tblSubGroup_aucm sg on a.SubGroupID = sg.ID
		inner join [db-au-stage]..penguin_tblGroup_aucm g on sg.GroupID = g.ID
    where
        not
        (
            a.DomainId = 7 and
			g.Code in ('CB','BW')
        )

    delete t
    from
        [db-au-stage]..penguin_tblUser_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblOutlet_aucm r
            where
                r.OutletId = t.OutletID
        )

    delete t
    from
        [db-au-stage]..penguin_tblquote_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblOutlet_aucm r
            where
                r.AlphaCode = t.AlphaCode and
                r.DomainId = t.DomainId
        )


    delete t
    from
        [db-au-stage]..penguin_tblquotecustomer_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblquote_aucm r
            where
                r.QuoteID = t.QuoteID
        )

    delete t
    from
        [db-au-stage]..penguin_tblPolicy_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblOutlet_aucm r
            where
                r.AlphaCode = t.AlphaCode and
                r.DomainId = t.DomainId
        )

    delete t
    from
        [db-au-stage]..penguin_tblPolicyTransaction_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblPolicy_aucm r
            where
                r.PolicyID = t.PolicyID
        )

	delete t
	from [db-au-stage]..penguin_tblPolicyTransactionKeyValues_aucm t
	where
		not exists
		(
			select
				null
			from
				[db-au-stage]..penguin_tblPolicyTransaction_aucm r
			where
				r.ID = t.PolicyTransactionID
		)

	delete t
	from [db-au-stage]..penguin_tblPolicyCOIByPost_aucm t
	where
		not exists
		(
			select
				null
			from
				[db-au-stage]..penguin_tblPolicy_aucm r
			where
				r.PolicyNumber = t.PolicyNumber
		)

	delete t
	from [db-au-stage]..penguin_tblPolicyKeyValues_aucm t
	where
		not exists
		(
			select
				null
			from
				[db-au-stage]..penguin_tblPolicy_aucm r
			where
				r.PolicyID = t.PolicyId
		)

	delete t
	from [db-au-stage]..penguin_tblPolicyEmergencyContact_aucm t
	where
		not exists
		(
			select
				null
			from
				[db-au-stage]..penguin_tblPolicy_aucm r
			where
				r.PolicyNumber = t.PolicyNumber
		)

    delete t
    from
        [db-au-stage]..penguin_tblPolicyTraveller_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblPolicy_aucm r
            where
                r.PolicyID = t.PolicyID
        )

    delete t
    from
        [db-au-stage]..penguin_tblPayment_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblPolicyTransaction_aucm r
            where
                r.ID = t.PolicyTransactionID
        )

    delete t
    from
        [db-au-stage]..penguin_tblPaymentRegister_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblOutlet_aucm r
            where
                r.OutletId = t.OutletID
        )


    truncate table [db-au-stage]..penguin_tblCreditCardReconcile_aucm
    truncate table [db-au-stage]..penguin_tblEmailAudit_aucm


    delete t
    from
        [db-au-stage]..penguin_tblCRMCallComments_aucm t
    where
        not exists
        (
            select
                null
            from
                [db-au-stage]..penguin_tblOutlet_aucm r
            where
                r.OutletId = t.OutletID
        )





    --post roll deletion

    ----delete non-cba penAssistance records
    --delete af
    --from
	   -- [db-au-cba].dbo.penAssistanceFee af
    --where
	   -- af.JointVentureID not in 
	   -- (
		  --  select distinct JVID
		  --  from [db-au-cba].dbo.penOutlet
		  --  where 
			 --   CountryKey = 'AU' and 
			 --   JVCode in ('6A','6B','6C','6D','6E')
	   -- )

    ----delete non-cba penAutoComment records
    --delete ac
    --from [db-au-cba].dbo.penAutoComment ac
    --where
	   -- ac.AlphaCode not in 
	   -- (
		  --  select distinct AlphaCode
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )
	
    ----delete non-cba penCreditCardReconcile records
    --delete ccr
    --from 
	   -- [db-au-cba].[dbo].[penCreditCardReconcile] ccr
	   -- inner join [db-au-cba].dbo.penCreditCardReconcileTransaction ccrt on ccr.CreditCardReconcileKey = ccrt.CreditCardReconcileKey
    --where
	   -- ccrt.AlphaCode not in
	   -- (
		  --  select distinct AlphaCode
		  --  from [db-au-cba].dbo.penOutlet
		  --  where 
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 


    ----delete non-cba penCreditCardReconcileTransaction records
    --delete ccrt
    --from 
	   -- [db-au-cba].dbo.penCreditCardReconcileTransaction ccrt
    --where
	   -- ccrt.AlphaCode not in
	   -- (
		  --  select distinct AlphaCode
		  --  from [db-au-cba].dbo.penOutlet
		  --  where 
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 	

    ----delete non-cba penCRMCallComments
    --delete ccc
    --from [db-au-cba].dbo.penCRMCallComments ccc
    --where
	   -- ccc.OutletKey not in 
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete c
    --from 
	   -- [db-au-cba].dbo.penCustomer c
	   -- inner join [db-au-cba].dbo.penQuoteCustomer qc on c.CustomerKey = qc.CustomerKey
	   -- inner join [db-au-cba].dbo.penQuote q on qc.QuoteCountryKey = q.QuoteCountryKey
    --where
	   -- q.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete qc
    --from [db-au-cba].dbo.penQuoteCustomer qc
	   -- inner join [db-au-cba].dbo.penQuote q on qc.QuoteCountryKey = q.QuoteCountryKey
    --where
	   -- q.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete qd
    --from 
	   -- [db-au-cba].dbo.penQuoteDestination qd
	   -- inner join [db-au-cba].dbo.penQuote q on qd.QuoteKey = q.QuoteKey
    --where
	   -- q.OutletAlphaKey not in 
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )


    --delete qe
    --from
	   -- [db-au-cba].dbo.penQuoteEMC qe
	   -- inner join [db-au-cba].dbo.penQuote q on qe.QuoteCountryKey = q.QuoteCountryKey
    --where
	   -- q.OutletAlphaKey not in 
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete qp
    --from
	   -- [db-au-cba].dbo.penQuotePromo qp
	   -- inner join [db-au-cba].dbo.penQuote q on qp.QuoteCountryKey = q.QuoteCountryKey
    --where
	   -- q.OutletAlphaKey not in 
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )


    --delete q
    --from [db-au-cba].dbo.penQuote q
    --where
	   -- q.OutletAlphaKey not in 
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ea
    --from
	   -- [db-au-cba].dbo.penEmailAudit ea
	   -- inner join [db-au-cba].dbo.penPolicy p on 
		  --  ea.CountryKey = p.CountryKey and
		  --  ea.AuditReference = p.PolicyNumber
    --where
	   -- p.AlphaCode not in
	   -- (
		  --  select distinct AlphaCode
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete mepb
    --from
	   -- [db-au-cba].dbo.penMonthEndProcessBatch mepb
	   -- inner join [db-au-cba].dbo.penMonthEndProcessBatchTransaction mepbt on mepb.BatchKey = mepbt.BatchKey
    --where
	   -- mepbt.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete mepbt
    --from
	   -- [db-au-cba].dbo.penMonthEndProcessBatchTransaction mepbt
    --where
	   -- mepbt.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete oe
    --from 
	   -- [db-au-cba].dbo.penOutletEndorser oe
    --where
	   -- oe.OutletKey not in 
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ol
    --from 
	   -- [db-au-cba].dbo.penOutletLineage ol
    --where
	   -- ol.OutletKey not in 
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ost
    --from
	   -- [db-au-cba].dbo.penOutletSalesTarget ost
    --where
	   -- ost.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete os
    --from [db-au-cba].dbo.penOutletStore os
    --where
	   -- os.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete oth
    --from [db-au-cba].dbo.penOutletTradingHistory oth
    --where
	   -- oth.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pay
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPayment pay on pt.PolicyTransactionKey = pay.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete paa
    --from
	   -- [db-au-cba].dbo.penPaymentAllocation pa
	   -- inner join [db-au-cba].dbo.penPaymentAllocationAdjustment paa on pa.PaymentAllocationKey = paa.PaymentAllocationKey
    --where
	   -- pa.OutletKey not in 
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pa
    --from
	   -- [db-au-cba].dbo.penPaymentAllocation pa
    --where
	   -- pa.OutletKey not in 
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete prt
    --from
	   -- [db-au-cba].dbo.penPaymentRegister pr
	   -- inner join [db-au-cba].dbo.penPaymentRegisterTransaction prt on pr.PaymentRegisterKey = prt.PaymentRegisterKey
    --where
	   -- pr.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pr
    --from
	   -- [db-au-cba].dbo.penPaymentRegister pr
    --where
	   -- pr.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pao
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyAddOn pao on pt.PolicyTransactionKey = pao.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 

    --delete paot
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyAddOn pao on pt.PolicyTransactionKey = pao.PolicyTransactionKey
	   -- inner join [db-au-cba].dbo.penPolicyAddOnTax paot on pao.PolicyAddonKey = paot.PolicyAddonKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 


    --delete pacc
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyAdminCallComment pacc on p.PolicyKey = pacc.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 

    --delete pc
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyCompetitor pc on p.PolicyKey = pc.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 

    --delete pd
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyDestination pd on p.PolicyKey = pd.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 

    --delete pe
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on pt.PolicyTransactionKey = ptt.PolicyTransactionKey
	   -- inner join [db-au-cba].dbo.penPolicyEMC pe on ptt.PolicyTravellerTransactionKey = pe.PolicyTravellerTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 


    --delete pp
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyPrice pp on 
		  --  pt.CountryKey = pp.CountryKey and
		  --  pt.CompanyKey = pp.CompanyKey and
		  --  pt.PolicyTransactionID = pp.PolicyTransactionID
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 


    --delete ptax
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on pt.PolicyTransactionKey = ptt.PolicyTransactionKey
	   -- inner join [db-au-cba].dbo.penPolicyTax ptax on ptt.PolicyTravellerTransactionKey = ptax.PolicyTravellerTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- ) 


    --delete pta
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTransactionAllocation pta on pt.PolicyTransactionKey = pta.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ptp
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTransactionPromo ptp on pt.PolicyTransactionKey = ptp.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )


    --delete ptao
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTransAddOn ptao on pt.PolicyTransactionKey = ptao.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pts
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransSummary pts on p.PolicyKey = pts.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ptr
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTraveller ptr on p.PolicyKey = ptr.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )	

    --delete ptrao
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on pt.PolicyTransactionKey = ptt.PolicyTransactionKey
	   -- inner join [db-au-cba].dbo.penPolicyTravellerAddOn ptrao on ptt.PolicyTravellerTransactionKey = ptrao.PolicyTravellerTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete ptt
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
	   -- inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on pt.PolicyTransactionKey = ptt.PolicyTransactionKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )


    --delete pr
    --from
	   -- [db-au-cba].dbo.penProductPlan pp
	   -- inner join [db-au-cba].dbo.penProduct pr on
		  --  pp.CountryKey = pr.CountryKey and
		  --  pp.CompanyKey = pr.CompanyKey and
		  --  pp.ProductID = pr.ProductID
    --where
	   -- pp.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    --delete pp
    --from
	   -- [db-au-cba].dbo.penProductPlan pp
    --where
	   -- pp.OutletKey not in
	   -- (
		  --  select distinct OutletKey
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    ----delete penUser records that are not CBA, BankWest, or Cover-More (required as CM users can admin CBA/BW policy data)
    --delete u
    --from
	   -- [db-au-cba].dbo.penUser u
	   -- inner join [db-au-cba].dbo.penOutlet o on u.OutletKey = o.OutletKey
    --where
	   -- o.CountryKey = 'AU' and
	   -- o.GroupCode in ('CB','BW','CM')

    ----delete penUser records that are not CBA, BankWest, or Cover-More (required as CM users can admin CBA/BW policy data)
    --delete ua
    --from
	   -- [db-au-cba].dbo.penUserAudit ua
	   -- inner join [db-au-cba].dbo.penOutlet o on ua.OutletKey = o.OutletKey
    --where
	   -- o.CountryKey = 'AU' and
	   -- o.GroupCode in ('CB','BW','CM')

    ----delete penPolicyTransaction
    --delete pt
    --from
	   -- [db-au-cba].dbo.penPolicy p
	   -- inner join [db-au-cba].dbo.penPolicyTransaction pt on p.PolicyKey = pt.PolicyKey
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )


    ----delete penPolicy
    --delete p
    --from
	   -- [db-au-cba].dbo.penPolicy p
    --where
	   -- p.OutletAlphaKey not in
	   -- (
		  --  select distinct OutletAlphaKey 
		  --  from [db-au-cba].dbo.penOutlet
		  --  where
			 --   CountryKey = 'AU' and
			 --   GroupCode in ('CB','BW')
	   -- )

    ----delete penOutlet
    --delete o
    --from
	   -- [db-au-cba].dbo.penOutlet o
    --where
	   -- o.CountryKey <> 'AU' and
	   -- o.GroupCode not in ('CB','BW','CM')

end
GO
