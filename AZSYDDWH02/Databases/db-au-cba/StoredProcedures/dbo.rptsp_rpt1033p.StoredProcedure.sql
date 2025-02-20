USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt1033p]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   procedure [dbo].[rptsp_rpt1033p]
    @Country varchar(2),
	@SuperGroup varchar(25),
    @ReportingPeriod varchar(30),
    @StartDate date = null,
    @EndDate date = null,
    @TimeReference varchar(10) = 'Local'
    
as
begin

/****************************************************************************************************/
--  Name			:	rptsp_rpt1033p
--  Description		:	RPT1033 - Claims Estimate and Payment Movement
--  Author			:	Yi Yang
--  Date Created	:	20181119
--  Change History	:	20181119 YY - new reprot
--						This procedure is based on rptsp_rpt0646p and add column "Super Group" 
--						for CBA purpose (REQ-570).
--
/****************************************************************************************************/

--/*debug begin
--declare
--    @Country varchar(2),
--	  @SuperGroup varchar(25),
--    @ReportingPeriod varchar(30),
--    @StartDate date,
--    @EndDate date,
--    @TimeReference varchar(10)
    
--select
--    @Country = 'AU',
--	@SuperGroup = null, -- 'CBA Group',
--    @ReportingPeriod = 'Current Fiscal Year',
--    @TimeReference = 'Local'
--debug end*/

    set nocount on

    declare 
        @start date,
        @end date

    if @ReportingPeriod = '_User Defined' 
        select 
            @start = @StartDate,
            @end = @EndDate
    else
        select 
            @start = StartDate,
            @end = EndDate
        from
            vDateRange
        where
            DateRange = @ReportingPeriod

    if object_id('tempdb..#payments') is not null
        drop table #payments

    select
		cl.ClaimKey,
        cpm.SectionKey,
        cpm.BenefitCategory,
        r.PaymentDate,
        FirstPayment,
        PaymentStatus,
        AllMovement PaymentMovement,
        datediff(d, convert(date, cl.ReceivedDate), r.PaymentDate) + 1.00 LeadTime,
		o.SuperGroupName as SuperGroup					
    into #payments
    from
        clmClaimPaymentMovement cpm
        inner join clmClaim cl on
            cl.ClaimKey = cpm.ClaimKey
		left join penOutlet o on o.OutletKey = cl.OutletKey and o.OutletStatus = 'Current'  
        cross apply
        (
            select
                case
                    when @TimeReference = 'Local' then cpm.PaymentDate
                    else cpm.PaymentDateUTC
                end PaymentDate
        ) r
	where
        cl.CountryKey = @Country and
		(
			isnull(@SuperGroup, 'All') = 'All' or
			o.SuperGroupName = @SuperGroup
		) and

        (
            (
                @TimeReference = 'Local' and
                (
                    (
                        cpm.PaymentDate >= @start and
                        cpm.PaymentDate <  dateadd(day,1 , @end)
                    ) or
                    (
                        cpm.PaymentDate >= dateadd(year, -1, @start) and
                        cpm.PaymentDate <  dateadd(year, -1, dateadd(day,1 , @end))
                    ) 
                )
            ) or
            (
                @TimeReference = 'UTC' and
                (
                    (
                        cpm.PaymentDateUTC >= @start and
                        cpm.PaymentDateUTC <  dateadd(day,1 , @end)
                    ) or
                    (
                        cpm.PaymentDateUTC >= dateadd(year, -1, @start) and
                        cpm.PaymentDateUTC <  dateadd(year, -1, dateadd(day,1 , @end))
                    ) 
                )
            )
        )
            
    select 
        convert(date, convert(varchar(7), PaymentDate, 120) + '-01') [PaymentMonth],
		SuperGroup,						
        BenefitCategory,
        sum(
            case
                when FirstPayment = 1 then PaymentMovement
                else 0
            end 
        ) PrimaryPaymentsCY,
        sum(
            case
                when FirstPayment = 1 then 0
                else PaymentMovement
            end 
        ) SecondaryPaymentsCY,
        count(SectionKey) VolumeCY,
		count(distinct ClaimKey) ClaimCountCY,
        count(
            distinct
            case
                when FirstPayment = 0 then SectionKey
                else null
            end 
        ) SecondaryVolumeCY,
        count(
            distinct
            case
                when PaymentStatus = 'RECY' then SectionKey
                else null
            end 
        ) RECYVolumeCY,
        sum(
            case
                when FirstPayment = 1 then LeadTime
                else 0
            end 
        ) PrimaryLeadTimeCY,
        sum(
            case
                when FirstPayment = 0 then LeadTime
                else 0
            end 
        ) SecondaryLeadTimeCY,
        sum(
            case
                when PaymentStatus = 'RECY' then LeadTime
                else 0
            end 
        ) RECYLeadTimeCY,
        0 PrimaryPaymentsPY,
        0 SecondaryPaymentsPY,
        0 VolumePY,
		0 ClaimCountPY,
        0 SecondaryVolumePY,
        0 RECYVolumePY,
        0 PrimaryLeadTimePY,
        0 SecondaryLeadTimePY,
        0 RECYLeadTimePY,
        @start StartDate,
        @end EndDate
    from
        #payments
    where
        PaymentDate >= @start and
        PaymentDate <  dateadd(day,1 , @end)
    group by
        convert(date, convert(varchar(7), PaymentDate, 120) + '-01'),
		SuperGroup,
        BenefitCategory

    union

    select 
        convert(date, convert(varchar(7), dateadd(year, 1, PaymentDate), 120) + '-01') [PaymentMonth],
		SuperGroup,							
        BenefitCategory,
        0 PrimaryPaymentsCY,
        0 SecondaryPaymentsCY,
        0 VolumeCY,
		0 ClaimCountCY,
        0 SecondaryVolumeCY,
        0 RECYVolumeCY,
        0 PrimaryLeadTimeCY,
        0 SecondaryLeadTimeCY,
        0 RECYLeadTimeCY,
        sum(
            case
                when FirstPayment = 1 then PaymentMovement
                else 0
            end 
        ) PrimaryPaymentsPY,
        sum(
            case
                when FirstPayment = 1 then 0
                else PaymentMovement
            end 
        ) SecondaryPaymentsPY,
        count(SectionKey) VolumePY,
		count(distinct ClaimKey) ClaimCountPY,
        count(
            distinct
            case
                when FirstPayment = 0 then SectionKey
                else null
            end 
        ) SecondaryVolumePY,
        count(
            distinct
            case
                when PaymentStatus = 'RECY' then SectionKey
                else null
            end 
        ) RECYVolumePY,
        sum(
            case
                when FirstPayment = 1 then LeadTime
                else 0
            end 
        ) PrimaryLeadTimePY,
        sum(
            case
                when FirstPayment = 0 then LeadTime
                else 0
            end 
        ) SecondaryLeadTimePY,
        sum(
            case
                when PaymentStatus = 'RECY' then LeadTime
                else 0
            end 
        ) RECYLeadTimePY,
        @start StartDate,
        @end EndDate
    from
        #payments
    where
        PaymentDate >= dateadd(year, -1, @start) and
        PaymentDate <  dateadd(year, -1, dateadd(day,1 , @end))
    group by
        convert(date, convert(varchar(7), dateadd(year, 1, PaymentDate), 120) + '-01'),
		SuperGroup,
        BenefitCategory

end
GO
