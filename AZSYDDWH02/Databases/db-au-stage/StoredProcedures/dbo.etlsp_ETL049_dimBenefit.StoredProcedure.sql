USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL049_dimBenefit]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL049_dimBenefit]
as
begin

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))
    
    select
        @name = object_name(@@procid)

    /* check if this is running on a batch or standalone */
    begin try
    
        exec syssp_getrunningbatch
            @SubjectArea = 'Claim STAR',
            @BatchID = @batchid out,
            @StartDate = @start out,
            @EndDate = @end out
        
        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'
            
    end try
    
    begin catch
    
        set @batchid = -1
    
    end catch

    if object_id('[db-au-star].dbo.dimBenefit') is null
    begin

        create table [db-au-star].dbo.dimBenefit
        (
            [BenefitSK] bigint not null identity(1,1),
            [BenefitGroup] varchar(20) null,
            [BenefitCategory] varchar(50) null,
            [CreateBatchID] int,
            [UpdateBatchID] int
        )

        create clustered index idx_dimBenefit_BenefitSK on [db-au-star].dbo.dimBenefit(BenefitSK)
        create nonclustered index idx_dimBenefit_Benefit on [db-au-star].dbo.dimBenefit(BenefitCategory,BenefitGroup) include(BenefitSK)

        set identity_insert [db-au-star].dbo.dimBenefit on

        insert into [db-au-star].dbo.dimBenefit
        (
            [BenefitSK],
            [BenefitGroup],
            [BenefitCategory],
            [CreateBatchID],
            [UpdateBatchID]
        )
        select 
            -1 [BenefitSK],
            'Unknown' [BenefitGroup],
            'Unknown' [BenefitCategory],
            -1 CreateBatchID,
            -1 UpdateBatchID

        set identity_insert [db-au-star].dbo.dimBenefit off

    end


    if object_id('tempdb..#dimBenefit') is not null
        drop table #dimBenefit

    select 
        case
            when BenefitCategory is null then 'Unknown'
            when BenefitCategory like '%medical%' then 'Medical'
            when BenefitCategory like '%cancel%' then 'Cancellation'
            when BenefitCategory like 'luggage%' then 'Luggage'
            when BenefitCategory like '%additional%' then 'Additional Expenses'
            else 'Other'
        end BenefitGroup,
        isnull(BenefitCategory, 'Unknown') BenefitCategory
    into #dimBenefit
    from
        [db-au-cba]..clmSection cs
        left join [db-au-cba]..vclmBenefitCategory cb on
            cb.BenefitSectionKey = cs.BenefitSectionKey

    union

    select 
        case
            when BenefitCategory is null then 'Unknown'
            when BenefitCategory like '%medical%' then 'Medical'
            when BenefitCategory like '%cancel%' then 'Cancellation'
            when BenefitCategory like 'luggage%' then 'Luggage'
            when BenefitCategory like '%additional%' then 'Additional Expenses'
            else 'Other'
        end BenefitGroup,
        isnull(BenefitCategory, 'Unknown') BenefitCategory
    from
        [db-au-cba]..clmAuditSection cs
        left join [db-au-cba]..vclmBenefitCategory cb on
            cb.BenefitSectionKey = cs.BenefitSectionKey    
    

    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-star].dbo.dimBenefit with(tablock) t
        using #dimBenefit s on
            s.BenefitCategory = t.BenefitCategory

        when matched then

            update
            set
                BenefitGroup = s.BenefitGroup,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                BenefitCategory,
                BenefitGroup,
                CreateBatchID
            )
            values
            (
                s.BenefitCategory,
                s.BenefitGroup,
                @batchid
            )

        output $action into @mergeoutput
        ;

        select
            @insertcount =
                sum(
                    case
                        when MergeAction = 'insert' then 1
                        else 0
                    end
                ),
            @updatecount =
                sum(
                    case
                        when MergeAction = 'update' then 1
                        else 0
                    end
                )
        from
            @mergeoutput

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Finished',
            @LogSourceCount = @sourcecount,
            @LogInsertCount = @insertcount,
            @LogUpdateCount = @updatecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'dimBenefit data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
