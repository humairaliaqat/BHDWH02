USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyPortfolio]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penPolicyPortfolio]
    @Start date,
    @End date
    
as
begin

--20160623, LL, move over to glTransactions, replacing glTransactions

--declare 
--    @start date,
--    @end date
--select
--    @start = '2014-10-01',
--    @end = '2014-10-31'

    set nocount on
    
    --dump base data
    if object_id('tempdb..#policy') is not null
        drop table #policy

    --leisure
    select
        d.Date_SK,
        case 
            when right(d.Fiscal_Month_Of_Year, 3) = '013' then d.Fiscal_Month_Of_Year - 1 
            else d.Fiscal_Month_Of_Year 
        end [Fiscal Period],
        bu.[Business Unit],
        jv.JVCode [JV],
        o.OutletAlphaKey,
        pt.PolicyTransactionKey,
        pt.PolicyNumber [Policy Number],
        isnull(op.[CC Transaction], 0) [CC Transaction],
        pt.PostingDate [Posting Date],
        pc.FinanceProductCode [Product Code],
        pc.GLProductType [Product Type],
        pt.BasePolicyCount [Policy Count],
        pp.[Sell Price],
        pp.[NAP (incl Tax)] [Net Price],
        pp.[Premium],
        dr.[Distributor Recovery],
        case
            when jv.JVCode in ('51', '53') then 0 /*comm is not journaled for AP & MB*/
            else pp.[Agency Commission (excl GST)] 
        end [Agency Commission],
        ov.[Override]
    into #policy
    from
        [db-au-cba]..penPolicyTransSummary pt
        inner join [db-au-star]..Dim_Date d on
            d.[Date] = pt.PostingDate
        outer apply
        (
            select top 1
                1 [CC Transaction]
            from
                [db-au-cba]..penPayment op
            where
                op.PolicyTransactionKey = pt.PolicyTransactionKey
        ) op
        inner join [db-au-cba]..penOutlet o on
            o.OutletAlphaKey = pt.OutletAlphaKey and
            o.OutletStatus = 'Current'
        cross apply
        (
            select
                case
                    when o.CountryKey = 'AU' and o.CompanyKey = 'CM' then 'CMA'
                    when o.CountryKey = 'AU' and o.CompanyKey = 'TIP' then 'TIP'
                    when o.CountryKey = 'NZ' then 'TSN'
                    when o.CountryKey = 'UK' then 'CMU'
                    when o.CountryKey = 'MY' then 'MMA'
                    when o.CountryKey = 'SG' then 'MSI'
                    when o.CountryKey = 'CN' then 'XCH'
                    when o.CountryKey = 'IN' then 'XIN'
                    when o.CountryKey = 'US' then 'USA'
                end [Business Unit]
        ) bu
        inner join [db-au-cba]..vpenOutletJV jv on
            jv.OutletKey = o.OutletKey
        inner join [db-au-cba]..vPenguinPolicyPremiums pp on
            pp.PolicyTransactionKey = pt.PolicyTransactionKey
        inner join [db-au-cba]..vpenPolicyFinanceProductCode pc on
            pc.PolicyTransactionKey = pt.PolicyTransactionKey
        cross apply
        (
            select
                case
                    when 
                        o.SuperGroupName = 'Flight Centre' and 
                        pt.CompetitorName is not null 
                    then 
                        pp.[Unadjusted NAP (incl Tax)] - 
                        (
                            pp.[Sell Price] - 
                            case 
                                when pp.[Sell Price] * 0.05 > 30 then 30 
                                else pp.[Sell Price] * 0.05 
                            end
                        )
                    when o.AlphaCode = 'APN0002' then pp.[Sell Price] / 0.9 - pp.[Sell Price]
                    when o.AlphaCode = 'APN0005' then pp.[Unadjusted Sell Price] - pp.[Sell Price]
                    when o.AlphaCode = 'MBN0003' then pp.[Sell Price] / 0.7 - pp.[Sell Price]
                    else 0
                end [Distributor Recovery]
        ) dr
        cross apply
        (
            select
                case
                    when 
                        o.CountryKey = 'AU' and
                        o.SuperGroupName in ('Independents', 'Brokers') and
                        (
                            pt.ProductCode in ('CBP', 'CCP', 'CMB', 'CMO') or
                            (
                                pt.ProductCode = 'CME' and
                                o.GroupName = 'AMP Brokers'
                            )
                        )
                    then
                        pp.[Sell Price] *
                        case
                            when o.AlphaCode in ('AAW0418', 'AAW0428') then 0.02
                            when o.AlphaCode in ('AAV0274') then 0.08
                            when o.AlphaCode in ('AAN0380') then 0.05
                            when o.OutletName = 'AMP Brokers' then 0.05
                            when o.SubGroupName = 'True Independent Agents' and o.OutletName like '%counsellors%' then 0.02
                            when o.SubGroupName = 'HRG' then 0.02
                            when o.SubGroupName = 'CT Partners' then 0.02
                            when o.SubGroupName = 'Magellan' then 0.05
                            when o.SubGroupName = 'Breakaway Travel Affiliates' then 0.03
                            when o.SubGroupName = 'Steadfast Group' then 0.01
                            else 0
                        end
                    when o.SuperGroupName in ('Stella', 'TCIS') then pp.[Unadjusted Sell Price (excl GST)] * 0.06
                    else 0
                end [Override]
        ) ov
    where
        pt.PostingDate >= @start and
        pt.PostingDate <  dateadd(day, 1, @end)
        
    union

    --corporate
    select 
        d.Date_SK,
        case 
            when right(d.Fiscal_Month_Of_Year, 3) = '013' then d.Fiscal_Month_Of_Year - 1 
            else d.Fiscal_Month_Of_Year 
        end [Fiscal Period],
        bu.[Business Unit],
        jv.JVCode [JV],
        o.OutletAlphaKey,
        q.QuoteKey + 'CORP' + convert(varchar(50), q.PolicyNo) PolicyTransactionKey,
        convert(varchar(50), q.PolicyNo) [Policy Number],
        0 [CC Transaction],
        q.AccountingPeriod [Posting Date],
        'CMC' [Product Code],
        'Corporate' [Product Type],
        1 [Policy Count],
        q.UWSaleExGST + q.GSTGross [Sell Price],
        q.UWSaleExGST + q.GSTGross - q.AgtCommExGST - q.GSTAgtComm [Net Price],
        q.UWSaleExGST - q.DomStamp - q.IntStamp [Premium],
        0 [Distributor Recovery],
        q.AgtCommExGST [Agency Commission],
        ov.[Override]
    from
        (
            select
                q.QuoteKey,
                q.PolicyNo,
                q.CountryKey,
                q.AgencyCode,
                qt.AccountingPeriod,
                sum(isnull(qt.UWSaleExGST, 0)) UWSaleExGST,
                sum(isnull(qt.GSTGross, 0)) GSTGross,
                sum(isnull(qt.AgtCommExGST, 0)) AgtCommExGST,
                sum(isnull(qt.GSTAgtComm, 0)) GSTAgtComm,
                sum(isnull(qt.DomStamp, 0)) DomStamp,
                sum(isnull(qt.IntStamp, 0)) IntStamp
            from
                [db-au-cba]..corpQuotes q
                inner join [db-au-cba]..corpTaxes qt on
                    qt.QuoteKey = q.QuoteKey
            where
                qt.AccountingPeriod >= @start and
                qt.AccountingPeriod <  dateadd(day, 1, @end)
            group by
                q.QuoteKey,
                q.PolicyNo,
                q.CountryKey,
                q.AgencyCode,
                qt.AccountingPeriod
        ) q
        inner join [db-au-star]..Dim_Date d on
            d.[Date] = q.AccountingPeriod
        inner join [db-au-cba]..penOutlet o on
            o.CountryKey = q.CountryKey and
            o.AlphaCode = q.AgencyCode and
            o.OutletStatus = 'Current'
        cross apply
        (
            select
                case
                    when o.CountryKey = 'AU' and o.CompanyKey = 'CM' then 'CMA'
                    when o.CountryKey = 'AU' and o.CompanyKey = 'TIP' then 'TIP'
                    when o.CountryKey = 'NZ' then 'TSN'
                    when o.CountryKey = 'UK' then 'CMU'
                    when o.CountryKey = 'MY' then 'MMA'
                    when o.CountryKey = 'SG' then 'MSI'
                    when o.CountryKey = 'CN' then 'XCH'
                    when o.CountryKey = 'IN' then 'XIN'
                    when o.CountryKey = 'US' then 'USA'
                end [Business Unit]
        ) bu
        inner join [db-au-cba]..vpenOutletJV jv on
            jv.OutletKey = o.OutletKey
        cross apply
        (
            select
                case
                    when o.SuperGroupName in ('Stella', 'TCIS') then q.UWSaleExGST * 0.06
                    else 0
                end [Override]
        ) ov

    create nonclustered index idx on #policy ([Fiscal Period],[Business Unit],[JV]) include([Policy Count],[Premium],[Sell Price],[CC Transaction],[Net Price],[Product Code])
        
    --dump corresponding GL data
    if object_id('tempdb..#JVGroup') is not null
        drop table #JVGroup

    select distinct
        [Fiscal Period],
        [Business Unit],
        [JV]
    into #JVGroup
    from
        #policy p

    if object_id('tempdb..#gl') is not null
        drop table #gl

    select *
    into #gl
    from
        #JVGroup t
        outer apply
        (
            select 
                sum(
                    case
                        when gl.AccountCode in ('4116', '4124') then -GLAmount 
                        else 0
                    end 
                ) [Merchant Fee],
                sum(
                    case
                        when gl.AccountCode = '4104' then -GLAmount 
                        else 0
                    end 
                ) [Arrangement Fee],
                sum(
                    case
                        when gl.AccountCode = '4123' then -GLAmount 
                        else 0
                    end 
                ) [Pay Per Click],
                sum(
                    case
                        when gl.AccountCode = '4110' then -GLAmount 
                        else 0
                    end 
                ) [Commission Received - Care],
                sum(
                    case
                        when gl.AccountCode = '5250' then -GLAmount 
                        else 0
                    end 
                ) [Affiliate Commission],
                sum(
                    case
                        when gl.AccountCode in ('5310', '5340') then -GLAmount 
                        else 0
                    end 
                ) [Assistance Fees],
                sum(
                    case
                        when gl.AccountCode = '5300' then -GLAmount 
                        else 0
                    end 
                ) [Underwriter Net],
                sum(
                    case
                        when gl.AccountCode = '5320' then -GLAmount 
                        else 0
                    end 
                ) [Claims Expense],
                sum(
                    case
                        when gl.AccountCode = '5330' then -GLAmount 
                        else 0
                    end 
                ) [Underwriter Margin],
                sum(
                    case
                        when gl.AccountCode = '5200' then -GLAmount 
                        else 0
                    end 
                ) [GL Agent Commission],
                sum(
                    case
                        when gl.AccountCode = '4730' then -GLAmount 
                        else 0
                    end 
                ) [GL Distributor Recovery],
                sum(
                    case
                        when gl.AccountCode = '4700' then -GLAmount 
                        else 0
                    end 
                ) [GL Premium Income],
                sum(
                    case
                        when gl.AccountCode = '4103' then -GLAmount 
                        else 0
                    end 
                ) [GL Agency Overrides]
            from
                [db-au-cba]..glTransactions gl
            where
                gl.ScenarioCode = 'A' and
                gl.Period = t.[Fiscal Period] and
                
                --use individual business unit as CMG consolidation is converted to AUD
                --gl.BusinessUnit = 'CMG' and
                --gl.Source_Code = t.[Business Unit] and
                
                gl.BusinessUnit = t.[Business Unit] and
                --use client code for MMA & MSI
                (
                    (
                        gl.BusinessUnit not in ('MMA', 'MSI', 'TIP') and
                        gl.JointVentureCode = t.[JV] 
                    ) or
                    (
                        gl.BusinessUnit in ('MMA', 'MSI', 'TIP') and
                        gl.ClientCode = t.[JV] 
                    )
                ) and

                gl.AccountCode in 
                (
                    '4104',
                    '4110',
                    '4116',
                    '4124',
                    '4123',
                    '5250',
                    '5340',
                    '5330',
                    '5310',
                    '5300',
                    '5320',
                    --comparison reference
                    '4700',
                    '5200',
                    '4730',
                    '4103'
                )
        ) gl
        outer apply
        (
            select 
                sum(
                    case
                        when d.ParentDepartmentCode = 'Direct Departments' then -GLAmount
                        else 0
                    end
                ) [Direct Employment Expenses],
                sum(
                    case
                        when d.ParentDepartmentCode = 'Indirect Departments' then -GLAmount
                        else 0
                    end
                ) [Overhead Employment Expenses]
            from
                [db-au-cba]..glTransactions gl
                inner join [db-au-cba]..glDepartments d on
                    d.DepartmentCode = gl.DepartmentCode
            where
                gl.ScenarioCode = 'A' and
                gl.Period = t.[Fiscal Period] and
                gl.BusinessUnit = t.[Business Unit] and
                (
                    (
                        gl.BusinessUnit not in ('MMA', 'MSI', 'TIP') and
                        gl.JointVentureCode = t.[JV] 
                    ) or
                    (
                        gl.BusinessUnit in ('MMA', 'MSI', 'TIP') and
                        gl.ClientCode = t.[JV] 
                    )
                ) and
                gl.AccountCode in 
                (
                    select 
                        Descendant_Code
                    from
                        [db-au-star]..vAccountAncestors aa
                    where
                        aa.Account_Code = 'Emp Exp'
                )
        ) ee
        outer apply
        (
            select 
                sum(
                    case
                        when d.ParentDepartmentCode = 'Direct Departments' then -GLAmount
                        else 0
                    end
                ) [Direct Other Expenses],
                sum(
                    case
                        when d.ParentDepartmentCode = 'Indirect Departments' then -GLAmount
                        else 0
                    end
                ) [Overhead Other Expenses]
            from
                [db-au-cba]..glTransactions gl
                inner join [db-au-cba]..glDepartments d on
                    d.DepartmentCode = gl.DepartmentCode
            where
                gl.ScenarioCode = 'A' and
                gl.Period = t.[Fiscal Period] and
                gl.BusinessUnit = t.[Business Unit] and
                (
                    (
                        gl.BusinessUnit not in ('MMA', 'MSI', 'TIP') and
                        gl.JointVentureCode = t.[JV] 
                    ) or
                    (
                        gl.BusinessUnit in ('MMA', 'MSI', 'TIP') and
                        gl.ClientCode = t.[JV] 
                    )
                ) and
                gl.AccountCode in 
                (
                    select 
                        Descendant_Code
                    from
                        [db-au-star]..vAccountAncestors aa
                    where
                        aa.Account_Code = 'Other Exp'
                )
        ) oe
        outer apply
        (
            select 
                sum(-GLAmount) [Advertising, Research & Promotion]
            from
                [db-au-cba]..glTransactions gl
            where
                gl.ScenarioCode = 'A' and
                gl.Period = t.[Fiscal Period] and
                gl.BusinessUnit = t.[Business Unit] and
                (
                    (
                        gl.BusinessUnit not in ('MMA', 'MSI', 'TIP') and
                        gl.JointVentureCode = t.[JV] 
                    ) or
                    (
                        gl.BusinessUnit in ('MMA', 'MSI', 'TIP') and
                        gl.ClientCode = t.[JV] 
                    )
                ) and
                gl.AccountCode in 
                (
                    select 
                        Descendant_Code
                    from
                        [db-au-star]..vAccountAncestors aa
                    where
                        aa.Account_Code = 'Adv res prom'
                )
        ) adv
        outer apply
        (
            select 
                sum(-GLAmount) [Printing & Postage]
            from
                [db-au-cba]..glTransactions gl
            where
                gl.ScenarioCode = 'A' and
                gl.Period = t.[Fiscal Period] and
                gl.BusinessUnit = t.[Business Unit] and
                (
                    (
                        gl.BusinessUnit not in ('MMA', 'MSI', 'TIP') and
                        gl.JointVentureCode = t.[JV] 
                    ) or
                    (
                        gl.BusinessUnit in ('MMA', 'MSI', 'TIP') and
                        gl.ClientCode = t.[JV] 
                    )
                ) and
                gl.AccountCode in 
                (
                    select 
                        Descendant_Code
                    from
                        [db-au-star]..vAccountAncestors aa
                    where
                        aa.Account_Code = 'Print Post VC'
                )
        ) pnp
    order by
        JV,
        [Business Unit]
        

    create nonclustered index idx on #gl ([Fiscal Period],[Business Unit],[JV]) 
    include
    (
        [Merchant Fee],
        [Arrangement Fee],
        [Pay Per Click],
        [Assistance Fees],
        [Underwriter Net],
        [Claims Expense],
        [Underwriter Margin],
        [Direct Employment Expenses],
        [Overhead Employment Expenses],
        [Direct Other Expenses],
        [Overhead Other Expenses],
        [Advertising, Research & Promotion],
        [Printing & Postage],
        [GL Agent Commission],
        [GL Distributor Recovery],
        [GL Premium Income],
        [GL Agency Overrides],
        [Commission Received - Care],
        [Affiliate Commission]
    )
        
    if object_id('tempdb..#penPolicyPortfolio') is not null
        drop table #penPolicyPortfolio
        
    select 
        PolicyTransactionKey,
        o.OutletAlphaKey,
        [Posting Date],
        Date_SK,
        [Fiscal Period],
        o.AlphaCode [Alpha],
        [Business Unit],
        p.[JV],
        p.[Product Code],
        p.[Product Type],
        [Policy Number],
        [Policy Count],
        [Premium],
        [Distributor Recovery],
        [Agency Commission],
        [Override],
        isnull(
            case
                when [Total Credit Card] = 0 then 0
                else gl.[Merchant Fee] * (p.[Sell Price] * [CC Transaction]) / [Total Credit Card]
            end,
            0
        ) [Merchant Fee],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Arrangement Fee] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Arrangement Fee],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Pay Per Click] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Pay Per Click],
        isnull(
            case
                when [Total International Premium] = 0 then 0
                when [Product Code] not like 'I%' then 0
                else gl.[Assistance Fees] * p.[Premium] / [Total International Premium]
            end,
            0
        ) [Assistance Fees],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Underwriter Net] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Underwriter Net],
        isnull(
            case
                when [Total Policy Count] = 0 then 0
                else gl.[Claims Expense] * p.[Policy Count] / [Total Policy Count]
            end,
            0
        ) [Claims Expense],
        --isnull(
        --    case
        --        when [Total Policy Count] = 0 then 0
        --        else gl.[Claims Expense] * p.[Policy Count] / [Total Policy Count] * [Underlying Rate]
        --    end,
        --    0
        --) [Underlying Claims Expense],
        --isnull(
        --    case
        --        when [Total Policy Count] = 0 then 0
        --        else gl.[Claims Expense] * p.[Policy Count] / [Total Policy Count] * [Large Rate]
        --    end,
        --    0
        --) [Large Claims Expense],
        --isnull(
        --    case
        --        when [Total Policy Count] = 0 then 0
        --        else gl.[Claims Expense] * p.[Policy Count] / [Total Policy Count] * [Catastrophe Rate]
        --    end,
        --    0
        --) [Catastrophe Claims Expense],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Underwriter Margin] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Underwriter Margin],
        isnull(
            case
                --when [Total Premium] = 0 then 0
                --else gl.[Direct Employment Expenses] * p.[Premium] / [Total Premium]
                when [Total Policy Count] = 0 then 0
                else gl.[Direct Employment Expenses] * p.[Policy Count] / [Total Policy Count]
            end,
            0
        ) [Direct Employment Expenses],
        isnull(
            case
                --when [Total Premium] = 0 then 0
                --else gl.[Direct Other Expenses] * p.[Premium] / [Total Premium]
                when [Total Policy Count] = 0 then 0
                else gl.[Direct Other Expenses] * p.[Policy Count] / [Total Policy Count]
            end,
            0
        ) [Direct Other Expenses],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Advertising, Research & Promotion] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Advertising, Research & Promotion],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Printing & Postage] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Printing & Postage],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Overhead Employment Expenses] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Overhead Employment Expenses],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Overhead Other Expenses] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Overhead Other Expenses],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[GL Agent Commission] * p.[Premium] / [Total Premium]
            end,
            0
        ) [GL Agent Commission],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[GL Distributor Recovery] * p.[Premium] / [Total Premium]
            end,
            0
        ) [GL Distributor Recovery],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[GL Premium Income] * p.[Premium] / [Total Premium]
            end,
            0
        ) [GL Premium Income],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[GL Agency Overrides] * p.[Premium] / [Total Premium]
            end,
            0
        ) [GL Agency Overrides],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Commission Received - Care] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Commission Received - Care],
        isnull(
            case
                when [Total Premium] = 0 then 0
                else gl.[Affiliate Commission] * p.[Premium] / [Total Premium]
            end,
            0
        ) [Affiliate Commission]
    into #penPolicyPortfolio
    from
        #policy p
        inner join [db-au-cba]..penOutlet o on
            o.OutletAlphaKey = p.OutletAlphaKey and
            o.OutletStatus = 'Current'
        --outer apply
        --(
        --    select top 1
        --        case
        --            when TotalCost = 0 then 0
        --            else ult_u / TotalCost
        --        end [Underlying Rate],
        --        case
        --            when TotalCost = 0 then 0
        --            else ult_l / TotalCost
        --        end [Large Rate],
        --        case
        --            when TotalCost = 0 then 0
        --            else ult_c / TotalCost
        --        end [Catastrophe Rate]
        --    from
        --        [db-au-workspace]..ActuarialClaimCost acc
        --        cross apply
        --        (
        --            select
        --                ult_u + ult_l + ult_c TotalCost
        --        ) cc
        --    where
        --        o.CountryKey = 'AU' and
        --        o.AlphaCode = acc.alpha
        --) acc
        outer apply
        (
            select top 1 
                [Merchant Fee],
                [Arrangement Fee],
                [Pay Per Click],
                [Assistance Fees],
                [Underwriter Net],
                [Claims Expense],
                [Underwriter Margin],
                [Direct Employment Expenses],
                [Overhead Employment Expenses],
                [Direct Other Expenses],
                [Overhead Other Expenses],
                [Advertising, Research & Promotion],
                [Printing & Postage],
                [GL Agent Commission],
                [GL Distributor Recovery],
                [GL Premium Income],
                [GL Agency Overrides],
                [Commission Received - Care],
                [Affiliate Commission]
            from
                #gl gl
            where
                gl.[Fiscal Period] = p.[Fiscal Period] and
                gl.[Business Unit] = p.[Business Unit] and
                gl.[JV] = p.[JV]
        ) gl
        cross apply
        (
            select
                sum([Policy Count]) [Total Policy Count],
                sum([Premium]) [Total Premium],
                sum(
                    case
                        when [Product Code] like 'I%' then [Premium]
                        else 0
                    end
                ) [Total International Premium],
                sum([Sell Price] * [CC Transaction]) [Total Credit Card],
                sum([Sell Price]) [Total Sell Price],
                sum([Net Price]) [Total Net Price]
            from
                #policy r
            where
                r.[Fiscal Period] = p.[Fiscal Period] and
                r.[Business Unit] = p.[Business Unit] and
                r.[JV] = p.[JV]
        ) r

    if object_id('[db-au-cba]..penPolicyPortfolio') is null
    begin

        create table [db-au-cba]..[penPolicyPortfolio]
        (
            [BIRowID] bigint not null identity(1,1),
            [PolicyTransactionKey] varchar(41) null,
            [OutletAlphaKey] nvarchar(50) not null,
            [Posting Date] datetime null,
            [Date_SK] [int] not null,
            [Fiscal Period] [int] null,
            [Alpha] nvarchar(20) not null,
            [Business Unit] varchar(3) null,
            [JV] varchar(50) not null,
            [Product Code] nvarchar(50) null,
            [Product Type] varchar(50) null,
            [Policy Number] varchar(50) null,
            [Policy Count] int not null,
            [Premium] money null,
            [Distributor Recovery] money null,
            [Agency Commission] money null,
            [Override] money null,
            [Merchant Fee] money not null,
            [Arrangement Fee] money not null,
            [Pay Per Click] money not null,
            [Assistance Fees] money not null,
            [Underwriter Net] money not null,
            [Claims Expense] money not null,
            --[Underlying Claims Expense] money not null,
            --[Large Claims Expense] money not null,
            --[Catastrophe Claims Expense] money not null,
            [Underwriter Margin] money not null,
            [Direct Employment Expenses] money not null,
            [Direct Other Expenses] money not null,
            [Advertising, Research & Promotion] money not null,
            [Printing & Postage] money not null,
            [Overhead Employment Expenses] money not null,
            [Overhead Other Expenses] money not null,
            [GL Agent Commission] money not null,
            [GL Distributor Recovery] money not null,
            [GL Premium Income] money not null,
            [GL Agency Overrides] money not null,
            [Commission Received - Care] money not null,
            [Affiliate Commission] money not null
        )
        
        create clustered index idx_penPolicyPortfolio_BIRowID on [db-au-cba]..penPolicyPortfolio(BIRowID)
        create nonclustered index idx_penPolicyPortfolio_PolicyTransactionKey on [db-au-cba]..penPolicyPortfolio(PolicyTransactionKey, Date_SK)
        create nonclustered index idx_penPolicyPortfolio_Date_SK on [db-au-cba]..penPolicyPortfolio(Date_SK)
        create nonclustered index idx_penPolicyPortfolio_PostingDate on [db-au-cba]..penPolicyPortfolio([Posting Date]) 
            include
            (
                PolicyTransactionKey, 
                [Business Unit],
                [Policy Count],
                [Premium],
                [Distributor Recovery],
                [Agency Commission],
                [Override],
                [Merchant Fee],
                [Arrangement Fee],
                [Pay Per Click],
                [Assistance Fees],
                [Underwriter Net],
                [Claims Expense],
                --[Underlying Claims Expense],
                --[Large Claims Expense],
                --[Catastrophe Claims Expense],
                [Underwriter Margin],
                [Direct Employment Expenses],
                [Direct Other Expenses],
                [Advertising, Research & Promotion],
                [Printing & Postage],
                [Overhead Employment Expenses],
                [Overhead Other Expenses],
                [GL Agent Commission],
                [GL Distributor Recovery],
                [GL Premium Income],
                [GL Agency Overrides],
                [Commission Received - Care],
                [Affiliate Commission]
            )
        
    end


    begin transaction

    begin try

        merge into [db-au-cba].dbo.penPolicyPortfolio with(tablock) t
        using #penPolicyPortfolio s on
            s.PolicyTransactionKey = t.PolicyTransactionKey and
            s.Date_SK = t.Date_SK --corporate
            
        when matched then
            update 
            set
                [OutletAlphaKey] = s.[OutletAlphaKey],
                [Posting Date] = s.[Posting Date],
                [Date_SK] = s.[Date_SK],
                [Fiscal Period] = s.[Fiscal Period],
                [Alpha] = s.[Alpha],
                [Business Unit] = s.[Business Unit],
                [JV] = s.[JV],
                [Product Code] = s.[Product Code],
                [Product Type] = s.[Product Type],
                [Policy Number] = s.[Policy Number],
                [Policy Count] = s.[Policy Count],
                [Premium] = s.[Premium],
                [Distributor Recovery] = s.[Distributor Recovery],
                [Agency Commission] = s.[Agency Commission],
                [Override] = s.[Override],
                [Merchant Fee] = s.[Merchant Fee],
                [Arrangement Fee] = s.[Arrangement Fee],
                [Pay Per Click] = s.[Pay Per Click],
                [Assistance Fees] = s.[Assistance Fees],
                [Underwriter Net] = s.[Underwriter Net],
                [Claims Expense] = s.[Claims Expense],
                --[Underlying Claims Expense] = s.[Underlying Claims Expense],
                --[Large Claims Expense] = s.[Large Claims Expense],
                --[Catastrophe Claims Expense] = s.[Catastrophe Claims Expense],
                [Underwriter Margin] = s.[Underwriter Margin],
                [Direct Employment Expenses] = s.[Direct Employment Expenses],
                [Direct Other Expenses] = s.[Direct Other Expenses],
                [Advertising, Research & Promotion] = s.[Advertising, Research & Promotion],
                [Printing & Postage] = s.[Printing & Postage],
                [Overhead Employment Expenses] = s.[Overhead Employment Expenses],
                [Overhead Other Expenses] = s.[Overhead Other Expenses],
                [GL Agent Commission] = s.[GL Agent Commission],
                [GL Distributor Recovery] = s.[GL Distributor Recovery],
                [GL Premium Income] = s.[GL Premium Income],
                [GL Agency Overrides] = s.[GL Agency Overrides],
                [Commission Received - Care] = s.[Commission Received - Care],
                [Affiliate Commission] = s.[Affiliate Commission]

        when not matched then
            insert
            (
                [PolicyTransactionKey],
                [OutletAlphaKey],
                [Posting Date],
                [Date_SK],
                [Fiscal Period],
                [Alpha],
                [Business Unit],
                [JV],
                [Product Code],
                [Product Type],
                [Policy Number],
                [Policy Count],
                [Premium],
                [Distributor Recovery],
                [Agency Commission],
                [Override],
                [Merchant Fee],
                [Arrangement Fee],
                [Pay Per Click],
                [Assistance Fees],
                [Underwriter Net],
                [Claims Expense],
                --[Underlying Claims Expense],
                --[Large Claims Expense],
                --[Catastrophe Claims Expense],
                [Underwriter Margin],
                [Direct Employment Expenses],
                [Direct Other Expenses],
                [Advertising, Research & Promotion],
                [Printing & Postage],
                [Overhead Employment Expenses],
                [Overhead Other Expenses],
                [GL Agent Commission],
                [GL Distributor Recovery],
                [GL Premium Income],
                [GL Agency Overrides],
                [Commission Received - Care],
                [Affiliate Commission]
            )
            values
            (
                s.[PolicyTransactionKey],
                s.[OutletAlphaKey],
                s.[Posting Date],
                s.[Date_SK],
                s.[Fiscal Period],
                s.[Alpha],
                s.[Business Unit],
                s.[JV],
                s.[Product Code],
                s.[Product Type],
                s.[Policy Number],
                s.[Policy Count],
                s.[Premium],
                s.[Distributor Recovery],
                s.[Agency Commission],
                s.[Override],
                s.[Merchant Fee],
                s.[Arrangement Fee],
                s.[Pay Per Click],
                s.[Assistance Fees],
                s.[Underwriter Net],
                s.[Claims Expense],
                --s.[Underlying Claims Expense],
                --s.[Large Claims Expense],
                --s.[Catastrophe Claims Expense],
                s.[Underwriter Margin],
                s.[Direct Employment Expenses],
                s.[Direct Other Expenses],
                s.[Advertising, Research & Promotion],
                s.[Printing & Postage],
                s.[Overhead Employment Expenses],
                s.[Overhead Other Expenses],
                s.[GL Agent Commission],
                s.[GL Distributor Recovery],
                s.[GL Premium Income],
                s.[GL Agency Overrides],
                s.[Commission Received - Care],
                s.[Affiliate Commission]
            )
        ;
                    
        --select 
        --    '[' + COLUMN_NAME + '] = s.[' + COLUMN_NAME + '],',
        --    '[' + COLUMN_NAME + '],',
        --    's.[' + COLUMN_NAME + '],'
        --from
        --    [db-au-cba].INFORMATION_SCHEMA.COLUMNS
        --where
        --    table_name = 'penPolicyPortfolio'
            
    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'penPolicyPortfolio data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'penPolicyPortfolio'

    end catch

    if @@trancount > 0
        commit transaction

end


GO
