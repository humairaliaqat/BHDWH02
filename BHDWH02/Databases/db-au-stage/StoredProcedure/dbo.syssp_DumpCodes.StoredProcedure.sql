USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_DumpCodes]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[syssp_DumpCodes]
    @DatabaseName varchar(64),
    @Debug bit = 0

as
begin

/*****************************************************************************************************************
Name:           dbo.syssp_DumpCodes
Author:         Leonardus Setyabudi
Date Created:   20120720
Description:    This stored procedure dump all stored procedures & functions script for given database
Parameters:     @DatabaseName: database name without the square bracket
                
Backup usage:
sqlcmd -S server_name -E -Q "exec [db-au-stage].dbo.syssp_DumpCodes 'db_name'" -o output_file_name -W

Change History: 
                20120720 - LS - Created
                20120723 - LS - bug fix, remove XML artifact
                                bug fix, wrong order on concatenation
                20120905 - LS - add view creation
                                bug fix, proper function drop
                20120906 - LS - add index creation
                                add table creation
                20121102 - LS - bug fix, syscomments.number might have the same values leading to sp sort issue
                                add syscomments.colid
                20121105 - LS - bug fix, distinct on index column name caused wrong sort order
                20121207 - LS - add clr scalar function definition
                20140616 - LS - invalid datatype handling
                                bug fix, missing closing parentheses on index creation
                                bug fix, double byte for nvarchar & nchar
                20140714 - LS - add identity, this is still assuming 1 seeded and 1 increment
                                bug fix, out of order code dump
                                bug fix, remove width for data type text
                20140812 - LS - bug fix, remove width for data type float
                                bug fix, out of order data dump
                20170116 - LL - handle unique index
                                handle index on views
                20171024 - LL - handle additional data types and object names (DTC)
                20180613 - LL - bug fix on table creation script

*****************************************************************************************************************/
--uncomment to debug
/*
    declare @DatabaseName varchar(64)
    declare @Debug bit

    select
        @DatabaseName = 'db-au-stage',
        @Debug = 1
*/

    set nocount on

    declare @dump table
    (
        id bigint identity(1,1) not null,
        name varchar(max),
        lines varchar(max)
    )
    declare @concat table
    (
        id bigint identity(1,1) not null,
        name varchar(max),
        lines varchar(max)
    )

    if exists (select null from sys.databases where name = @DatabaseName)
    begin

        /* use database statement */
        insert into @dump (name, lines)
        values(' ', 'use [' + @DatabaseName + ']' + char(10) + 'go' + char(10))

        /* drop stored procedures */
        insert into @dump (name, lines)
        exec (
            '
            select
                o.name,
                ''if object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''P'''') is not null'' + char(10) +
                ''    drop procedure ['' + s.name + ''].['' + o.name + '']'' + char(10) +
                ''go'' + char(10) lines
            from
                [' + @DatabaseName + '].sys.objects o
                inner join [' + @DatabaseName + '].sys.schemas s on
                    s.schema_id = o.schema_id
            where
                type in
                    (
                        ''P''    /* stored proc */
                    )
            order by o.name
            '
        )

        /* drop functions */
        insert into @dump (name, lines)
        exec
        (
            '
            select
                o.name,
                ''if '' + char(10) +
                ''    object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''FS'''') is not null or'' + char(10) +
                ''    object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''FN'''') is not null or'' + char(10) +
                ''    object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''IF'''') is not null or'' + char(10) +
                ''    object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''TF'''') is not null'' + char(10) +
                ''    drop function ['' + s.name + ''].['' + o.name + '']'' + char(10) +
                ''go'' + char(10) lines
            from
                [' + @DatabaseName + '].sys.objects o
                inner join [' + @DatabaseName + '].sys.schemas s on
                    s.schema_id = o.schema_id
            where
                type in
                    (
                        ''FS'',   /* clr scalar function */
                        ''FN'',   /* scalar function */
                        ''IF'',   /* inline table valued */
                        ''TF''    /* table valued */
                    )
            order by o.name
            '
        )

        /* drop views */
        insert into @dump (name, lines)
        exec
        (
            '
            select
                o.name,
                ''if object_id(''''['' + s.name + ''].['' + o.name + '']'''', ''''V'''') is not null'' + char(10) +
                ''    drop view ['' + s.name + ''].['' + o.name + '']'' + char(10) +
                ''go'' + char(10) lines
            from
                [' + @DatabaseName + '].sys.objects o
                inner join [' + @DatabaseName + '].sys.schemas s on
                    s.schema_id = o.schema_id
            where
                type in
                (
                    ''V''
                )
            order by o.name
            '
        )

        /* creation script */
        insert into @dump (name, lines)
        exec
        (
            '
            select
                o.name,
                replace(c.text, ''create '', ''create '') + char(10) +
                ''go'' + char(10)
            from
                [' + @DatabaseName + '].sys.objects o
                inner join [' + @DatabaseName + '].sys.syscomments c on
                    c.id = o.object_id
            where
                type in
                    (
                        ''V'',    /* view */
                        ''P'',    /* stored proc */
                        ''FS'',   /* clr scalar function */
                        ''FN'',   /* scalar function */
                        ''IF'',   /* inline table valued */
                        ''TF''    /* table valued */
                    )
            order by
                o.name,
                c.number,
                c.colid
            '
        )

    end

    /* concatenate scripts */
    ;with
    cte_names as
    (
        select name
        from @dump
        group by name
    )
    insert into @concat (name, lines)
    select
        n.name,
        (
            select lines + ''
            from @dump d
            where d.name = n.name
            order by d.id
            for xml path(''), root('lines'), type
        ).value('lines[1]', 'varchar(max)') lines
    from cte_names n

    delete from @dump

    /* table */
    insert into @dump (name, lines)
    exec
    (
        '
        with cte_table as
        (
            select
                t.name,
                ''if not exists (select null from sys.tables where name = '''''' + t.name + '''''') ''+ char(10) +
                ''    create table ['' + s.name + ''].['' + t.name + ''] '' + char(10) +
                ''    ('' + char(10) +
                (
                    select
                        ''        '' +
                        ''['' + c.name + '']'' +
                        '' '' +
                        ct.name +
                        case
                            when ct.name = ''xml'' then ''''
                            when ct.name = ''uniqueidentifier'' then ''''
                            when ct.name = ''text'' then ''''
                            when ct.name = ''ntext'' then ''''
                            when ct.name = ''time'' then ''''
                            when ct.name = ''timestamp'' then ''''
                            when ct.name = ''image'' then ''''
                            when ct.name = ''sysname'' then ''''
                            when c.max_length = -1 then ''(max)''
                            when ct.name in (''nvarchar'', ''nchar'') then ''('' + convert(varchar, c.max_length / 2) + '')''
                            when c.precision = 0 and c.scale = 0 then ''('' + convert(varchar, c.max_length) + '')''
                            when
                                c.precision > 0 and
                                ct.name not like ''float'' and
                                ct.name not like ''text'' and
                                ct.name not like ''money'' and
                                ct.name not like ''%int'' and
                                ct.name not like ''bit'' and
                                ct.name not like ''%date%''
                            then ''('' + convert(varchar, c.precision) + '','' + convert(varchar, c.scale) + '')''
                            else ''''
                        end +
                        case
                            when c.is_nullable = 1 then '' null''
                            else '' not null'' + isnull('' default '' + d.definition, '''')
                        end +
                        case
                            when c.is_identity = 1 then '' identity(1,1)''
                            else ''''
                        end +
                        case
                            when c.column_id <> max(c.column_id) over (partition by t.name) then '',''
                            else ''''
                        end +
                        char(10)
                    from
                        [' + @DatabaseName + '].sys.columns c
                        inner join [' + @DatabaseName + '].sys.types ct on
                            ct.user_type_id = c.user_type_id
                        left join [' + @DatabaseName + '].sys.default_constraints d on
                            d.parent_column_id = c.column_id and
                            d.parent_object_id = c.object_id
                    where
                        c.object_id = t.object_id
                    order by
                        column_id
                    for xml path(''''), root(''columns''), type
                ).value(''columns[1]'', ''varchar(max)'') +
                ''    )'' + char(10) +
                ''    go'' + char(10) + char(10) lines

            from
                [' + @DatabaseName + '].sys.tables t
                inner join [' + @DatabaseName + '].sys.schemas s on
                    s.schema_id = t.schema_id
            where
                t.type = ''U''
        )
        select
            name,
            lines
        from
            cte_table
        order by
            name
        '
    )

    /* index */
    insert into @dump (name, lines)
    exec
    (
        '
        with
        cte_index as
        (
            select distinct
                i.index_id,
                i.name,
                i.type_desc,
                i.is_unique,
                i.object_id,
                o.name table_name,
                ''['' + s.name + ''].['' + o.name + '']'' schema_table_name
            from
                [' + @DatabaseName + '].sys.indexes i
                inner join [' + @DatabaseName + '].sys.index_columns ic on
                    i.index_id = ic.index_id and
                    i.object_id = ic.object_id
                inner join [' + @DatabaseName + '].sys.objects o on
                    o.object_id = i.object_id
                inner join [' + @DatabaseName + '].sys.schemas s on
                    s.schema_id = o.schema_id
        ),
        cte_indexcolumns as
        (
            select
                idx.name index_name,
                idx.table_name,
                idx.schema_table_name,
                case
                    when is_unique = 1 then ''unique ''
                    else ''''
                end +
                lower(type_desc) collate database_default indextype,
                (
                    select
                        c.name + '',''
                    from
                        [' + @DatabaseName + '].sys.columns c
                        inner join [' + @DatabaseName + '].sys.index_columns ic on
                            c.object_id = ic.object_id and
                            ic.column_id = c.column_id and
                            ic.is_included_column = 0
                    where
                        idx.object_id = ic.object_id and
                        idx.index_id = ic.index_id
                    for xml path(''''), root(''idxcolumn''), type
                ).value(''idxcolumn[1]'', ''varchar(max)'') indexcolumns,
                isnull(
                    (
                        select
                            ''['' + c.name + ''],''
                        from
                            [' + @DatabaseName + '].sys.columns c
                            inner join [' + @DatabaseName + '].sys.index_columns ic on
                                c.object_id = ic.object_id and
                                ic.column_id = c.column_id and
                                ic.is_included_column = 1
                        where
                            idx.object_id = ic.object_id and
                            idx.index_id = ic.index_id
                        for xml path(''''), root(''inccolumn''), type
                    ).value(''inccolumn[1]'', ''varchar(max)''),
                    ''''
                ) includecolumns
            from
                cte_index idx
        )
        select
            /*t.name table_name,*/
            index_name,
            ''if not exists (select null from [' + @DatabaseName + '].sys.indexes where name = '''''' + index_name + '''''')'' +
            char(10) +
            ''    create '' + indextype + '' index ['' + index_name + ''] on [' + @DatabaseName + '].'' + schema_table_name +  ''('' + substring(indexcolumns, 1, len(indexcolumns) - 1) +
            case len(includecolumns)
                when 0 then '')''
                else '') include ('' + substring(includecolumns, 1, len(includecolumns) - 1) + '')''
            end +
            char(10) +
            ''go'' +
            char(10) script
        from
            (
                select
                    name
                from
                    [' + @DatabaseName + '].sys.tables
                where
                    type = ''U''

                union all

                select
                    name
                from
                    [' + @DatabaseName + '].sys.views
                where
                    type = ''V''
            ) t
            inner join cte_indexcolumns i on
                i.table_name = t.name
        where
            index_name is not null
        order by
            t.name,
            case
                when indextype like ''% clustered%'' then 0
                when indextype like ''clustered%'' then 0
                else 1
            end,
            index_name
        '
    )

    /* output */
    if object_id('tempdb..#codeout') is not null
        drop table #codeout
        
    create table #codeout 
        (
            id bigint not null identity(1,1),
            name nvarchar(max),
            lines nvarchar(max)
        )

    insert into #codeout (name, lines)
    select
        name,
        rtrim(
            replace(
                replace(
                    item,
                    char(13),
                    ''
                ),
                char(9),
                '    '
            )
        ) lines
    from
        @concat d
        cross apply dbo.fn_DelimitedSplit1M(d.lines, char(10)) l
    order by name, l.ItemNumber

    insert into #codeout (name, lines)
    select
        name,
        lines
    from
        @dump
    order by
        id

    if @Debug = 1
        select *
        from
            #codeout
        order by
            id

    else
        select lines
        from
            #codeout
        order by
            id

end




GO
