USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimConsultant]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[v_ic_dimConsultant]
as
select 
    dc.*,
    ltrim(rtrim(isnull(u.[ConsultantID], ''))) [ConsultantID]
from
    dimConsultant dc
    outer apply
    (
        select top 1 
            u.Login [ConsultantID]
        from
            [db-au-cba].dbo.penUser u
        where
            u.UserKey = dc.ConsultantKey and
            u.UserStatus = 'Current'
    ) u

GO
