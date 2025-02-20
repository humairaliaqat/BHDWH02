USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbCaseTypeFee]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbCaseTypeFee]
as
begin
/*
20150721, LS, T16930, Carebase 4.6
*/

    set nocount on

    exec etlsp_StagingIndex_Carebase

    if object_id('[db-au-cba].dbo.cbCaseTypeFee') is null
    begin

        create table [db-au-cba].dbo.cbCaseTypeFee
        (
            [BIRowID] bigint not null identity(1,1),
            [FeeID] int not null,
            [ClientCode] nvarchar(2) not null,
            [ProgramType] nvarchar(2) null,
            [ProgramDescription] nvarchar(25) null,
            [Channel] nvarchar(250) null,
            [CaseType] nvarchar(30) null,
            [Protocol] nvarchar(250) null,
            [Fee] money null,
            [Tax] money null
        )

        create clustered index idx_cbCaseTypeFee_BIRowID on [db-au-cba].dbo.cbCaseTypeFee(BIRowID)
        create nonclustered index idx_cbCaseTypeFee_FeeID on [db-au-cba].dbo.cbCaseTypeFee(FeeID)

    end

    begin transaction

    begin try

        if object_id('tempdb..#cbCaseTypeFee') is not null
            drop table #cbCaseTypeFee

        select 
            pm.Id FeeID,
            CLI_CODE ClientCode,
            POL_CODE ProgramType,
            POL_DESC ProgramDescription,
            fc.Name Channel,
            ct.CT_DESCRIPTION CaseType,
            pr.Description Protocol,
            pm.Fee,
            pm.Tax
        into #cbCaseTypeFee
        from
            carebase_tblCaseTypeFeePricingMatrix_aucm pm
            inner join carebase_POL_POLICY_aucm p on
                p.AUTOID = pm.POL_POLICY_ID
            left join carebase_UCT_CASETYPE_aucm ct on
                ct.CT_ID = pm.UCT_CASE_TYPE_ID
            left join carebase_tblReference_aucm pr on
                pr.id = pm.ProtocolCode
            left join carebase_tblFinanceChannels_aucm fc on
                fc.ID = pm.ChannelId

        merge into [db-au-cba].dbo.cbCaseTypeFee with(tablock) t
        using #cbCaseTypeFee s on
            s.FeeID = t.FeeID

        when matched then
            update
            set
                ClientCode = s.ClientCode,
                ProgramType = s.ProgramType,
                ProgramDescription = s.ProgramDescription,
                Channel = s.Channel,
                CaseType = s.CaseType,
                Protocol = s.Protocol,
                Fee = s.Fee,
                Tax = s.Tax

        when not matched by target then 
            insert
            (
                FeeID,
                ClientCode,
                ProgramType,
                ProgramDescription,
                Channel,
                CaseType,
                Protocol,
                Fee,
                Tax
            )
            values
            (
                s.FeeID,
                s.ClientCode,
                s.ProgramType,
                s.ProgramDescription,
                s.Channel,
                s.CaseType,
                s.Protocol,
                s.Fee,
                s.Tax
            )
        ;

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler 'cbCaseTypeFee data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction

end

GO
