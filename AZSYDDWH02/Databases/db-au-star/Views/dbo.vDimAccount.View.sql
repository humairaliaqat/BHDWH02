USE [db-au-star]
GO
/****** Object:  View [dbo].[vDimAccount]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vDimAccount] as
SELECT        
    account.Account_SK, 
    account.Account_CODE, 
    account.Account_Desc, 
    account.Account_Operator, 
    account.Account_Order, 
    account.Account_Hierarchy_Type, 
    account.Parent_Account_SK, 
    account.Create_Date, 
    account.Update_Date, 
    account.Insert_Batch_ID, 
    account.Update_Batch_ID, 
    account.Account_Category, 
    account.Account_SID, 
    COALESCE (account.Account_CODE, '') + ' - ' + COALESCE (account.Account_Desc, '') AS Account_Code_Desc, 
    
    account.FIPAccount,
    account.SAPPE3Account,
    account.FIPTOB,
    account.SAPTOB,
    account.TOM,
    account.AccountType,
    account.StatutoryMapping,
    account.InternalMapping,
    account.Technical,
    account.Intercompany,


    parent_account.Account_CODE AS Parent_Account_Code, 
    parent_account.Account_Desc AS Parent_Account_Desc
FROM            
    Dim_Account AS account 
    LEFT OUTER JOIN Dim_Account AS parent_account ON 
        account.Parent_Account_SK = parent_account.Account_SK
GO
