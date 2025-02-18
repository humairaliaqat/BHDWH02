USE [db-au-stage]
GO
/****** Object:  View [dbo].[vNPSAPITopicCall]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[vNPSAPITopicCall]
as
select --top 1000
    BIRowID,
    replace(ltrim(rtrim(Reason)), char(13), ' ') Reason,
    ClassificationResponse,
    TopicResponse,
    SentimentResponse
from
    (
        select 
            BIRowID,
            isnull([Q2a#  Score reason], '') + '. ' +
            isnull([C5# Claim comment], '') + '. ' +
            isnull([M3# Case comment], '') + '. ' + 
            isnull([Is there anything else about your experience with the Global SIM], '') Reason,
            convert(nvarchar(4000), '') ClassificationResponse,
            convert(nvarchar(4000), '') TopicResponse,
            convert(nvarchar(4000), '') SentimentResponse
        from
            [db-au-cmdwh]..npsData
        where
            Topic is null 
            or
            len(Topic) < 200

    ) t
where
    ltrim(rtrim(Reason)) <> '' and
    ltrim(rtrim(replace(Reason, '.', ''))) <> '' and
    len(ltrim(rtrim(Reason))) >= 4 and
    len(ltrim(rtrim(Reason))) < 8000
--order by
--    BIRowID desc












GO
