USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penDistributor]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penDistributor]
as
begin
/*
20151027 - DM - Penguin v16 Release, New Stored Proc
20160321 - LT - Penguin 18.0, Added US Penguin instance
*/

    set nocount on

    if object_id('[db-au-stage].dbo.etl_penDistributor') is not null
        drop table [db-au-stage].dbo.etl_penDistributor

    select
		CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, a.Distributorid) as DistributorKey,
        Distributorid,
		Name,
		Code,
		Urls,
		DistributorAPIKeys,
		[Status],
		CreateDateTime,
		UpdateDateTime,
		DomainId
    into [db-au-stage].dbo.etl_penDistributor
    from
        penguin_tblDistributor_aucm a
        cross apply dbo.fn_GetDomainKeys(a.DomainID, 'CM', 'AU') dk


    if object_id('[db-au-cba].dbo.penDistributor') is null
    begin

        create table [db-au-cba].dbo.penDistributor
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
			[DomainKey] varchar(41) null,
            [DistributorKey] varchar(41) null,
			[DistributorId] [int] NOT NULL,
			[Name] [nvarchar](255) NOT NULL,
			[Code] [nvarchar](10) NOT NULL,
			[Urls] [nvarchar](2000) NOT NULL,
			[DistributorAPIKeys] [nvarchar](1000) NOT NULL,
			[Status] [varchar](15) NOT NULL,
			[CreateDateTime] [datetime] NOT NULL,
			[UpdateDateTime] [datetime] NOT NULL,
			[DomainId] [int] NOT NULL
        )

        create clustered index idx_penDistributor_DistributorKey on [db-au-cba].dbo.penDistributor([DistributorKey])

    end
    else
    begin

        delete from [db-au-cba].dbo.penDistributor
        where
            [DistributorKey] in
            (
                select [DistributorKey]
                from
                   [db-au-stage].dbo.etl_penDistributor
            )

    end


    insert [db-au-cba].dbo.penDistributor with(tablockx)
    (
        [CountryKey],
        [CompanyKey],
		[DomainKey],
        [DistributorKey],
		[DistributorId],
		[Name],
		[Code],
		[Urls],
		[DistributorAPIKeys],
		[Status],
		[CreateDateTime],
		[UpdateDateTime],
		[DomainId]
    )
    select
         [CountryKey],
        [CompanyKey],
		[DomainKey],
        [DistributorKey],
		[DistributorId],
		[Name],
		[Code],
		[Urls],
		[DistributorAPIKeys],
		[Status],
		[CreateDateTime],
		[UpdateDateTime],
		[DomainId]
    from
        [db-au-stage].dbo.etl_penDistributor

end



GO
