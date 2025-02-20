USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cba_clmClaimTeam]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   procedure [dbo].[etlsp_cba_clmClaimTeam]  
as  
begin  
    --begin transaction  
    --begin try  
  execute  
  (  
   'exec xp_cmdshell ''copy "\\aust.covermore.com.au\data\NorthSydney_data\Business Intelligence Share\Claim\ClaimTeamCBA.xlsx" e:\etl\data\ClaimTeamCBA.xlsx /Y'''  -- CHG0036692
  )  at [BHDWH03]  

  waitfor delay '00:00:03'  
        truncate table [db-au-cba]..usrLDAPTeam  
        insert into [db-au-cba]..usrLDAPTeam  
        (  
            UserID,  
            TeamLeaderID,  
            isActive,  
            UserName,  
            TeamMember,  
            Email,  
            TLUserName,  
            TeamLeader  
        )  
        select  
            r.UserID,  
            rtl.UserID,  
   t.isActive,  
   t.[User Name],  
   t.[Team Member],  
   t.Email,  
   t.[TL User Name],  
   t.[Team Leader]  
        from  
            openrowset  
            (  
                'Microsoft.ACE.OLEDB.12.0',  
                'Excel 12.0 Xml;Database=\\bhdwh03\etl\data\ClaimTeamCBA.xlsx',  
                '  
                select  
                    *  
                from  
                    [ClaimTeam$]  
                '  
            ) t  
            outer apply  
            (  
                select top 1  
                    u.UserID  
                from  
                    [db-au-cba]..usrLDAP u  
                where  
                    u.UserName = ltrim(rtrim(t.[User Name]))  
            ) r  
           outer apply  
           (  
                select top 1  
                    u.UserID  
                from  
                    [db-au-cba]..usrLDAP u  
                where  
                    u.UserName = ltrim(rtrim(t.[TL User Name]))  
            ) rtl  
        where  
            [ID] is not null  
 
    --end try  
    --begin catch  
    --    if @@trancount > 0  
    --        rollback transaction   
    --end catch  
    --if @@trancount > 0  
   --    commit transaction   
end  



GO
