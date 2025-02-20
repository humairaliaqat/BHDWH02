USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_extraction]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_extraction]    
    @RunMode varchar(10) = 'AUTO',      --values: AUTO or MANUAL
    @ExtractionType varchar(50),        --values: FileFormat, Export, Import
    @Country varchar(2),                --values: AU, NZ, UK
    @Database varchar(50),              --values: %Trips%, %Corporate%, %Claims%
    @ServerName varchar(100),           --values: valid servername for authentication eg WILLS
    @UserName varchar(100),             --values: valid username to log into database server
    @Password varchar(100) = '',        --values: password to log into database server
    @StartDate varchar(10),             --if RunMode = MANUAL and TableType = F, then format YYYY-MM-DD
    @EndDate varchar(10),               --if RunMode = MANUAL and TableType = F, then format YYYY-MM-DD
    @ServerFilter varchar(100) = '',
    @Debug bit = 0
    
as
begin
/****************************************************************************************************/
--Name:           dbo.etlsp_cmdwh_extraction
--Author:         Linus Tor
--Date Created:   20100913
--Description:    This ETL stored procedure extracts data (as specified by the parameter values)
--                and outputs to a native text file. The native text file format needs to already exists for the extraction
--                to work. Any errors encountered during the extraction will be output to the error file.
--              
--Parameters:     @RunMode:   
--                    AUTO or MANUAL. During normal ETL run, the default value is AUTO and only refers to
--                    factual tables (in this case PPREG).
--                @ExtractionType: 
--                    Specify what extraction type.
--                    FileFormat - create native text file format
--                    CreateTable - create table definitions in [db-au-stage] database (for importing)
--                    Export - export tables to native text output file
--                    Import - import native text data to database server
--                    The sequence of extraction under normal run should be:
--                    1 - FileFormat - create fileformats for export/importing
--                    2 - CreateTable - create target tables for importing data on Target Server
--                    3 - Export - copy data from source to native text file formats
--                    4 - Import - copy data from native text files to database tables
--                @Country: AU, NZ, or UK. Determines the source system country where the table to be extracted
--                @Database: What database source are we extracting? values: %Trips%, %Corporate%, %Claims%
--                @ServerName: Enter the server that will authenticate the login
--                @UserName: valid username to log into database server
--                @Password: valid password to log into database server
--                @StartDate: if RunMode = MANUAL and TableType = F, then format YYYY-MM-DD
--                @EndDate: if RunMode = MANUAL and TableType = F, then format YYYY-MM-DD
--
--Change History:    
--                20100913 - LT - Created
--                20101021 - LT - Amended SP to include database sources
--                20111221 - LT - Amended reporting start and end dates routine to cater for SUN period conversion in the Export Fact table section
--                                Amended @rptEndDate for AUTO for Budget tables which contains budget data for the whole fiscal year
--                20131114 - LS - set end date on AUTO to current date + 30 days
--                                refactoring
--                20150730 - LS - add @ServerFilter, UK Claims
--                20160323 - LT - reduce auto date range to 7 days
--                20170118 - VL - add @ExtractionType = 'SelectInto' check, using BCP_ExportQuery column for storing the 'select into' SQL statement
--                                this is for sources like Penelope which do not use BCP for staging
--                20170607 - LT - Removed dateadd function from SelectInto clause
--                20180608 - LL - modification to SelectInto; optimisation for postgres source.
--                                further optimisation or condition handler may be needed if it's not postgres source.
--                                new mode; SelectIntoID, to check for deleted lines
--                20191123 - RS - Added print statement for debugging purposes.
/****************************************************************************************************/

