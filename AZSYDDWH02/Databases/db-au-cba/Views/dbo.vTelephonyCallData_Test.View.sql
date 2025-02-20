USE [db-au-cba]
GO
/****** Object:  View [dbo].[vTelephonyCallData_Test]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vTelephonyCallData_Test] 
as

/****************************************************************************************************/
--  Name:          vTelephonyCallData
--  Author:        LL
--  Date Created:  20190329
--  Description:   This view captures telephony call data 
--  
--  Change History: 20190329 - LL - Created
/****************************************************************************************************/

select 
	cd.SessionID,
    cd.Agent AgentName,
    cd.Team,
	ApplicationName, 
    case
        when CSQName = 'CC_CBA_Group' AND DialedNumber IN ('5646','5679','5680','5641','5060') THEN 'Commonwealth Bank'
		when CSQName = 'CC_CBA_Group' AND DialedNumber IN ('5624','5632','5633','5615','5061') THEN 'BankWest'
		when ApplicationName = 'AUCustomerServiceCBA' THEN 'Commonwealth Bank'
		when ApplicationName = 'AUMedicalAssistanceCBA' THEN 'Commonwealth Bank'
		when ApplicationName = 'AUCustomerServiceBankwest' THEN 'BankWest'
        else 'Other'
    end Company,
    cd.CSQName,
    convert(date, cd.CallStartDateTime) CallDate,
    cd.CallStartDateTime,
    cd.CallEndDateTime,
    cd.QueueDisposition Disposition,
    cd.OriginatorNumber,
    cd.DestinationNumber,
    cd.DialedNumber CalledNumber,
    cd.GatewayNumber OrigCalledNumber,
    1 CallsPresented,
    cd.QueueHandled CallsHandled,
    cd.QueueAbandoned CallsAbandoned,
    cd.RingTime,
    cd.TalkTime,
    cd.HoldTime,
    cd.WorkTime,
    cd.WrapUpTime,
    cd.QueueTime,
    cd.MetServiceLevel,
    cd.Transfer,
    cd.Redirect,
    cd.Conference,
    case
        when 
            cd.TargetType = 'CSQ' and
            cd.RingTime >= 0 and 
            cd.TalkTime = 0 
        then 1
        else 0
    end RNA,
	cd.ContactType
from
    cisCalls cd with(nolock)
GO
