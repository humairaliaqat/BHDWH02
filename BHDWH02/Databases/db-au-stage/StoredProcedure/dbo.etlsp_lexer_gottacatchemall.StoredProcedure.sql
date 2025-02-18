USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_lexer_gottacatchemall]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_lexer_gottacatchemall]
as
begin

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

    --create new parties for non match/merge able records
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
                t.PartyID is null and
                isnull(t.PartyName, '') <> '' and
                IssueDate < convert(date, getdate())
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
                min(r.PartyID) FirstID
            from
                [db-au-workspace]..lexMBParties r
            where
                r.UpdateDateTime >= convert(date, getdate()) and
                r.MergedInto is null and
                r.PartyName = t.PartyName and
                r.DOB = t.DOB and
                r.AddressLine1 = isnull(t.AddressLine1, '') and
                r.AddressLine2 = isnull(t.AddressLine2, '') and
                r.PostCode = isnull(t.PostCode, '') and
                r.Suburb = isnull(t.Suburb, '') and
                r.State = isnull(t.State, '') and
                r.Country = isnull(t.Country, '') and
                r.DPID = isnull(t.DPID, 0) and
                r.PhoneNo = isnull(t.PhoneNo, '') and
                r.EmailAddress = isnull(t.EmailAddress, '') and
                r.MemberNumber = isnull(t.MemberNumber, '') and
                r.MarketingConsent = isnull(t.MarketingConsent, 0)
        ) r
    where
        t.PartyID is null and
        isnull(t.PartyName, '') <> ''

    update [db-au-workspace]..lexMBParties
    set
        MergedInto = PartyID
    where
        MergedInto is null


end
GO
