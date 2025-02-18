USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_lexer_mergebydpid]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_lexer_mergebydpid]
    @StartDate date = null,
    @EndDate date = null

as
begin

--debug
--declare @StartDate date = null
--declare @EndDate date = null


    if object_id('tempdb..#lexMBPartyDPID') is not null
        drop table #lexMBPartyDPID

    --cluster by Name, DOB & DPID
    select 
        PartyName,
        DOB,
        DPID,
        AddressLine1,
        min(PartyID) PartyID
    into #lexMBPartyDPID 
    from
        [db-au-workspace]..lexMBPartyCl
    where
        (
            @StartDate is null or
            @EndDate is null or
            (
                @StartDate is not null and
                @EndDate is not null and
                IssueDate >= @StartDate and
                IssueDate <  dateadd(day, 1, @EndDate)
            )
        ) and
        PartyName <> '' and
        DPID is not null and
        DPID <> 0 and
        AddressLine1 is not null and
        AddressLine1 <> ''
    group by
        PartyName,
        DOB,
        DPID,
        AddressLine1

    --assign id to matched records 
    update t
    set
        t.PartyID = r.PartyID
    from
        #lexMBPartyDPID r
        inner join [db-au-workspace]..lexMBPartyCl t on
            t.PartyName = r.PartyName and
            t.DOB = r.DOB and
            t.DPID = r.DPID and
            t.AddressLine1 = r.AddressLine1
    where
        t.PartyID is null and
        isnull(t.PartyID, 0) <> r.PartyID and
        r.PartyID is not null

    --create new parties for unmatched records
    if object_id('[db-au-workspace]..lexMBParties') is null
    begin

        create table [db-au-workspace]..lexMBParties
        (
            PartyID bigint not null identity(1,1),
            HashedID varbinary(64),
            PartyName nvarchar(100),
            DOB datetime,
            AddressLine1 nvarchar(100),
            AddressLine2 nvarchar(100),
            PostCode nvarchar(50),
            Suburb nvarchar(50),
            State nvarchar(100),
            Country nvarchar(100),
            DPID bigint,
            PhoneNo varchar(50),
            EmailAddress nvarchar(255),
            MemberNumber nvarchar(255),
            MarketingConsent bit,
            MergedInto bigint,
            UpdateDateTime datetime not null default getdate()
        )

        create unique clustered index cidx on [db-au-workspace]..lexMBParties (PartyID)
        create index hidx on [db-au-workspace]..lexMBParties (HashedID)

    end

    insert into [db-au-workspace]..lexMBParties
    (
        PartyName,
        DOB,
        AddressLine1,
        AddressLine2,
        PostCode,
        Suburb,
        State,
        Country,
        DPID,
        PhoneNo,
        EmailAddress,
        MemberNumber,
        MarketingConsent,
        HashedID
    )
    select
        PartyName,
        DOB,
        AddressLine1,
        AddressLine2,
        PostCode,
        Suburb,
        State,
        Country,
        DPID,
        PhoneNo,
        EmailAddress,
        MemberNumber,
        MarketingConsent,
        HashedID
    from
        (
            select distinct
                t.PartyName,
                t.DOB,
                isnull(t.AddressLine1, '') AddressLine1,
                isnull(t.AddressLine2, '') AddressLine2,
                isnull(t.PostCode, '') PostCode,
                isnull(t.Suburb, '') Suburb,
                isnull(t.State, '') State,
                isnull(t.Country, '') Country,
                isnull(t.DPID, 0) DPID,
                isnull(t.PhoneNo, '') PhoneNo,
                isnull(t.EmailAddress, '') EmailAddress,
                isnull(t.MemberNumber, '') MemberNumber,
                isnull(t.MarketingConsent, 0) MarketingConsent,
                hashbytes
                (
                    'sha1',
                    t.PartyName +
                    convert(varchar(10), t.DOB, 120) +
                    isnull(t.AddressLine1, '') +
                    isnull(t.AddressLine2, '') +
                    isnull(t.PostCode, '') +
                    isnull(t.Suburb, '') +
                    isnull(t.State, '') +
                    isnull(t.Country, '') +
                    convert(varchar, isnull(t.DPID, 0)) +
                    isnull(t.PhoneNo, '') +
                    isnull(t.EmailAddress, '') +
                    isnull(t.MemberNumber, '') +
                    convert(varchar, isnull(t.MarketingConsent, 0))
                ) HashedID
            from
                [db-au-workspace]..lexMBPartyCl t
            where
                isnull(t.PartyName, '') <> '' and
                DPID is not null and
                DPID <> 0 and
                AddressLine1 is not null and
                AddressLine1 <> ''
        ) t
    where
        not exists
        (
            select
                null
            from
                [db-au-workspace]..lexMBParties r
            where
                r.HashedID = t.HashedID
        )


    --assign id of newly created parties
    update t
    set
        t.PartyID = r.FirstID
    from
        [db-au-workspace]..lexMBPartyCl t
        cross apply
        (
            select 
                min(isnull(r.MergedInto, r.PartyID)) FirstID
            from
                [db-au-workspace]..lexMBParties r
            where
                t.PartyName = r.PartyName and
                t.DOB = r.DOB and
                t.DPID = r.DPID and
                t.AddressLine1 = r.AddressLine1
        ) r
    where
        isnull(t.PartyID, 0) <> isnull(r.FirstID, 0) and
        t.DPID is not null and
        t.DPID <> 0 and
        t.AddressLine1 is not null and
        t.AddressLine1 <> '' and
        t.PartyID is null


    --merge party master based on phone
    if object_id('tempdb..#merge') is not null
        drop table #merge

    select
        t.PartyID,
        FirstID
    into #merge
    from
        [db-au-workspace]..lexMBParties t
        cross apply
        (
            select 
                min(isnull(r.MergedInto, r.PartyID)) FirstID
            from
                [db-au-workspace]..lexMBParties r
            where
                [db-au-workspace].dbo.fn_cleanname(t.PartyName) = [db-au-workspace].dbo.fn_cleanname(r.PartyName) and
                r.DOB = t.DOB and
                r.DPID = t.DPID and
                r.AddressLine1 = t.AddressLine1 and
                r.PartyID is not null
        ) r
    where 
        t.DPID is not null and
        t.DPID <> 0 and
        t.AddressLine1 is not null and
        t.AddressLine1 <> '' and
        isnull(t.MergedInto, 0) <> r.FirstID

    update t
    set
        t.UpdateDateTime =
            case
                when t.PartyID = r.FirstID then t.UpdateDateTime
                when t.MergedInto = r.FirstID then t.UpdateDateTime
                else getdate()
            end,
        t.MergedInto = r.FirstID
    from
        [db-au-workspace]..lexMBParties t
        inner join #merge r on
            r.PartyID = t.PartyID

    update t
    set
        t.UpdateDateTime =
            case
                when t.PartyID = r.FirstID then t.UpdateDateTime
                when t.MergedInto = r.FirstID then t.UpdateDateTime
                else getdate()
            end,
        t.MergedInto = r.FirstID
    from
        [db-au-workspace]..lexMBParties t
        inner join #merge r on
            r.PartyID = t.MergedInto

    --back propagate merged records changes
    --disabled for now (uid_3)
    --update t
    --set
    --    t.PartyID = r.MergedInto
    --from
    --    [db-au-workspace]..lexMBParties r
    --    inner join [db-au-workspace]..lexMBPartyCl t on
    --        t.PartyID = r.PartyID
    --where
    --    r.MergedInto is not null and
    --    r.MergedInto <> r.PartyID


end
GO
