USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimDestination]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL032_dimDestination]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penCountry table available
Description:    dimDestination dimension table contains destination attributes.
Parameters:     @LoadType: value is Migration or Incremental
Change History:
                20131114 - LT - Procedure created
                20140429 - LT - Changed to join between penCountry and etl_excel_country to EQUAL JOIN. The rationale is any country not in
                                penCountry is not necessary.
                20140711 - PW - Removed type 2 attributes and applied full outer join to ABS to get complete dimension for statistics lookup
                20140725 - LT - Amended merge statement
                20140905 - LS - refactoring
                20150204 - LS - replace batch codes with standard batch logging
				20151216 - LT - Added merge matching criteria to also include src.Destination = dst.Destination. It seems DestinationID (CountryID) can be the
								same for more than 1 destination
				20160603 - PZ - Added logic to make 'Destination + DestinationID' unique in [db-au-stage].dbo.etl_dimDestination table.

*************************************************************************************************************************************/

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    exec syssp_getrunningbatch
        @SubjectArea = 'Policy Star',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @name = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @name,
        @LogStatus = 'Running'


    --create dimCRMUser if table does not exist
    if object_id('[db-au-star].dbo.dimDestination') is null
    begin
    
        create table [db-au-star].dbo.dimDestination
        (
            DestinationSK int identity(1,1) not null,
            DestinationID nvarchar(50) not null,
            Destination nvarchar(50) null,
            ISO3Code nvarchar(10) null,
            ISO2Code nvarchar(10) null,
            Continent nvarchar(100) null,
            SubContinent nvarchar(100) null,
            ABSCountry nvarchar(200) null,
            ABSArea nvarchar(200) null,
            LoadDate datetime not null,
            updateDate datetime null,
            LoadID int not null,
            updateID int null,
            HashKey varbinary(30) null
        )
        
        create clustered index idx_dimDestination_DestinationSK on [db-au-star].dbo.dimDestination(DestinationSK)
        create nonclustered index idx_dimDestination_DestinationID on [db-au-star].dbo.dimDestination(DestinationID)
        create nonclustered index idx_dimDestination_Destination on [db-au-star].dbo.dimDestination(Destination)
        create nonclustered index idx_dimDestination_ISO2Code on [db-au-star].dbo.dimDestination(ISO2Code)
        create nonclustered index idx_dimDestination_Continent on [db-au-star].dbo.dimDestination(Continent)
        create nonclustered index idx_dimDestination_HashKey on [db-au-star].dbo.dimDestination(HashKey)

        set identity_insert [db-au-star].dbo.dimDestination on

        --populate dimension with default unknown values
        insert [db-au-star].dbo.dimDestination
        (
            DestinationSK,
            DestinationID,
            Destination,
            ISO3Code,
            ISO2Code,
            Continent,
            SubContinent,
            ABSCountry,
            ABSArea,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            -1,
            0,
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            getdate(),
            null,
            @batchid,
            null,
            binary_checksum(0, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN','UNKNOWN','UNKNOWN')
        )

        set identity_insert [db-au-star].dbo.dimDestination off
        
    end


-------------------------------------------------------



    if object_id('[db-au-stage].dbo.etl_dimDestination') is not null 
        drop table [db-au-stage].dbo.etl_dimDestination


	select
	bb.*
	into [db-au-stage].dbo.etl_dimDestination
	from 
		(--bb
		select
			aa.*,
			ROW_NUMBER() over(partition by aa.DestinationID, aa.Destination Order by aa.Continent) as [X]
		from
			(--aa
			select
				isnull(convert(nvarchar,d.CountryID),Country) as DestinationID,
				isnull(d.CountryName, c.Country) as Destination,
				case 
					when d.CountryName = 'British Indian Ocean' then 'IOT'
					else isnull(d.ISO3Code,'')
				end as ISO3Code,
				case 
					when d.CountryName = 'British Indian Ocean' then 'IO'
					else isnull(d.ISO2Code, isnull(c.ISO2Code,''))
				end as ISO2Code,
				isnull(
					case 
						when d.CountryName = 'British Indian Ocean' then 'North America'
						else c.Continent
					end,
					'ZZZZ_UNKNOWN'
				) as Continent,
				isnull(
					case 
						when d.CountryName = 'British Indian Ocean' then 'Caribbean'
						else c.SubContinent
					end,
					'UNKNOWN'
				) as SubContinent,
				isnull(c.ABSCountry,'UNKNOWN') as ABSCountry,
				isnull(c.ABSArea,'UNKNOWN') as ABSArea,
				convert(datetime,null) as LoadDate,
				convert(datetime,null) as updateDate,
				convert(int,null) as LoadID,
				convert(int,null) as updateID,
				convert(varbinary,null) as HashKey
			--into [db-au-stage].dbo.etl_dimDestination
			from
				[db-au-cba].dbo.penCountry d
				full outer join [db-au-stage].dbo.etl_excel_country c on
					c.ISO2Code =
						case 
							when d.CountryName = 'British Indian Ocean' then 'IO' 
							else isnull(d.ISO2Code,'') 
						end and
					d.CountryName = c.Country
			)as aa
		)as bb
	where
		bb.[x] = 1

----------------------------------------


    --Update HashKey value
    update [db-au-stage].dbo.etl_dimDestination
    set 
		Continent = replace(Continent,'ZZZZ_',''),
        HashKey = binary_checksum(DestinationID, Destination, ISO3Code, ISO2Code, Continent, SubContinent, ABSCountry, ABSArea)

    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_dimDestination

    begin transaction
    begin try

        -- Merge statement
        merge into [db-au-star].dbo.dimDestination as DST
        using [db-au-stage].dbo.etl_dimDestination as SRC
        on (src.DestinationID = DST.DestinationID and
			src.Destination = DST.Destination)

        -- inserting new records
        when not matched by target then
        insert
        (
            DestinationID,
            Destination,
            ISO3Code,
            ISO2Code,
            Continent,
            SubContinent,
            ABSCountry,
            ABSArea,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            SRC.DestinationID,
            SRC.Destination,
            SRC.ISO3Code,
            SRC.ISO2Code,
            SRC.Continent,
            SRC.SubContinent,
            SRC.ABSCountry,
            SRC.ABSArea,
            getdate(),
            null,
            @batchid,
            null,
            SRC.HashKey
        )
        -- update existing records where data has changed via HashKey
        when matched and DST.HashKey <> SRC.HashKey then
        update
        set DST.Destination = SRC.Destination,
            DST.ISO3Code = SRC.ISO3Code,
            DST.ISO2Code = SRC.ISO2Code,
            DST.Continent = SRC.Continent,
            DST.SubContinent = SRC.SubContinent,
            DST.ABSCountry = SRC.ABSCountry,
            DST.ABSArea = SRC.ABSArea,
            DST.UpdateDate = getdate(),
            DST.UpdateID = @batchid,
            DST.HashKey = SRC.HashKey
            
        output $action into @mergeoutput;

        select
            @insertcount =
                sum(
                    case
                        when MergeAction = 'insert' then 1
                        else 0
                    end
                ),
            @updatecount =
                sum(
                    case
                        when MergeAction = 'update' then 1
                        else 0
                    end
                )
        from
            @mergeoutput

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Finished',
            @LogSourceCount = @sourcecount,
            @LogInsertCount = @insertcount,
            @LogUpdateCount = @updatecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
