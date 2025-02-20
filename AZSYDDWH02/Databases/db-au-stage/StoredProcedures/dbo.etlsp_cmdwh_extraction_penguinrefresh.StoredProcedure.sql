USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_extraction_penguinrefresh]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_extraction_penguinrefresh]
    @TimeRange int,                     --values: time range in hours
    @TimeStart datetime = null,
    @TimeEnd datetime = null,
    @ExtractionType varchar(20),        --values: FileFormat, Export, Import
    @Country varchar(2),                --values: AU, NZ, UK
    @Database varchar(20),              --values: %Trips%, %Corporate%, %Claims%
    @ServerName varchar(100) = '',      --values: Required. source server name.
    @UserName varchar(100) = '',        --values: valid username to log into database server
    @Password varchar(100) = '',        --values: password to log into database server
    @Debug bit = 0

--with execute as 'COVERMORE\AppBOBJ'
as
begin


/****************************************************************************************************/
--  Name:           dbo.etlsp_cmdwh_extraction_penguinrefresh
--  Author:         Leonardus Setyabudi
--  Date Created:   20120330
--  Description:    Based on dbo.etlsp_cmdwh_extraction_refresh
--                  This ETL stored procedure extracts data (as specified by the parameter values)
--                  and outputs to a native text file. The native text file format needs to already exists for the extraction
--                  to work. Any errors encountered during the extraction will be output to the error file.
--
--  Parameters:     @TimeRange: Time span from current time for the data to be rolled up
--                  @ExtractionType: Specify what extraction type.
--                    FileFormat - create native text file format
--                    CreateTable - create table definitions in [db-au-stage] database (for importing)
--                    Export - export tables to native text output file
--                    Import - import native text data to database server
--                    The sequence of extraction under normal run should be:
--                    1 - FileFormat - create fileformats for export/importing
--                    2 - CreateTable - create target tables for importing data on Target Server
--                    3 - Export - copy data from source to native text file formats
--                    4 - Import - copy data from native text files to database tables
--                  @Country:  AU, NZ, or UK. Determines the source system country where the table to be extracted
--                  @Database: What database source are we extracting? values: %Trips%, %Corporate%, %Claims%
--                  @ServerName: filter only
--                  @UserName: valid username to log into database server
--                  @Password: valid password to log into database server
--
--  Change History: 20120330 - LS - Created
--                  20121218 - LS - Refactoring
--                                  Consider UTC time
--                  20131114 - LS - set @TimeEnd to 48 hours in the future (CDG UTC bug)
--                                20140719 - LS - F 21328, don't get transaction in the future
--                                                            this causes partial data to be brought in the refresh
--                                                            now even reduce the end time to 5 minutes before etl started
--                                20151208 - LT - Penguin 16.5, ETL meta data has changed to include square brackets. The reason for this is to
--                                                            ensure the 1 meta data can be used in dev, test and prod environments.
--                                                            replace @ServerName text with parameter @ServerName (BCP cannot log in with servername enclosed in square brackets
--                  20151209 - LS - replacing @ServerName breaks current refresh ETL as @ServerName was optional and meant to be red from ETL metadata
--                                  check if @ServerName is blank, if it is use SourceServerName
--                                20170707 - VL - add condition 'TruncateTable' for @ExtractionType to avoid hitting the log shipping restore
--
--					20181001 - LT - Customised for CBA
--                  20191123 - RS - Added print statement for debugging purposes.
/****************************************************************************************************/

--uncomment to debug
/*
declare
    @TimeRange int,
    @TimeStart datetime,
    @TimeEnd datetime,
    @ExtractionType varchar(20),
    @Country varchar(2),
    @Database varchar(20),
    @ServerName varchar(100),
    @UserName varchar(100),
    @Password varchar(100),
    @Debug bit

select
    @TimeRange = 8,
    @ExtractionType = 'Import',
    @Country = 'AU',
    @Database = '%',
    @ServerName = 'bhdwh02',
    @UserName = '',
    @Password = '',
    @Debug = 1
*/

    set nocount on

    declare @BCPCommands table (BCPCommand varchar(4096) null, SourceServerName varchar(4096) null)
    declare @BCPCommand varchar(4096)
    declare @SourceServer varchar(4096)
    declare cBCPCommand cursor local for
        select
            BCPCommand,
            SourceServerName
        from
            @BCPCommands
    declare @TZ varchar(100)

    /* define time range */
    select top 1
        @TZ = TimeZoneCode
    from
        [db-au-cba].dbo.penDomain
    where
        CountryKey = @Country

    if @TimeRange <> 0 or @TimeStart is null or @TimeEnd is null
        select
            @TimeStart = dateadd(hour, -@TimeRange, getdate()),
            @TimeEnd = dateadd(minute, -5, getdate())

    select
        @TimeStart = dbo.xfn_ConvertLocaltoUTC(@TimeStart, @TZ),
        @TimeEnd = dbo.xfn_ConvertLocaltoUTC(@TimeEnd, @TZ)

    if @ExtractionType = 'FileFormat'                --create file formats
    begin

        insert into @BCPCommands
        select
            BCP_FFCommand,
            replace(replace(SourceServerName,'[',''),']','') SourceServerName
        from
            etl_meta_data_penguinrefresh
        where
            Country = @Country and
            isActive = 1 and
            SourceDatabaseName like @Database and
            (
                @ServerName = '' or
                replace(replace(SourceServerName,'[',''),']','') = @ServerName
            )

    end
    else if @ExtractionType = 'Export'                --insert Export BCP commands into table
    begin

        insert into @BCPCommands
        select
            BCP_ExportCommand,
            replace(replace(SourceServerName,'[',''),']','') SourceServerName
        from
            etl_meta_data_penguinrefresh
        where
            Country = @Country and
            isActive = 1 and
            SourceDatabaseName like @Database and
            (
                @ServerName = '' or
                replace(replace(SourceServerName,'[',''),']','') = @ServerName
            )

    end
    else if @ExtractionType = 'Import'                --insert Import BCP commands into table
    begin

        insert into @BCPCommands
        select
            BCP_ImportCommand,
            replace(replace(TargetServerName,'[',''),']','') SourceServerName
        from
            etl_meta_data_penguinrefresh
        where
            Country = @Country and
            isActive = 1 and
            SourceDatabaseName like @Database 
                     --and
            --(
                --@ServerName = '' or
                --replace(replace(SourceServerName,'[',''),']','') = @ServerName
            --)

    end
    else if @ExtractionType = 'CreateTable'              --create table definitions
    begin

        insert into @BCPCommands
        select
            SQL_CreateTableDef,
            replace(replace(SourceServerName,'[',''),']','') SourceServerName
        from
            etl_meta_data_penguinrefresh
        where
            Country = @Country and
            isActive = 1 and
            SourceDatabaseName like @Database and
            (
                @ServerName = '' or
                replace(replace(SourceServerName,'[',''),']','') = @ServerName
            )

    end
    -- 20170707 - VL - add condition 'TruncateTable' for @ExtractionType to avoid hitting the log shipping restore
	if @ExtractionType = 'TruncateTable'
    begin
        insert into @BCPCommands
		select
            ('truncate table ' + TargetDatabaseName + '..' + TargetTableName),
            null
        from
            etl_meta_data_penguinrefresh
        where
            Country = @Country and
			isActive = 1 and
			SourceDatabaseName like @Database and
			(
				@ServerName = '' or
				replace(replace(SourceServerName,'[',''),']','') = @ServerName
			)        
    end

    --For each BCP command records, execute BCP until no more records

    open cBCPCommand
    fetch next from cBCPCommand into @BCPCommand, @SourceServer

    while @@fetch_status = 0
    begin
		
        set @BCPCommand = replace(@BCPCommand, '@TimeStart', '''' + convert(varchar, @TimeStart, 120) + '''')
        set @BCPCommand = replace(@BCPCommand, '@TimeEnd', '''' + convert(varchar, @TimeEnd, 120) + '''')
        set @BCPCommand = replace(@BCPCommand, '@UserName', @UserName)
        set @BCPCommand = replace(@BCPCommand, '@Password', @Password)
		
        if isnull(@ServerName, '') = '' and @ExtractionType <> 'TruncateTable'
                  set @BCPCommand = replace(@BCPCommand, '@ServerName', @SourceServer)
        else if @ExtractionType <> 'TruncateTable'
                  set @BCPCommand = replace(@BCPCommand, '@ServerName', @ServerName)

        if @Debug = 1
            print @BCPCommand

        else
        begin
                     
            if @ExtractionType in ('CreateTable', 'TruncateTable') -- 20170707 - VL - add condition 'TruncateTable' for @ExtractionType
                exec (@BCPCommand)
            else
			    print(@BCPCommand)--added by Ratnesh on 20191123 for ease of debugging/suppporting
                exec master.dbo.xp_cmdshell @BCPCommand

        end

        fetch next from cBCPCommand into @BCPCommand, @SourceServer

    end

    close cBCPCommand
    deallocate cBCPCommand

end


GO
