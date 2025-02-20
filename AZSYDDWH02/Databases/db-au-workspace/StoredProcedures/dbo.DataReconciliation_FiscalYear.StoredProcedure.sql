USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[DataReconciliation_FiscalYear]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
    
CREATE  procedure [dbo].[DataReconciliation_FiscalYear]    
    @FiscalYear int = null    
    
as    
begin    
    
    declare     
        @sql varchar(max),    
        @startperiod date,    
        @endperiod date    
    
    select     
        @FiscalYear = isnull(@FiscalYear, CurFiscalYearNum)    
    from    
        [db-au-cba]..Calendar    
    where    
        [Date] = convert(date, getdate()-1)  ---- change for fiscalyear run    
    
    select     
        @startperiod = min([Date]),    
        @endperiod = max([Date])    
    from    
        [db-au-cba]..calendar    
    where    
        CurFiscalYearNum = @FiscalYear    
    
    --ODS        
    if object_id('[db-au-workspace]..recon_ods') is not null    
        drop table [db-au-workspace]..recon_ods    
    
    select     
        d.SUNPeriod,    
        o.CountryKey,    
        jv.JVCode,    
        jv.JVDescription,    
        ppc.FinanceProductCode,    
        sum(pt.BasePolicyCount) PolicyCount,    
        sum(pt.GrossPremium - pt.TaxAmountGST - pt.TaxAmountSD) Premium,    
        sum(pt.Commission + pt.GrossAdminFee) Commission    
    into [db-au-workspace]..recon_ods    
    from    
        [db-au-cba]..penPolicyTransSummary pt with(nolock)    
        inner join [db-au-cba]..penOutlet o with(nolock) on    
            o.OutletAlphaKey = pt.OutletAlphaKey and    
            o.OutletStatus = 'Current'    
        inner join [db-au-cba]..vpenOutletJV jv with(nolock) on    
            jv.OutletKey = o.OutletKey    
        inner join [db-au-cba]..vpenPolicyFinanceProductCode ppc with(nolock) on    
            ppc.PolicyTransactionKey = pt.PolicyTransactionKey    
        inner join [db-au-cba]..Calendar d with(nolock) on    
            d.[Date] = convert(date, pt.PostingDate)    
    where    
        o.CountryKey in ('AU', 'NZ', 'UK') and    
        pt.PostingDate >= @startperiod and    
        pt.PostingDate <  dateadd(day, 1, @endperiod)    
    group by    
        d.SUNPeriod,    
        o.CountryKey,    
        jv.JVCode,    
        jv.JVDescription,    
        ppc.FinanceProductCode    
    
    ----delete     
    ----from     
    ----    [db-au-workspace]..recon_ods     
    ----where    
    ----    FinanceProductCode = 'CMC'    
    
    insert into [db-au-workspace]..recon_ods    
    select    
        d.SUNPeriod,    
        o.CountryKey,    
        jv.JVCode,    
        jv.JVDescription,    
        'CMC' FinanceProductCode,    
        count(distinct q.QuoteKey) PolicyCount,    
        sum(isnull(ct.UWSaleExGST, 0)) - sum(isnull(ct.DomStamp, 0)) - sum(isnull(ct.IntStamp, 0)) Premium,    
        sum(isnull(ct.AgtCommExGST, 0)) + sum(isnull(ct.GSTAgtComm, 0)) Commission    
    from    
        [db-au-cba]..corpTaxes ct with(nolock)    
        right join [db-au-cba]..vcorpItems ci with(nolock) on     
            ci.QuoteKey = ct.QuoteKey and     
            ci.ItemID = ct.ItemID    
        right join [db-au-cba]..corpQuotes q with(nolock) on     
            q.QuoteKey = ci.QuoteKey    
        inner join [db-au-cba]..penOutlet o with(nolock) on     
            o.AlphaCode = q.AgencyCode and    
            o.CountryKey = q.CountryKey    
        inner join [db-au-cba]..vpenOutletJV jv with(nolock) on     
            o.OutletKey = jv.OutletKey    
        inner join [db-au-cba]..Calendar d with(nolock) on    
            d.[Date] = convert(date, isnull(ct.AccountingPeriod, q.IssuedDate))    
    where    
        o.CountryKey in ('AU', 'NZ', 'UK') and    
        q.PolicyNo is not null and    
        (    
            ct.PropBal = 'P' or    
            ct.AccountingPeriod is not null    
        ) and    
        d.[Date] >= @startperiod and    
        d.[Date] <  dateadd(day, 1, @endperiod) and    
        isnull(o.OutletStatus, 'Current') = 'Current'     
    group by    
        d.SUNPeriod,    
        o.CountryKey,    
        jv.JVDescription,    
        jv.JVCode    
    
    --GL    
    if object_id('[db-au-workspace]..recon_gl') is not null    
        drop table [db-au-workspace]..recon_gl    
    
    select     
        Period,    
        case    
            when BusinessUnit = 'IAU' then 'AU'    
            when BusinessUnit = 'CMU' then 'UK'    
            when BusinessUnit = 'TSN' then 'NZ'    
        end CountryKey,    
        jv.JVCode,    
        jv.JVDescription,    
        ProductCode,    
        sum(    
            case    
                when AccountCode = 'M0008' then -GLAmount    
                else 0    
            end    
        ) PolicyCount,    
        sum(    
            case    
                when AccountCode = '5200' then -GLAmount    
                else 0    
            end    
        ) Commission,    
        sum(    
            case    
                when AccountCode = '4700' then GLAmount    
                else 0    
            end    
        ) Premium    
    into [db-au-workspace]..recon_gl    
    from    
        [db-au-cba]..glTransactions gl with(nolock)    
        left join [db-au-cba]..glJointVentures jv with(nolock) on    
            jv.JVCode = gl.JointVentureCode    
    where    
        ScenarioCode = 'A' and    
        AccountCode in ('4700', '5200', 'M0008') and    
        BusinessUnit in ('IAU', 'CMU', 'TSN') and    
        Period in    
            (    
                select distinct    
                    SUNPeriod    
                from    
                    [db-au-cba]..Calendar    
                where    
                    Date between @startperiod and @endperiod    
            )    
    group by    
        Period,    
        BusinessUnit,    
        jv.JVCode,    
        jv.JVDescription,    
        ProductCode    
    
    --Actuarial    
    if object_id('[db-au-workspace]..recon_actuary') is not null    
        drop table [db-au-workspace]..recon_actuary    
    
    select     
        d.SUNPeriod,    
        ds.[Domain Country] CountryKey,    
        ds.[JV Code] JVCode,    
        ds.[JV Description] JVDescription,    
        ds.[Finance Product Code] FinanceProductCode,    
        sum(ds.[Policy Count]) PolicyCount,    
        sum(ds.Premium) Premium,    
        sum(ds.[Agency Commission]) Commission    
    into [db-au-workspace]..recon_actuary    
    from    
        [db-au-actuary].dbo.DWHDataSet ds with(nolock)    
        inner join [db-au-cba]..Calendar d with(nolock) on    
            d.[Date] = convert(date, ds.[Posting Date])    
    where    
        ds.[Domain Country] in ('AU', 'NZ', 'UK') and    
        ds.[Posting Date] >= @startperiod and    
        ds.[Posting Date] <  dateadd(day, 1, @endperiod)    
    group by    
        d.SUNPeriod,    
        ds.[Domain Country],    
        ds.[JV Code],    
        ds.[JV Description],    
        ds.[Finance Product Code]    
    
    
    if object_id('[db-au-workspace]..recon_actuary_summary') is not null    
        drop table [db-au-workspace]..recon_actuary_summary    
    
    select     
        d.SUNPeriod,    
        ds.[Domain Country] CountryKey,    
        ds.[JV Code] JVCode,    
        ds.[JV Description] JVDescription,    
        ds.[Finance Product Code] FinanceProductCode,    
        sum(ds.[Policy Count]) PolicyCount,    
        sum(ds.Premium) Premium,    
        sum(ds.[Agency Commission]) Commission    
    into [db-au-workspace]..recon_actuary_summary    
    from    
        [db-au-actuary].dbo.DWHDataSetSummary ds with(nolock)    
        inner join [db-au-cba]..Calendar d with(nolock) on    
            d.[Date] = convert(date, ds.[Posting Date])    
    where    
        ds.[Domain Country] in ('AU', 'NZ', 'UK') and    
        ds.[Posting Date] >= @startperiod and    
        ds.[Posting Date] <  dateadd(day, 1, @endperiod)    
    group by    
        d.SUNPeriod,    
        ds.[Domain Country],    
        ds.[JV Code],    
        ds.[JV Description],    
        ds.[Finance Product Code]    
    
    --Policy Cube    
    if object_id('[db-au-workspace]..recon_policycube') is not null    
        drop table [db-au-workspace]..recon_policycube    
    
    set @sql =    
    '    
    select     
