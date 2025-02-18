USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_flTicketView]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_flTicketView]    
    @ExtractDate date
     
as
begin

/****************************************************************************************************/
--Name:           dbo.etlsp_cmdwh_flTicketView
--Author:         Atit Wajanasomboonkul
--Date Created:   20150722
--Description:    This ETL stored procedure create view v_fltTicket_Lookup
--                which will be used to lookup with flight ticket staging data.
--              
--Parameters:     @ExtractDate:   
--                    Specify the date of source file extraction.
--
--Change History:    
--                20150722 - AW - Created
/****************************************************************************************************/

declare @SQL varchar(max)

/*
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
        WHERE TABLE_NAME = 'v_fltTicket_Lookup')
    DROP VIEW v_fltTicket_Lookup
GO
*/

if object_id('[db-au-stage].dbo.v_fltTicket_Lookup') is not null
        drop view v_fltTicket_Lookup

SELECT @SQL = 'CREATE VIEW v_fltTicket_Lookup
AS SELECT document_number, HashKey, BIRowID
   FROM [db-au-cmdwh].dbo.fltTicket
   Where isLatest = ''Y''
   And (local_Issue_date >= dateadd(month,-4, convert(datetime,''' + substring(convert(varchar(10),@ExtractDate,120),1,8) + '01''))
   Or Refunded_date >= dateadd(month,-12, convert(datetime,''' + substring(convert(varchar(10),@ExtractDate,120),1,8) + '01'')))'

Execute(@SQL)


end


GO
