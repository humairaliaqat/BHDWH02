USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_dashboard_livecarebase_calls]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rptsp_dashboard_livecarebase_calls]    
as    
begin    
    
    select     
        'MTD' [Period],    
        'Inbound' [Call Type],    
        case    
            when rp.GroupName is not null then GroupName    
            when CSQName like '%DTC%' then 'DTC'    
            when CSQName like '%CoverMore%' then 'Cover-More'    
            when CSQName like '%Cust_Care_Direct%' then 'Cover-More'    
            when CSQName like '%Health%' then 'Cover-More'    
            when CSQName like '%Customer_Service%' then 'Customer Service'    
            when CSQName like '%Concierge%' then 'Concierge'    
            when CSQName like '%key_client%' then 'Key Clients'    
            when CSQName like '%Malaysia%' then 'Malaysia'    
            when CSQName like '%MY_%' then 'Malaysia'    
            when CSQName like '%CN_%' then 'China'    
            when CSQName like '%TIP%' then 'TIP'    
            when CSQName like '%inbound%' then 'Inbound'    
            when CSQName like '%Medibank%' then 'Medibank'    
            when CSQName like '%Corporate%' then 'Corporate'    
            when CSQName like '%chubb%' then 'Chubb'    
            when CSQName like '%medical_consultant%' then 'Cover-More'    
            when CSQName like '%registered_nurses%' then 'Cover-More'    
            else 'Other'    
        end [Company Name],    
        cd.CSQName,    
        cd.AgentName,     
        cd.Team,    
        cd.SupervisorFlag,    
        cd.CallStartDateTime,    
        cd.CallEndDateTime,    
        cd.OriginatorNumber,    
        cd.DestinationNumber,    
        cd.DialedNumber as CalledNumber,    
        cd.GatewayNumber as OrigCalledNumber,    
        0 RingNoAnswer,    
        cd.CallsPresented,    
        cd.QueueHandled,    
        cd.QueueAbandoned,    
        cd.RingTime,    
        cd.TalkTime,    
        cd.HoldTime,    
        cd.WorkTime,    
        cd.WrapUpTime,    
        cd.QueueTime,    
        cd.MetServiceLevel,    
        cd.Transfer,    
        cd.Redirect,    
        cd.Conference    
    from    
        vTelephonyData cd    
  left join usrCallMapping as cm on (cd.GatewayNumber = cm.[Answer Point])    
        outer apply    
        (    
            select top 1     
                GroupName    
            from    
                cisRoutePoints rp    
            where    
                RoutePoint = cd.GatewayNumber    
        ) rp    
    where    
        (CallStartDateTime >= convert(date, convert(varchar(8), getdate(), 120) + '01')    
    and CallStartDateTime < convert(date, getdate()) )    
  and    
  cm.[Call Type] = 'Assistance'    
  and cd.ContactType in ('Incoming', 'Redirect in', 'Transfer in')    
  and cd.QueueTime <> 0    
    union     
    
    
    select     
        'MTD' [Period],    
        'Outbound' [Call Type],    
        'N/A' [Company Name],    
        'N/A' CSQName,    
  ag.AgentName,    
  ag.TeamName,    
        cd.SupervisorFlag,    
        cd.CallStartDateTime,    
        cd.CallEndDateTime,    
        cd.OriginatorNumber,    
        cd.DestinationNumber,    
        cd.DialedNumber as CalledNumber,    
        'N/A' OrigCalledNumber,    
        case    
            when cd.TalkTime = 0 then 1    
            else 0    
        end RingNoAnswer,    
  case     
   when len(cd.DialedNumber) > 4 then 1    
   else 0    
  end CallsPresented,    
        case    
            when cd.TalkTime > 0 then 1    
            else 0    
        end CallsHandled,    
        0 CallsAbandoned,    
        0 RingTime,    
        cd.TalkTime,    
        0 HoldTime,    
        0 WorkTime,    
        0 WrapUpTime,    
        0 QueueTime,    
        0 MetServiceLevel,    
        0 Transfer,    
        0 Redirect,    
        0 Conference    
    from    
  ciscalls cd    
  join cisAgent ag on (cd.OriginatorExt = ag.Extension and     
    ag.TeamName like 'AU Medical Assistance%'     
    and ag.isActive = '1'    
    )    
 where    
        (CallStartDateTime >= convert(date, convert(varchar(8), getdate(), 120) + '01')     
   and CallStartDateTime < convert(date, getdate()) )    
  and     
  ag.AgentName not in ('Cheryl Hood', 'Debra Harvey')    
  and cd.ContactType = 'Outgoing'    
    
    /*
    union    
    
    select     
        'Today' [Period],    
        'Inbound' [Call Type],    
        case    
            when rp.GroupName is not null then GroupName    
            when CSQName like '%DTC%' then 'DTC'    
            when CSQName like '%CoverMore%' then 'Cover-More'    
            when CSQName like '%Cust_Care_Direct%' then 'Cover-More'    
            when CSQName like '%Health%' then 'Cover-More'    
            when CSQName like '%Customer_Service%' then 'Customer Service'    
            when CSQName like '%Concierge%' then 'Concierge'    
            when CSQName like '%key_client%' then 'Key Clients'    
            when CSQName like '%Malaysia%' then 'Malaysia'    
            when CSQName like '%MY_%' then 'Malaysia'    
            when CSQName like '%CN_%' then 'China'    
            when CSQName like '%TIP%' then 'TIP'    
            when CSQName like '%inbound%' then 'Inbound'    
            when CSQName like '%Medibank%' then 'Medibank'    
            when CSQName like '%Corporate%' then 'Corporate'    
            when CSQName like '%chubb%' then 'Chubb'    
            when CSQName like '%medical_consultant%' then 'Cover-More'    
            when CSQName like '%registered_nurses%' then 'Cover-More'    
            else 'Other'    
        end [Company Name],    
        cd.CSQName,    
        cd.Agent,     
        cd.Team,    
        cd.SupervisorFlag,    
        cd.CallStartDateTime,    
        cd.CallEndDateTime,    
        cd.OriginatorNumber,    
        cd.DestinationNumber,    
        cd.CalledNumber,    
        cd.OrigCalledNumber,    
        cd.RingNoAnswer,    
  case     
   when cd.TalkTime > 30 then 1    
   else 0    
  end CallsPresented,    
        cd.CallsHandled,    
        cd.CallsAbandoned,    
        cd.RingTime,    
        cd.TalkTime,    
        cd.HoldTime,    
        cd.WorkTime,    
        cd.WrapUpTime,    
        cd.QueueTime,    
        cd.MetServiceLevel,    
        cd.Transfer,    
        cd.Redirect,    
        cd.Conference    
    from    
        vTelephonyLiveCallData cd    
  left join usrCallMapping as cm on (cd.OrigCalledNumber = cm.[Answer Point])    
        outer apply    
        (    
            select top 1     
                GroupName    
            from    
                cisRoutePoints rp    
            where    
                RoutePoint = cd.OrigCalledNumber    
        ) rp    
    where    
    
  cm.[Call Type] = 'Assistance'    
  and cd.QueueTime <> 0    
 */ 
 /* union     -- commented on 15/07/2022 as the below code cannot distinguish CBA from non-CBA calls on ULDWH02
        
    select     
        'Today' [Period],    
        'Outbound' [Call Type],    
        'N/A' [Company Name],    
        'N/A' CSQName,    
        cd.Agent,    
        cd.Team,    
        cd.SupervisorFlag,    
        cd.CallStartDateTime,    
        cd.CallEndDateTime,    
        cd.OriginatorNumber,    
        cd.DestinationNumber,    
        cd.CalledNumber,    
        'N/A' OrigCalledNumber,    
        case    
            when TalkTime = 0 then 1    
            else 0    
        end RingNoAnswer,    
        1 CallsPresented,    
        case    
            when cd.TalkTime > 0 then 1    
            else 0    
        end CallsHandled,    
        0 CallsAbandoned,    
        0 RingTime,    
        cd.TalkTime TalkTime,    
        0 HoldTime,    
        0 WorkTime,    
        0 WrapUpTime,    
        0 QueueTime,    
        cast(0 as bit) MetServiceLevel,    
        0 Transfer,    
        0 Redirect,    
        0 Conference    
    from    
        vTelephonyLiveOutboundCallData cd    
    where    
        cd.team like 'AU Medical Assistance%'     
  and cd.Agent not in ('Cheryl Hood', 'Debra Harvey')    */
    
    
end 
GO