convert(int, convert(nvarchar, "[Date].[Fiscal Month Of Year].[Fiscal Month Of Year].[MEMBER_CAPTION]")) SUNPeriod,    
        convert(varchar(5), "[Outlet].[Country].[Country].[MEMBER_CAPTION]") CountryKey,    
        convert(varchar(5), "[Outlet].[JV].[JV].[MEMBER_CAPTION]") JVCode,    
        convert(varchar(100), "[Outlet].[JV Desc].[JV Desc].[MEMBER_CAPTION]") JVDescription,    
        convert(varchar(100), "[Product].[Finance Product Code].[Finance Product Code].[MEMBER_CAPTION]") FinanceProductCode,    
        case    
            when charindex(''E'', "[Measures].[Policy Count]") > 0 then 0    
            else isnull(convert(int, convert(nvarchar(50), "[Measures].[Policy Count]")) , 0)    
        end +    
        case    
            when charindex(''E'', "[Measures].[Corporate Policy Count]") > 0 then 0    
            else isnull(convert(int, convert(nvarchar(50), "[Measures].[Corporate Policy Count]")), 0)    
        end PolicyCount,    
        case    
            when charindex(''E'', "[Measures].[Premium]") > 0 then 0    
            else isnull(convert(money, convert(nvarchar(50), "[Measures].[Premium]")), 0)    
        end +    
        case    
            when charindex(''E'', "[Measures].[Corporate Premium]") > 0 then 0    
            else isnull(convert(money, convert(nvarchar(50), "[Measures].[Corporate Premium]")), 0)    
        end Premium,    
        case    
            when charindex(''E'', "[Measures].[Commission]") > 0 then 0    
            else isnull(convert(money, convert(nvarchar(50), "[Measures].[Commission]")), 0)    
        end +    
        case    
            when charindex(''E'', "[Measures].[Corporate Commission]") > 0 then 0    
            else isnull(convert(money, convert(nvarchar(50), "[Measures].[Corporate Commission]")) , 0)    
        end Commission    
    from    
        openquery(    
            POLICYCUBECBA,    
            ''    
            select     
            {    
            [Measures].[Policy Count],    
            [Measures].[Commission],    
            [Measures].[Premium],    
            [Measures].[Corporate Policy Count],    
            [Measures].[Corporate Commission],    
            [Measures].[Corporate Premium]    
            } on columns,     
            non empty     
            CrossJoin(    
            [Date].[Fiscal Month Of Year].children,    
            [Outlet].[Country].children,    
            [Outlet].[JV Desc].children,     
            [Outlet].[JV].children,     
            [Product].[Finance Product Code].children    
            ) on rows      
            from     
            [Policy Cube CBA]     
            where     
            (    
            [Date].[Fiscal Year].&[' + convert(varchar, @FiscalYear) + ']    
     --[Date].[Fiscal Year].&[' + convert(varchar, '2021') + ']    
            )    
        ''    
        ) t    
    where    
        convert(varchar, "[Outlet].[Country].[Country].[MEMBER_CAPTION]") in (''AU'', ''NZ'', ''UK'')    
    '    
    
    select *    
    into [db-au-workspace]..recon_policycube    
    from    
        [db-au-workspace]..recon_ods    
    where    
        1 = 0    
    
    insert into [db-au-workspace]..recon_policycube    
    exec(@sql)    
    
    
    if object_id('[db-au-workspace]..recon_overall') is not null    
        drop table [db-au-workspace]..recon_overall    
    
    select     
        SUNPeriod,    
        CountryKey,    
        JVDescription,    
        JVCode,    
        replace(rtrim(FinanceProductCode), 'ICRP', 'CMC') FinanceProductCode,    
        PolicyCount ODS_PolicyCount,    
        Premium ODS_Premium,    
        Commission ODS_Commission,    
        0 GL_PolicyCount,    
        convert(money, 0) GL_Premium,    
        convert(money, 0) GL_Commission,    
        0 Act_PolicyCount,    
        convert(money, 0) Act_Premium,    
        convert(money, 0) Act_Commission,    
        0 ActS_PolicyCount,    
        convert(money, 0) ActS_Premium,    
        convert(money, 0) ActS_Commission,    
        0 PC_PolicyCount,    
        convert(money, 0) PC_Premium,    
        convert(money, 0) PC_Commission    
    into [db-au-workspace]..recon_overall    
    from    
        [db-au-workspace]..recon_ods o    
    
    union all    
    
    select    
        Period SUNPeriod,    
        CountryKey,    
        JVDescription,    
        JVCode,    
        replace(rtrim(ProductCode), 'ICRP', 'CMC') FinanceProductCode,    
        0 ODS_PolicyCount,    
        0 ODS_Premium,    
        0 ODS_Commission,    
        PolicyCount GL_PolicyCount,    
        Premium GL_Premium,    
        Commission GL_Commission,    
        0 Act_PolicyCount,    
        0 Act_Premium,    
        0 Act_Commission,    
        0 ActS_PolicyCount,          0 ActS_Premium,    
        0 ActS_Commission,    
        0 PC_PolicyCount,    
        0 PC_Premium,    
        0 PC_Commission    
    from    
        [db-au-workspace]..recon_gl    
    
    union all    
    
    select    
        SUNPeriod,    
        CountryKey,    
        JVDescription,    
        JVCode,    
        replace(rtrim(FinanceProductCode), 'ICRP', 'CMC') FinanceProductCode,    
        0 ODS_PolicyCount,    
        0 ODS_Premium,    
        0 ODS_Commission,    
        0 GL_PolicyCount,    
        0 GL_Premium,    
        0 GL_Commission,    
        PolicyCount Act_PolicyCount,    
        Premium Act_Premium,    
        Commission Act_Commission,    
        0 ActS_PolicyCount,    
        0 ActS_Premium,    
        0 ActS_Commission,    
        0 PC_PolicyCount,    
        0 PC_Premium,    
        0 PC_Commission    
    from    
        [db-au-workspace]..recon_actuary    
    
    union all    
    
    select    
        SUNPeriod,    
        CountryKey,    
        JVDescription,    
        JVCode,    
        replace(rtrim(FinanceProductCode), 'ICRP', 'CMC') FinanceProductCode,    
        0 ODS_PolicyCount,    
        0 ODS_Premium,    
        0 ODS_Commission,    
        0 GL_PolicyCount,    
        0 GL_Premium,    
        0 GL_Commission,    
        0 Act_PolicyCount,    
        0 Act_Premium,    
        0 Act_Commission,    
        PolicyCount ActS_PolicyCount,    
        Premium ActS_Premium,    
        Commission ActS_Commission,    
        0 PC_PolicyCount,    
        0 PC_Premium,    
        0 PC_Commission    
    from    
        [db-au-workspace]..recon_actuary_summary    
    
    union all    
    
    select    
        SUNPeriod,    
        CountryKey,    
        JVDescription,    
        JVCode,    
        replace(rtrim(FinanceProductCode), 'ICRP', 'CMC') FinanceProductCode,    
        0 ODS_PolicyCount,    
        0 ODS_Premium,    
        0 ODS_Commission,    
        0 GL_PolicyCount,    
        0 GL_Premium,    
        0 GL_Commission,    
        0 Act_PolicyCount,    
        0 Act_Premium,    
        0 Act_Commission,    
        0 ActS_PolicyCount,    
        0 ActS_Premium,    
        0 ActS_Commission,    
        PolicyCount PC_PolicyCount,    
        Premium PC_Premium,    
        Commission PC_Commission    
    from    
        [db-au-workspace]..recon_policycube    
    --where    
    --    FinanceProductCode in ('ICRP', 'CMC')    
    
end    
    
    
    
GO