--uncomment to debug
/*
declare @RunMode varchar(10)
declare @ExtractionType varchar(20)
declare @Country varchar(2)
declare @Database varchar(20)
declare @ServerName varchar(100)
declare @UserName varchar(100)
declare @Password varchar(100)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
declare @ServerFilter varchar(100)
declare @Debug bit
select 
    @RunMode = 'MANUAL', 
    @ExtractionType = 'Export', 
    @Country = 'AU', 
    @Database = '%TRIPS%', 
    @ServerName = 'WILLS', 
    @UserName = '', 
    @Password = '', 
    @StartDate = '2005-01-01', 
    @EndDate = '2005-12-31',
    @Debug = 1
*/

    set nocount on

    --declare variables
    declare @rptStartDate datetime
    declare @rptEndDate datetime
    declare @Sql varchar(8000)
    declare @BCPCommand varchar(max)
    declare @TableType varchar(1)

    if object_id('tempdb..#BCPCommand') is not null 
        drop table #BCPCommand
        
    create table #BCPCommand
    (
        BCPCommand varchar(max) null,
        TableType varchar(255) null
    )

    declare CUR_BCPCommand cursor for 
        select 
            BCPCommand, 
            TableType 
        from 
            #BCPCommand

    --Check run mode and assign reporting start and end dates
    if @RunMode = 'AUTO'
        select 
            @rptStartDate = convert(date, dateadd(d, -3, getdate())),
            @rptEndDate = convert(date, dateadd(d, 3, getdate()))
            
    else
        select
            @rptStartDate = convert(date,@StartDate),
            @rptEndDate = convert(date,@EndDate)

    if @ExtractionType = 'FileFormat'                                --create file formats
    begin
    
        insert #BCPCommand
        select 
            BCP_FFCommand as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            )
            
    end
    else if @ExtractionType = 'Export'                                --insert Export BCP commands into table
    begin
        
        insert #BCPCommand
        select 
            BCP_ExportCommand as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            )
            
    end
    else if @ExtractionType = 'Import'                                --insert Import BCP commands into table
    begin
    
        insert #BCPCommand
        select 
            BCP_ImportCommand as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            )
            
    end
    else if @ExtractionType = 'CreateTable'                            --create table definitions
    begin
    
        insert #BCPCommand
        select 
            SQL_CreateTableDef as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            )
        
    end
    else if @ExtractionType = 'SelectInto'   
    begin

        insert #BCPCommand
        select 
            BCP_ExportQuery as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            )

    end
    else if @ExtractionType = 'SelectIntoID'   
    begin

        insert #BCPCommand
        select 
            BCP_FFCommand as BCPCommand, 
            TableType
        from 
            etl_meta_data
        where 
            Country = @Country and 
            isActive = 1 and 
            SourceDatabaseName like @Database and
            (
                isnull(@ServerFilter, '') = '' or
                SourceServerName = @ServerFilter
            ) and
            isnull(BCP_FFCommand, '') <> ''

    end

    --For each BCP command records, execute BCP until no more records

    open CUR_BCPCommand
    fetch NEXT from CUR_BCPCommand into @BCPCommand, @TableType

    while @@fetch_status = 0
    begin

        set @SQL = @BCPCommand
        
        if @ExtractionType = 'CreateTable'
        begin
        
            if @Debug = 0
                execute(@SQL)
                
            else
                print @SQL
            
        end
        
        else
        begin
        
            if @ExtractionType = 'Import'                            --uses trusted connections to log into target server
            begin
            
                set @SQL = replace(@SQL,'-U @UserName','-T')
                set @SQL = replace(@SQL,'-P @Password','')
                set @SQL = replace(@SQL,'-S @ServerName','-S localhost')
            
            end
            else
            begin                                                    --set username and passwords to log into source servers

                --20180918, LL, cba devsql25 issue            
                if @UserName <> '' and @Password <> '' 
                    set @SQL = replace(@SQL, '-T -S', '-U @UserName -P @Password -S')

                set @SQL = replace(@SQL,'@UserName',@UserName)
                set @SQL = replace(@SQL,'@Password',@Password)
                set @SQL = replace(@SQL,'@ServerName',@ServerName)
            
                
            end
            
            if @TableType = 'F'                                        --update sql statements for FACT tables
            --20111221 - LT - amended to cater for SUN fiscal period conversion
            begin
                if @ExtractionType = 'SelectInto'
                    begin 
                        set @SQL = replace(@SQL,'@rptStartDate',convert(varchar(10),@rptStartDate,120))
                        set @SQL = replace(@SQL,'@rptEndDate',convert(varchar(10),@rptEndDate,120))
                    end
                else 
                    begin
                        set @SQL = replace(@SQL,'@rptStartDate','''' + convert(varchar(10),@rptStartDate,120) + '''')
                        set @SQL = replace(@SQL,'@rptEndDate','''' + convert(varchar(10),@rptEndDate,120) + '''')        
                    end    
            end
            
            --print 'execute (''' + replace(@SQL, '''', '''''') + ''')'

            if @Debug = 0 
            begin
                if @ExtractionType in ('SelectInto', 'SelectIntoID')
                    exec (@SQL)
                else
				    --begin try
					print 'execute master.dbo.xp_cmdshell ''' + replace(@SQL, '''', '''''') + ''''--added by Ratnesh on 20191123 for ease of debugging/suppporting
                    execute master.dbo.xp_cmdshell @SQL
					--end try
					--begin catch
					--print('Error Occurred while executing'+@SQL)--added by Ratnesh on 20191123 for ease of debugging/suppporting
					--end catch
            end
            else
            begin 
                if @ExtractionType in ('SelectInto', 'SelectIntoID')
                    print 'execute (''' + replace(@SQL, '''', '''''') + ''')'

                else
                    print 'execute master.dbo.xp_cmdshell ''' + replace(@SQL, '''', '''''') + ''''
            end
            
        end
        
        fetch NEXT from CUR_BCPCommand into @BCPCommand, @TableType
        
    end

    close CUR_BCPCommand
    deallocate CUR_BCPCommand

    drop table #BCPCommand

end



GO
