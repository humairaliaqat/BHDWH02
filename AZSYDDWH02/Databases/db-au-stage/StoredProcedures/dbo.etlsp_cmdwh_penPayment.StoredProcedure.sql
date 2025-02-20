USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPayment]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPayment]
as
begin
/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20130701 - LT - Penguin 5.0 schema changes
20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
20131127 - LS - Penguin 7.8 schema changes
20131210 - LS - case 19862, get domain id from tblPaymentCCMerchant
20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
20150513 - LS - 13.5 add Source
20160321 - LT - Penguin 18.0, Added US Penguin instance
20170823 - VL - add check for tblPayment_Audit "deleted" actions, if found backup and delete from [db-au-cba]..penPayment table
20190207 - LT - re-introduced payment record deletion and backing payment table to bhdwh03.[db-au-backup].dbo.penPayment_cba
20190809 - LT - amended audit deletion behaviour
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('[db-au-stage].dbo.etl_penPayment') is not null
        drop table [db-au-stage].dbo.etl_penPayment

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar, p.PaymentID), 41) PaymentKey,
        left(PrefixKey + convert(varchar, p.PolicyTransactionID), 41) PolicyTransactionKey,
        DomainID,
        p.PaymentID,
        p.PolicyTransactionID,
        p.PaymentRef_ID as PaymentRefID,
        p.OrderId,
        p.[Status],
        p.Total,
        p.ClientID,
        dbo.xfn_ConvertUTCtoLocal(p.TTime, TimeZone) TransTime,
        p.TTime TransTimeUTC,
        p.MerchantID,
        p.ReceiptNo,
        p.ResponseDescription,
        p.ACQResponseCode,
        p.TransactionNo,
        p.AuthoriseID,
        p.CardType,
        p.BatchNo,
        p.TxnResponseCode,
        p.PaymentGatewayID,
        p.PaymentMerchantID,
        p.CreateDateTime,
        p.UpdateDateTime,
        p.Source
    into [db-au-stage].dbo.etl_penPayment
    from
        penguin_tblPayment_aucm p
        inner join penguin_tblPaymentCCMerchant_aucm ccm
            on ccm.PaymentMerchantAcctId = p.PaymentMerchantID
        cross apply dbo.fn_GetDomainKeys(ccm.DomainID, 'CM', 'AU') dk

  


    if object_id('[db-au-cba].dbo.penPayment') is null
    begin

        create table [db-au-cba].dbo.penPayment
        (
            CountryKey varchar(2) null,
            CompanyKey varchar(5) null,
            DomainKey varchar(41) null,
            PaymentKey varchar(41) null,
            PolicyTransactionKey varchar(41) null,
            DomainID int null,
            PaymentID int null,
            PolicyTransactionID int null,
            PaymentRefID varchar(50) null,
            OrderId varchar(50) null,
            [Status] varchar(100) null,
            Total money null,
            ClientID int null,
            TransTime datetime null,
            TransTimeUTC datetime null,
            MerchantID varchar(16) null,
            ReceiptNo varchar(50) null,
            ResponseDescription varchar(34) null,
            ACQResponseCode varchar(50) null,
            TransactionNo varchar(50) null,
            AuthoriseID varchar(50) null,
            CardType varchar(50) null,
            BatchNo varchar(20) null,
            TxnResponseCode varchar(5) null,
            PaymentGatewayID varchar(50) null,
            PaymentMerchantID int null,
            CreateDateTime datetime null,
            UpdateDateTime datetime null,
            Source varchar(50)
        )

        create clustered index idx_penPayment_PolicyTransactionKey on [db-au-cba].dbo.penPayment(PolicyTransactionKey)
        create index idx_penPayment_CountryKey on [db-au-cba].dbo.penPayment(CountryKey)
        create index idx_penPayment_PaymentKey on [db-au-cba].dbo.penPayment(PaymentKey)
        create index idx_penPayment_TransTime on [db-au-cba].dbo.penPayment(TransTime)
        create index idx_penPayment_DomainID on [db-au-cba].dbo.penPayment(DomainID)
        create index idx_penPayment_DomainKey on [db-au-cba].dbo.penPayment(DomainKey)

    end
    
    begin transaction penPayment

    begin try
    
        delete a
        from
            [db-au-cba].dbo.penPayment a
        where
            a.PolicyTransactionKey in
            (
                select
                    PolicyTransactionKey
                from
                    etl_penPayment
            )


        insert [db-au-cba].dbo.penPayment with(tablockx)
        (
            CountryKey,
            CompanyKey,
            DomainKey,
            PaymentKey,
            PolicyTransactionKey,
            DomainID,
            PaymentID,
            PolicyTransactionID,
            PaymentRefID,
            OrderId,
            [Status],
            Total,
            ClientID,
            TransTime,
            TransTimeUTC,
            MerchantID,
            ReceiptNo,
            ResponseDescription,
            ACQResponseCode,
            TransactionNo,
            AuthoriseID,
            CardType,
            BatchNo,
            TxnResponseCode,
            PaymentGatewayID,
            PaymentMerchantID,
            CreateDateTime,
            UpdateDateTime,
            Source
        )
        select
            CountryKey,
            CompanyKey,
            DomainKey,
            PaymentKey,
            PolicyTransactionKey,
            DomainID,
            PaymentID,
            PolicyTransactionID,
            PaymentRefID,
            OrderId,
            [Status],
            Total,
            ClientID,
            TransTime,
            TransTimeUTC,
            MerchantID,
            ReceiptNo,
            ResponseDescription,
            ACQResponseCode,
            TransactionNo,
            AuthoriseID,
            CardType,
            BatchNo,
            TxnResponseCode,
            PaymentGatewayID,
            PaymentMerchantID,
            CreateDateTime,
            UpdateDateTime,
            Source
        from
            [db-au-stage].dbo.etl_penPayment



    
    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPayment
            
        exec syssp_genericerrorhandler 'penPayment data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPayment


	--check [db-au-stage]..penguin_tblPayment_Audit_xxxx tables for "delete" actions 
	--and delete from [db-au-cba].[dbo].[penPayment] 
	begin try

		-- make sure penPayment table exists in [db-au-backup] on bhdwh03
		exec
		(
			'if object_id(''[db-au-backup]..penPayment_cba'') is null 
			select * into [db-au-backup]..penPayment_cba from openquery(azsyddwh02, ''select * from [db-au-cba]..penPayment where 1 = 0'')'
		) at [bhdwh03]

		-- backup to bhdwh03
		exec
		(
			'insert into [db-au-backup]..penPayment_cba
			select * from openquery(azsyddwh02, 
				''select 
					t.*
				from 
					(
						select 
							left(dk.PrefixKey + convert(varchar, p.PaymentID), 41) PaymentKey,
							left(dk.PrefixKey + convert(varchar, p.PolicyTransactionID), 41) PolicyTransactionKey,
							p.audit_action 
						from 
							[db-au-stage]..penguin_tblPayment_Audit_aucm p 
							inner join [db-au-stage]..penguin_tblPaymentCCMerchant_aucm ccm
								on ccm.PaymentMerchantAcctId = p.PaymentMerchantID
							cross apply [db-au-stage].dbo.fn_GetDomainKeys(ccm.DomainID, ''''CM'''', ''''AU'''') dk 
						
					) s 
					join [db-au-cba].[dbo].[penPayment] t on 
						s.PaymentKey = t.PaymentKey 
						and s.PolicyTransactionKey = t.PolicyTransactionKey 
				where 
					s.audit_action like ''''%deleted%'''' '')'
		) at [bhdwh03]

		-- delete 
		delete t
		from 
			(
				select 
					left(dk.PrefixKey + convert(varchar, p.PaymentID), 41) PaymentKey,
					left(dk.PrefixKey + convert(varchar, p.PolicyTransactionID), 41) PolicyTransactionKey,
					p.audit_action 
				from 
					penguin_tblPayment_Audit_aucm p 
					inner join penguin_tblPaymentCCMerchant_aucm ccm
						on ccm.PaymentMerchantAcctId = p.PaymentMerchantID
					cross apply dbo.fn_GetDomainKeys(ccm.DomainID, 'CM', 'AU') dk 

			) s 
			join [db-au-cba].[dbo].[penPayment] t on
				s.PaymentKey = t.PaymentKey 
				and s.PolicyTransactionKey = t.PolicyTransactionKey 
		where 
			s.audit_action like '%deleted%' 

	end try
    
    begin catch
            
        exec syssp_genericerrorhandler 'tblPayment_Audit delete action failed'
        
    end catch    


end


GO
