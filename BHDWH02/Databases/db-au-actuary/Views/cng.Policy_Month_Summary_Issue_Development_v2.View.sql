USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Month_Summary_Issue_Development_v2]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Month_Summary_Issue_Development_v2] AS

SELECT 
     'Issue' AS [Date Type]
    ,[Domain Country]
    ,[Policy Status]
    ,[Policy Status Detailed]
    ,COALESCE([UW Policy Status],'Not in UW Returns') AS [UW Policy Status]
    ,[UW Rating Group]
    ,COALESCE([UW JV Description Orig],[JV Description]) AS [JV]
    ,[Outlet Channel]
    ,[Product Code]
    ,[Plan Code]
    ,[Product Plan]
    ,[Product Group]
    ,[Policy Type]
    ,[Plan Type]
    ,[Trip Type]
    ,[CFAR Flag]
    ,CAST(EOMONTH([Issue Date]) AS datetime) AS [Issue Month]
    ,CAST(EOMONTH([Exposure Month]) AS datetime) AS [Exposure Month]
    ,[IssueDevelopmentMonth]

    ,SUM([Lead Days]) AS [Lead Days]
    ,SUM([Trip Days]) AS [Trip Days]

    ,SUM([Earned Policy %]    ) AS [Policy]
    ,SUM([Earned Policy MED %]) AS [Policy MED]
    ,SUM([Earned Policy CAN %]) AS [Policy CAN]
    ,SUM([Earned Policy ADD %]) AS [Policy ADD]
    ,SUM([Earned Policy MIS %]) AS [Policy MIS]

    ,SUM(CASE WHEN [Policy Status] = 'Active' THEN [Earned Policy %]     ELSE 0 END) AS [Policy - Active]
    ,SUM(CASE WHEN [Policy Status] = 'Active' THEN [Earned Policy MED %] ELSE 0 END) AS [Policy MED - Active]
    ,SUM(CASE WHEN [Policy Status] = 'Active' THEN [Earned Policy CAN %] ELSE 0 END) AS [Policy CAN - Active]
    ,SUM(CASE WHEN [Policy Status] = 'Active' THEN [Earned Policy ADD %] ELSE 0 END) AS [Policy ADD - Active]
    ,SUM(CASE WHEN [Policy Status] = 'Active' THEN [Earned Policy MIS %] ELSE 0 END) AS [Policy MIS - Active]

    ,SUM(CASE WHEN [Policy Status] = 'Cancelled' THEN [Earned Policy %]     ELSE 0 END) AS [Policy - Cancelled]
    ,SUM(CASE WHEN [Policy Status] = 'Cancelled' THEN [Earned Policy MED %] ELSE 0 END) AS [Policy MED - Cancelled]
    ,SUM(CASE WHEN [Policy Status] = 'Cancelled' THEN [Earned Policy CAN %] ELSE 0 END) AS [Policy CAN - Cancelled]
    ,SUM(CASE WHEN [Policy Status] = 'Cancelled' THEN [Earned Policy ADD %] ELSE 0 END) AS [Policy ADD - Cancelled]
    ,SUM(CASE WHEN [Policy Status] = 'Cancelled' THEN [Earned Policy MIS %] ELSE 0 END) AS [Policy MIS - Cancelled]

    ,SUM([Refund Premium %]     * [Sell Price - Active]             ) AS [Sell Price - Refund]

    ,SUM([Earned Premium %]     * [Sell Price - Active]             ) AS [Sell Price - Active]
    ,SUM([Earned Premium %]     * [Sell Price - Cancelled]          ) AS [Sell Price - Cancelled]
    ,SUM([Earned Premium %]     * [Sell Price]                      ) AS [Sell Price]
    ,SUM([Earned Premium %]     * [Premium - Active]                ) AS [Premium - Active]
    ,SUM([Earned Premium %]     * [Premium - Cancelled]             ) AS [Premium - Cancelled]
    ,SUM([Earned Premium %]     * [Premium]                         ) AS [Premium]
    ,SUM([Earned Premium %]     * [Agency Commission]               ) AS [Commission]
    ,SUM([Earned Premium %]     * [NAP]                             ) AS [NAP]
    ,SUM([Earned Premium %]     * [GST on Sell Price]               ) AS [GST on Sell Price]
    ,SUM([Earned Premium %]     * [GST on Agency Commission]        ) AS [GST on Agency Commission]
    ,SUM([Earned Premium %]     * [Stamp Duty on Sell Price]        ) AS [Stamp Duty on Sell Price]
    ,SUM([Earned Premium %]     * [Stamp Duty on Agency Commission] ) AS [Stamp Duty on Agency Commission]

    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium]            ) +
     SUM([Earned Premium %]     * [UW Premium COVID19]    ) ELSE 
     SUM([Earned Premium %]     * [UW Premium]            ) +  
     SUM([Earned Premium %]     * [UW Premium COVID19]    ) +
     SUM([Earned Premium CAN %] * [UW Premium]            ) 
     END                                                    AS [UW Premium]
    ,SUM([Earned Premium MED %] * [UW Premium] * 1.00/1.04) AS [UW Premium MED]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium CAN %] * [UW Premium] * 1.00/1.04) ELSE 
     SUM([Earned Premium CAN %] * [UW Premium] * 2.00/1.04) 
     END                                                    AS [UW Premium CAN]
    ,SUM([Earned Premium ADD %] * [UW Premium] * 1.00/1.04) AS [UW Premium ADD]
    ,SUM([Earned Premium MIS %] * [UW Premium] * 1.00/1.04) AS [UW Premium MIS]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium] * 1.00/1.04) ELSE 
     SUM([Earned Premium %]     * [UW Premium] * 1.00/1.04) +  
     SUM([Earned Premium CAN %] * [UW Premium] * 1.00/1.04) 
     END                                                    AS [UW Premium UDL]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium] * 0.04/1.04) ELSE 
     SUM([Earned Premium %]     * [UW Premium] * 0.04/1.04) +
     SUM([Earned Premium CAN %] * [UW Premium] * 0.04/1.04) 
     END                                                    AS [UW Premium CAT]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium COVID19]    ) ELSE 
     SUM([Earned Premium %]     * [UW Premium COVID19]    ) 
     END                                                    AS [UW Premium COV]

    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium Current]            ) +
     SUM([Earned Premium %]     * [UW Premium COVID19] * 0) ELSE 
     SUM([Earned Premium %]     * [UW Premium Current]            ) +  
     SUM([Earned Premium %]     * [UW Premium COVID19] * 0) +
     SUM([Earned Premium CAN %] * [UW Premium Current]            ) 
     END															AS [UW Premium Current]
    ,SUM([Earned Premium MED %] * [UW Premium Current] * 1.00/1.04) AS [UW Premium Current MED]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium CAN %] * [UW Premium Current] * 1.00/1.04) ELSE 
     SUM([Earned Premium CAN %] * [UW Premium Current] * 2.00/1.04) 
     END															AS [UW Premium Current CAN]
    ,SUM([Earned Premium ADD %] * [UW Premium Current] * 1.00/1.04) AS [UW Premium Current ADD]
    ,SUM([Earned Premium MIS %] * [UW Premium Current] * 1.00/1.04) AS [UW Premium Current MIS]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium Current] * 1.00/1.04) ELSE 
     SUM([Earned Premium %]     * [UW Premium Current] * 1.00/1.04) +  
     SUM([Earned Premium CAN %] * [UW Premium Current] * 1.00/1.04) 
     END															AS [UW Premium Current UDL]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium Current] * 0.04/1.04) ELSE 
     SUM([Earned Premium %]     * [UW Premium Current] * 0.04/1.04) +
     SUM([Earned Premium CAN %] * [UW Premium Current] * 0.04/1.04) 
     END															AS [UW Premium Current CAT]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [UW Premium COVID19] * 0) ELSE 
     SUM([Earned Premium %]     * [UW Premium COVID19] * 0) 
     END															AS [UW Premium Current COV]

    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [Target Cost]            ) +
     SUM([Earned Premium %]     * [Target Cost COVID19]    ) ELSE 
     SUM([Earned Premium %]     * [Target Cost]            ) + 
     SUM([Earned Premium %]     * [Target Cost COVID19]    ) +
     SUM([Earned Premium CAN %] * [Target Cost]            ) 
     END                                                     AS [Target Cost]
    ,SUM([Earned Premium MED %] * [Target Cost] * 1.00/1.04) AS [Target Cost MED]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium CAN %] * [Target Cost] * 1.00/1.04) ELSE 
     SUM([Earned Premium CAN %] * [Target Cost] * 2.00/1.04) 
     END                                                     AS [Target Cost CAN]
    ,SUM([Earned Premium ADD %] * [Target Cost] * 1.00/1.04) AS [Target Cost ADD]
    ,SUM([Earned Premium MIS %] * [Target Cost] * 1.00/1.04) AS [Target Cost MIS]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [Target Cost] * 1.00/1.04) ELSE 
     SUM([Earned Premium %]     * [Target Cost] * 1.00/1.04) +  
     SUM([Earned Premium CAN %] * [Target Cost] * 1.00/1.04) 
     END                                                     AS [Target Cost UDL]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [Target Cost] * 0.04/1.04) ELSE 
     SUM([Earned Premium %]     * [Target Cost] * 0.04/1.04) +
     SUM([Earned Premium CAN %] * [Target Cost] * 0.04/1.04) 
     END                                                     AS [Target Cost CAT]
    ,CASE WHEN [CFAR Flag] = 'No' THEN 
     SUM([Earned Premium %]     * [Target Cost COVID19]    ) ELSE 
     SUM([Earned Premium %]     * [Target Cost COVID19]    ) 
     END                                                     AS [Target Cost COV]

    ,SUM([ClaimCount]                      ) AS [Claims]
    ,SUM([SectionCount]                    ) AS [Sections]
    ,SUM([NetPaymentMovementIncRecoveries] ) AS [Payments]
    ,SUM([NetIncurredMovementIncRecoveries]) AS [Incurred]

    ,SUM(CASE WHEN [Section] = 'MED'     THEN [SectionCount]                     ELSE 0 END) AS [Sections MED]
    ,SUM(CASE WHEN [Section] = 'MED'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED]
    ,SUM(CASE WHEN [Section] = 'MED'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED]
    ,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections MED_LGE]
    ,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MED_LGE]
    ,SUM(CASE WHEN [Section] = 'MED_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MED_LGE]

    ,SUM(CASE WHEN [Section] = 'CAN'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN]
    ,SUM(CASE WHEN [Section] = 'CAN'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN]
    ,SUM(CASE WHEN [Section] = 'CAN'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN]
    ,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections CAN_LGE]
    ,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAN_LGE]
    ,SUM(CASE WHEN [Section] = 'CAN_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAN_LGE]

    --,SUM(CASE WHEN [Section] = 'CFR'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CFR]
    --,SUM(CASE WHEN [Section] = 'CFR'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CFR]
    --,SUM(CASE WHEN [Section] = 'CFR'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CFR]
    --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections CFR_LGE]
    --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CFR_LGE]
    --,SUM(CASE WHEN [Section] = 'CFR_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CFR_LGE]

    ,SUM(CASE WHEN [Section] = 'ADD'     THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD]
    ,SUM(CASE WHEN [Section] = 'ADD'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD]
    ,SUM(CASE WHEN [Section] = 'ADD'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD]
    ,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections ADD_LGE]
    ,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments ADD_LGE]
    ,SUM(CASE WHEN [Section] = 'ADD_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred ADD_LGE]

    ,SUM(CASE WHEN [Section] = 'MIS'     THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS]
    ,SUM(CASE WHEN [Section] = 'MIS'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS]
    ,SUM(CASE WHEN [Section] = 'MIS'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS]
    ,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [SectionCount]                     ELSE 0 END) AS [Sections MIS_LGE]
    ,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments MIS_LGE]
    ,SUM(CASE WHEN [Section] = 'MIS_LGE' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred MIS_LGE]

    ,SUM(CASE WHEN [Section] = 'CAT'     THEN [SectionCount]                     ELSE 0 END) AS [Sections CAT]
    ,SUM(CASE WHEN [Section] = 'CAT'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments CAT]
    ,SUM(CASE WHEN [Section] = 'CAT'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred CAT]

    ,SUM(CASE WHEN [Section] = 'COV'     THEN [SectionCount]                     ELSE 0 END) AS [Sections COV]
    ,SUM(CASE WHEN [Section] = 'COV'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments COV]
    ,SUM(CASE WHEN [Section] = 'COV'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred COV]

    ,SUM(CASE WHEN [Section] = 'OTH'     THEN [SectionCount]                     ELSE 0 END) AS [Sections OTH]
    ,SUM(CASE WHEN [Section] = 'OTH'     THEN [NetPaymentMovementIncRecoveries]  ELSE 0 END) AS [Payments OTH]
    ,SUM(CASE WHEN [Section] = 'OTH'     THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [Incurred OTH]

FROM [db-au-actuary].[cng].[Policy_Month_Exposure_v2]
GROUP BY 
     [Domain Country]
    ,[Policy Status]
    ,[Policy Status Detailed]
    ,COALESCE([UW Policy Status],'Not in UW Returns')
    ,[UW Rating Group]
    ,COALESCE([UW JV Description Orig],[JV Description])
    ,[Outlet Channel]
    ,[Product Code]
    ,[Plan Code]
    ,[Product Plan]
    ,[Product Group]
    ,[Policy Type]
    ,[Plan Type]
    ,[Trip Type]
    ,[CFAR Flag]
    ,CAST(EOMONTH([Issue Date]) AS datetime)
    ,CAST(EOMONTH([Exposure Month]) AS datetime)
    ,[IssueDevelopmentMonth]
--ORDER BY
--     [Domain Country]
--    ,[Policy Status]
--    ,[Policy Status Detailed]
--    ,COALESCE([UW Policy Status],'Not in UW Returns')
--    ,[UW Rating Group]
--    ,COALESCE([UW JV Description Orig],[JV Description])
--    ,[Outlet Channel]
--    ,[Product Code]
--    ,[Plan Code]
--    ,[Product Plan]
--    ,[Product Group]
--    ,[Policy Type]
--    ,[Plan Type]
--    ,[Trip Type]
--    ,[CFAR Flag]
--    ,CAST(EOMONTH([Issue Date]) AS datetime)
--    ,YEAR([Issue Date])
;
GO
