USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[cbDateSummary]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[cbDateSummary]
    @DateRange varchar(30) = 'Last 30 Days',
    @StartDate date = null,
    @EndDate date = null

as
begin
/*
    20130821 - LS - Create
*/    

    set nocount on

    declare 
        @datestart date,
        @dateend date
    
    if @DateRange = '_User Defined'
        select 
            @datestart = @StartDate,
            @dateend = @EndDate
            
    else
        select
            @datestart = StartDate,
            @dateend = EndDate
        from
            [db-au-cmdwh]..vDateRange
        where
            DateRange = @DateRange

    if object_id('[db-au-cmdwh].dbo.cbDateSummary') is null
    begin
    
        create table [db-au-cmdwh].dbo.cbDateSummary
        (
            [Date] datetime not null,
            ClientName varchar(25),
            Protocol varchar(10),
            Country varchar(25),
            DeletedCount int,
            AllCount int,
            AllAge int,
            OpenCount int,
            OpenAge int,
            OpenedCount int,
            ClosedCount int
        )
        
        create clustered index idx_cbDateSummary_Date on [db-au-cmdwh].dbo.cbDateSummary([Date])
        create index idx_cbDateSummary_ClientName on [db-au-cmdwh].dbo.cbDateSummary(ClientName)
        create index idx_cbDateSummary_Protocol on [db-au-cmdwh].dbo.cbDateSummary(Protocol)
        create index idx_cbDateSummary_Country on [db-au-cmdwh].dbo.cbDateSummary(Country)
    
    end
    else
    begin
    
        delete from [db-au-cmdwh].dbo.cbDateSummary
        where
            [Date] between @datestart and @dateend
    
    end

    insert into [db-au-cmdwh].dbo.cbDateSummary
    (
        [Date],
        ClientName,
        Protocol,
        Country,
        DeletedCount,
        AllCount,
        AllAge,
        OpenCount,
        OpenAge,
        OpenedCount,
        ClosedCount
    )
    select 
        d.Date,
        ClientName,
        Protocol,
        Country,
        isnull(DeletedCount, 0) DeletedCount,
        isnull(AllCount, 0) AllCount,
        isnull(AllAge, 0) AllAge,
        isnull(OpenCount, 0) OpenCount,
        isnull(OpenAge, 0) OpenAge,
        isnull(OpenedCount, 0) OpenedCount,
        isnull(ClosedCount, 0) ClosedCount
    from
        [db-au-cmdwh]..Calendar d
        cross apply
        (
            select distinct
                ClientName,
                Protocol,
                Country
            from    
                [db-au-cmdwh]..cbCase        
        ) cl
        outer apply
        (
            select 
                sum(AllCase) AllCount,
                sum(OpenCase) OpenCount,
                sum(AllAge) AllAge,
                sum(OpenAge) OpenAge,
                sum(DeletedCase) DeletedCount
            from
                [db-au-cmdwh]..cbCase c
                cross apply
                (
                    select
                        case
                            when c.IsDeleted = 1 then 1
                            else 0
                        end DeletedCase
                ) dc
                cross apply
                (
                    select
                        case
                            when c.IsDeleted = 0 then 1
                            else 0
                        end AllCase,
                        case
                            when c.IsDeleted = 0 then datediff(d, OpenDate, isnull(CloseDate, d.Date)) 
                            else 0
                        end AllAge,
                        case
                            when
                                c.IsDeleted = 0 and
                                (
                                    c.CloseDate >= dateadd(day, 1, d.Date) or
                                    c.CloseDate is null
                                ) then datediff(d, OpenDate, isnull(CloseDate, d.Date)) 
                            else 0
                        end OpenAge,
                        case
                            when 
                                c.IsDeleted = 0 and
                                (
                                    c.CloseDate >= dateadd(day, 1, d.Date) or
                                    c.CloseDate is null
                                ) then 1
                            else 0
                        end OpenCase
                ) oc
            where 
                c.OpenDate < dateadd(day, 1, d.Date) and
                c.ClientName = cl.ClientName and
                c.Protocol = cl.Protocol and
                c.Country = cl.Country
        ) c
        outer apply
        (
            select 
                count(CaseKey) OpenedCount
            from
                [db-au-cmdwh]..cbCase c
            where 
                c.OpenDate >= d.Date and
                c.OpenDate <  dateadd(day, 1, d.Date) and
                c.IsDeleted = 0 and
                c.ClientName = cl.ClientName and
                c.Protocol = cl.Protocol and
                c.Country = cl.Country
        ) oc
        outer apply
        (
            select 
                count(CaseKey) ClosedCount
            from
                [db-au-cmdwh]..cbCase c
            where 
                c.CloseDate >= d.Date and
                c.CloseDate <  dateadd(day, 1, d.Date) and
                c.IsDeleted = 0 and
                c.ClientName = cl.ClientName and
                c.Protocol = cl.Protocol and
                c.Country = cl.Country
        ) cc
    where
        d.Date between @datestart and @dateend

end
GO
