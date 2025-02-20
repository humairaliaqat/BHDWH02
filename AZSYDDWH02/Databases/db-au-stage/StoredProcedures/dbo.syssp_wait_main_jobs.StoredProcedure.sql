USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_wait_main_jobs]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
---exec [db-au-stage]..syssp_wait_main_jobs  
  
CREATE procedure [dbo].[syssp_wait_main_jobs]  
as  
begin  
--SD - Commented ETL104 wait job, now it will look for 4 successful jobs, instead of 5  
 declare   
  @success_count int,  
  @all_ok bit = 0  
  
 while @all_ok = 0  
 begin  

  select @success_count = ( -- passing value
  select   
   count(distinct t.JobName)  
  from  
   (  
    select  
     j.[name] JobName,  
     case  
      when h.run_status = 1 then 'OK'  
      else 'FAILED'  
     end as RunStatus,  
     convert(datetime, rtrim(h.run_date)) + (h.run_time * 9 + h.run_time % 10000 * 6 + h.run_time % 100 * 10) / 216e4 as RunTime,  
     left(right('000000' + convert(varchar(6), run_duration), 6),2) + ':' + substring(right('000000' + convert(varchar(6), run_duration), 6),3,2) + ':' + right(right('000000' + convert(varchar(6), run_duration), 6),2) as RunDuration  
    from  
     msdb.dbo.sysjobhistory h  
     inner join msdb.dbo.sysjobs j on  
      h.job_id = j.job_id and  
      h.step_id = 0  
    where  
     h.run_date = convert(varchar(8),getdate(),112) and  
     j.[name] in  
     (  
      'ETL004_Claims_Data_Model_CBA',  
      'ETL008_e5_Content_CBA',  
      'ETL021_Penguin_Data_Model_CBA',  
      'ETL028_Penguin_Data_Loader_CBA',  
      'ETL104_Impulse_Quotes_CBA'   
     ) and  
     h.run_status = 1  
    --order by 3  
   ) t  
   )
  
  if @success_count = 5  
  --if @success_count = 4  
   set @all_ok = 1  
  
  else  
   waitfor delay '00:01:00'  
  
  print @success_count  
  print @all_ok  
  
  
 end  
  
 print 'finished'  
  
end  
  
  
  
  
  
  
GO
