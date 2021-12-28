SET LINESIZE 150;
SET SERVEROUTPUT on SIZE 1000000 FORMAT TRUNCATED;
--
--
set echo on;
--
create or replace package unloader
as
    function run( p_query      in varchar2 default NULL,
                  p_cols       in varchar2 default '*',
                  p_town       in varchar2 default USER,
                  p_tname      in varchar2,
                  p_mode       in varchar2 default 'REPLACE',
                  p_dir        in varchar2,
                  p_filename   in varchar2,
                  p_separator  in varchar2 default ',',
                  p_enclosure  in varchar2 default '"',
                  p_terminator in varchar2 default '|',
                  p_ctl        in varchar2 default 'YES',
                  p_header     in varchar2 default 'NO' )
    return number;
    --
    function run( p_query      in varchar2 default NULL,
                  p_cols       in varchar2 default '*',
                  p_town       in varchar2 default USER,
                  p_tname      in varchar2,
                  p_mode       in varchar2 default 'REPLACE',
                  p_dbdir      in varchar2,
                  p_filename   in varchar2,
                  p_separator  in varchar2 default ',',
                  p_enclosure  in varchar2 default '"',
                  p_terminator in varchar2 default '|',
                  p_ctl        in varchar2 default 'YES',
                  p_header     in varchar2 default 'NO' )
    return number;
    --
    function remove( p_dbdir      in varchar2,
                     p_filename   in varchar2)
    return number;
    --
    PROCEDURE version;
    --
    PROCEDURE help;
end;
/
--
SET ARRAYSIZE 1;
SHOW ERRORS;
--
--
create or replace package body unloader
as
  --
  g_theCursor     integer default dbms_sql.open_cursor;
  g_descTbl       dbms_sql.desc_tab;
  g_nl            varchar2(2) default chr(10);
  --
  g_version_txt   VARCHAR2(60)
        := 'unloader - Version 1.5, June 14, 2006';
  --
  --
  function to_hex( p_str in varchar2 ) return varchar2
  is
    begin
      return to_char( ascii(p_str), 'fm0x' );
    end;
  --
  --
  -- dump_ctl using UTL_FILE_DIR
  --
  procedure  dump_ctl( p_dir        in varchar2, 
                       p_filename   in varchar2, 
                       p_tname      in varchar2, 
                       p_mode       in varchar2, 
                       p_separator  in varchar2, 
                       p_enclosure  in varchar2,
                       p_terminator in varchar2 )
  is
    l_output        utl_file.file_type;
    l_sep           varchar2(5);
    l_str           varchar2(5);
    l_path          varchar2(5);
  begin
    --
    -- Set file directory separator
    --
    if ( p_dir like '%\%' ) 
    then
      -- Windows platforms --
      l_str := chr(13) || chr(10);
      if ( p_dir not like '%\' AND p_filename not like '\%' )
      then
        l_path := '\';
      end if;
    else
      l_str := chr(10);
      if ( p_dir not like '%/' AND p_filename not like '/%' )
      then
        l_path := '/';
      end if;
    end if;
    --
    -- Open output file for control file
    --
    l_output := utl_file.fopen( p_dir, p_filename || '.ctl', 'w' );
    --
    -- Output control file DDL lines
    --
    utl_file.put_line( l_output, 'load data' );
    utl_file.put_line( l_output, 'infile ''' || p_dir || l_path || 
				  p_filename || '.dat'' "str x''' || 
                                  utl_raw.cast_to_raw( p_terminator ||
				  l_str ) || '''"' );
    utl_file.put_line( l_output, 'badfile ''' || p_dir || l_path || 
                                  p_filename || '.bad'' ' );
    utl_file.put_line( l_output, 'into table ' || p_tname );
    utl_file.put_line( l_output, p_mode );
    utl_file.put_line( l_output, 'fields terminated by X''' || 
                                  to_hex(p_separator) || 
                                 ''' enclosed by X''' || 
                                  to_hex(p_enclosure) || ''' ' );
    utl_file.put_line( l_output, '(' );
    --
    -- Output column specifications
    --
    for i in 1 .. g_descTbl.count
    loop
      if ( g_descTbl(i).col_type = 12 )
      then
        utl_file.put( l_output, l_sep || g_descTbl(i).col_name || 
                      ' date ''ddmmyyyyhh24miss'' '); 
      else
        utl_file.put( l_output, l_sep || g_descTbl(i).col_name || 
                      ' char(' || 
                      to_char(g_descTbl(i).col_max_len*2) ||' )' );
      end if;
      l_sep := ','||g_nl ;
    end loop;
    utl_file.put_line( l_output, g_nl || ')' );
    utl_file.fclose( l_output );
  --
  -- Exception handler
  --
  exception
    when utl_file.invalid_path then
      dbms_output.put_line('Invalid path name specified for ctl file');
    when others then
      dbms_output.put_line('Error creating ctl file');
      RAISE;
  end;
  --
  -- dump_ctl using database directory
  --
  procedure  dump_ctl( p_dbdir      in varchar2, 
                       p_filename   in varchar2,
                       p_tname      in varchar2, 
                       p_mode       in varchar2, 
                       p_separator  in varchar2, 
                       p_enclosure  in varchar2,
                       p_terminator in varchar2 )
  is
    l_output        utl_file.file_type;
    l_sep           varchar2(5);
    l_str           varchar2(5);
    l_path          varchar2(5);
    l_dir           varchar2(100);
  begin
    --
    -- Set file directory from db directory
    --
    select directory_path
      into l_dir
      from all_directories
    where directory_name = p_dbdir
      and owner = 'SYS';
    --
    -- Set file directory separator
    --
    if ( l_dir like '%\%' ) 
    then
      -- Windows platforms --
      l_str := chr(13) || chr(10);
      if ( l_dir not like '%\' AND p_filename not like '\%' )
      then
        l_path := '\';
      end if;
    else
      l_str := chr(10);
      if ( l_dir not like '%/' AND p_filename not like '/%' )
      then
        l_path := '/';
      end if;
    end if;
    --
    -- Open output file for control file
    --
    l_output := utl_file.fopen( p_dbdir, p_filename || '.ctl', 'w' );
    --
    -- Output control file DDL lines
    --
    utl_file.put_line( l_output, 'load data' );
    utl_file.put_line( l_output, 'infile ''' || l_dir || l_path || 
                                  p_filename || '.dat'' "str x''' || 
                                  utl_raw.cast_to_raw( p_terminator ||
                                  l_str ) || '''"' );
    utl_file.put_line( l_output, 'badfile ''' || l_dir || l_path || 
                                  p_filename || '.bad'' ' );
    utl_file.put_line( l_output, 'into table ' || p_tname );
    utl_file.put_line( l_output, p_mode );
    utl_file.put_line( l_output, 'fields terminated by X''' || 
                                  to_hex(p_separator) || 
                                 ''' enclosed by X''' || 
                                  to_hex(p_enclosure) || ''' ' );
    utl_file.put_line( l_output, '(' );
    --
    -- Output column specifications
    --
    for i in 1 .. g_descTbl.count
    loop
      if ( g_descTbl(i).col_type = 12 )
      then
        utl_file.put( l_output, l_sep || g_descTbl(i).col_name || 
                      ' date ''ddmmyyyyhh24miss'' '); 
      else
        utl_file.put( l_output, l_sep || g_descTbl(i).col_name || 
                      ' char(' || 
                      to_char(g_descTbl(i).col_max_len*2) ||' )' );
      end if;
      l_sep := ','||g_nl ;
    end loop;
    utl_file.put_line( l_output, g_nl || ')' );
    utl_file.fclose( l_output );
  --
  -- Exception handler
  --
  exception
    when utl_file.invalid_path then
      dbms_output.put_line('Invalid path name specified for ctl file');
    when others then
      dbms_output.put_line('Error creating ctl file');
      RAISE;
  end;
  --
  --
  function quote(p_str in varchar2, p_enclosure in varchar2) 
    return varchar2
  is
  begin
    return p_enclosure || 
           replace( p_str, p_enclosure, p_enclosure||p_enclosure ) || 
           p_enclosure;
  end;
  --
  --
  function getColName(p_col in varchar2, p_own in varchar2, p_tab in varchar2, 
                      debug_opt in varchar2 default 'N') 
    return varchar2
  is
    l_col                 VARCHAR2(4000);
  begin
    DECLARE
      var_ddl_stmt          VARCHAR2(4000);    -- DDL statment holder
      cursor_name           INTEGER;           -- Dynamic SQL cursor holder
      var_ret_cd            INTEGER;           -- Dynamic SQL return code
      v_comment             VARCHAR2(100);
    BEGIN
      var_ddl_stmt := 'SELECT comments FROM all_col_comments WHERE table_name = '''||p_tab||
                      ''' AND owner = '''||p_own||''' AND column_name = '''||p_col||'''';
      IF UPPER(debug_opt) = 'Y' THEN
        dbms_output.put_line(var_ddl_stmt);
      END IF;
      cursor_name := DBMS_SQL.OPEN_CURSOR;
      --DDL statements are executed by the parse call, which
      --performs the implied commit
      DBMS_SQL.PARSE(cursor_name, var_ddl_stmt, DBMS_SQL.NATIVE);
      DBMS_SQL.DEFINE_COLUMN(cursor_name, 1, v_comment, 100);
      var_ret_cd := DBMS_SQL.EXECUTE(cursor_name);
      --
      loop
        exit when ( dbms_sql.fetch_rows(cursor_name) <= 0 );
        DBMS_SQL.COLUMN_VALUE(cursor_name, 1, v_comment );
      end loop;
      --
      IF ( v_comment IS NULL ) THEN
        l_col := p_col;
      ELSE
        l_col := v_comment;
      END IF;
      DBMS_SQL.CLOSE_CURSOR(cursor_name);
      --
    EXCEPTION
      WHEN OTHERS THEN
        IF DBMS_SQL.IS_OPEN(cursor_name) THEN
          DBMS_SQL.CLOSE_CURSOR(cursor_name);
        END IF;
        return p_col;
    END;
    --
    return l_col;
  end;
  --
  -- Uses UTL_FILE_DIR 
  --
  function run( p_query      in varchar2 default NULL,
                p_cols       in varchar2 default '*',
                p_town       in varchar2 default USER,
                p_tname      in varchar2,
                p_mode       in varchar2 default 'REPLACE',
                p_dir        in varchar2,
                p_filename   in varchar2,
                p_separator  in varchar2 default ',',
                p_enclosure  in varchar2 default '"',
                p_terminator in varchar2 default '|',
                p_ctl        in varchar2 default 'YES',
                p_header     in varchar2 default 'NO' ) return number
  is
    l_query         varchar2(4000);
    l_output        utl_file.file_type;
    l_columnValue   varchar2(4000);
    l_colCnt        number default 0;
    l_separator     varchar2(10) default '';
    l_cnt           number default 0;
    l_line          long;
    l_datefmt       varchar2(255);
    l_descTbl       dbms_sql.desc_tab;
  begin
    select value 
      into l_datefmt 
      from nls_session_parameters 
     where parameter = 'NLS_DATE_FORMAT';
     --
     -- Set the date format to a big numeric string. Avoids
     -- all NLS issues and saves both the time and date.
     --
    execute immediate 
      'alter session set nls_date_format=''ddmmyyyyhh24miss'' ';
    --
    -- Set up an exception block so that in the event of any
    -- error, we can at least reset the date format back.
    --
    declare
      invalid_type EXCEPTION;
    begin
      -- 
      -- Parse and describe the query. We reset the 
      -- descTbl to an empty table so .count on it 
      -- will be reliable.
      --
      if p_query is NULL then
        l_query := 'select '||p_cols||' from '||p_town||'.'||p_tname;
      else
        l_query := p_query;
      end if;
      --
      dbms_sql.parse( g_theCursor, l_query, dbms_sql.native );
      g_descTbl := l_descTbl;
      dbms_sql.describe_columns( g_theCursor, l_colCnt, g_descTbl );
      --
      -- Verify that the table contains supported columns - currently
      -- LOBs are not supported.
      --
      for i in 1 .. g_descTbl.count loop
        IF (g_descTbl(i).col_type = 1) OR (g_descTbl(i).col_type = 2)
            OR (g_descTbl(i).col_type = 12) OR (g_descTbl(i).col_type = 96)
            OR (g_descTbl(i).col_type = 8) OR (g_descTbl(i).col_type = 23) THEN
          NULL;
        ELSE
          RAISE invalid_type;
        END IF;
      end loop;
      --
      -- Create a control file to reload this data
      -- into the desired table.
      --
      IF p_ctl = 'YES' THEN
        dump_ctl( p_dir=>p_dir,
                  p_filename=>p_filename,
                  p_tname=>p_tname,
                  p_mode=>p_mode,
                  p_separator=>p_separator, 
                  p_enclosure=>p_enclosure,
                  p_terminator=>p_terminator );
      END IF;
      --
      -- Bind every single column to a varchar2(4000). We don't care 
      -- if we are fetching a number or a date or whatever.
      -- Everything can be a string.
      --
      for i in 1 .. l_colCnt loop
        dbms_sql.define_column( g_theCursor, i, l_columnValue, 4000 );
      end loop;
      --
      -- Run the query - ignore the output of execute. It is only 
      -- valid when the DML is an insert/update or delete. 
      --
      l_cnt := dbms_sql.execute(g_theCursor);
      --
      -- Open the file to write output to and then write the
      -- delimited data to it.  
      --
      l_output := utl_file.fopen( p_dir, p_filename || '.dat', 'w', 32760 );
      --
      -- Output a column header. This version uses table column comments if they
      -- exist, otherwise it defaults to the actual table column name.
      --
      IF p_header = 'YES' THEN
        l_separator := '';
        l_line := '';
        for i in 1 .. g_descTbl.count
        loop
          l_line := l_line || l_separator || 
                    quote( getColName(g_descTbl(i).col_name, p_town, p_tname), p_enclosure );
          l_separator := p_separator;
        end loop;
        utl_file.put_line( l_output, l_line );
      END IF;
      --
      -- Output data
      --
      loop
        exit when ( dbms_sql.fetch_rows(g_theCursor) <= 0 );
        l_separator := '';
        l_line := null;
        for i in 1 .. l_colCnt loop
          dbms_sql.column_value( g_theCursor, i, 
                                 l_columnValue );
          l_line := l_line || l_separator || 
                    quote( l_columnValue, p_enclosure );
          l_separator := p_separator;
        end loop;
        l_line := l_line || p_terminator;
        utl_file.put_line( l_output, l_line );
        l_cnt := l_cnt+1;
      end loop;
      utl_file.fclose( l_output );
      --
      -- Now reset the date format and return the number of rows
      -- written to the output file.
      --
      execute immediate 
        'alter session set nls_date_format=''' || l_datefmt || '''';
      --
      return l_cnt;
    exception
      --
      -- In the event of ANY error, reset the data format and
      -- re-raise the error.
      --
      when invalid_type then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        dbms_output.put_line('Error - Table: '||p_tname||' contains an unsupported column type');
        dbms_output.put_line('Table is being skipped');
        --
        return 0;
      when utl_file.invalid_path then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        dbms_output.put_line('Invalid path name specified for dat file');
        --
        return 0;
      when others then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        RAISE;
        --
        return 0;
    end;
  end run;
  --
  -- Uses database directory
  --
  function run( p_query      in varchar2 default NULL,
                p_cols       in varchar2 default '*',
                p_town       in varchar2 default USER,
                p_tname      in varchar2,
                p_mode       in varchar2 default 'REPLACE',
                p_dbdir      in varchar2,
                p_filename   in varchar2,
                p_separator  in varchar2 default ',',
                p_enclosure  in varchar2 default '"',
                p_terminator in varchar2 default '|',
                p_ctl        in varchar2 default 'YES',
                p_header     in varchar2 default 'NO' ) return number
  is
    l_query         varchar2(4000);
    l_output        utl_file.file_type;
    l_columnValue   varchar2(4000);
    l_colCnt        number default 0;
    l_separator     varchar2(10) default '';
    l_cnt           number default 0;
    l_line          long;
    l_datefmt       varchar2(255);
    l_descTbl       dbms_sql.desc_tab;
  begin
    select value 
      into l_datefmt 
      from nls_session_parameters 
     where parameter = 'NLS_DATE_FORMAT';
     --
     -- Set the date format to a big numeric string. Avoids
     -- all NLS issues and saves both the time and date.
     --
    execute immediate 
      'alter session set nls_date_format=''ddmmyyyyhh24miss'' ';
    --
    -- Set up an exception block so that in the event of any
    -- error, we can at least reset the date format back.
    --
    declare
      invalid_type EXCEPTION;
    begin
      -- 
      -- Parse and describe the query. We reset the 
      -- descTbl to an empty table so .count on it 
      -- will be reliable.
      --
      if p_query is NULL then
        l_query := 'select '||p_cols||' from '||p_town||'.'||p_tname;
      else
        l_query := p_query;
      end if;
      --
      --     
      -- dbms_output.put_line('Query: '||l_query);
      --
      --
      dbms_sql.parse( g_theCursor, l_query, dbms_sql.native );
      g_descTbl := l_descTbl;
      dbms_sql.describe_columns( g_theCursor, l_colCnt, g_descTbl );
      --
      -- Verify that the table contains supported columns - currently
      -- LOBs are not supported.
      --
      for i in 1 .. g_descTbl.count loop
        IF (g_descTbl(i).col_type = 1) OR (g_descTbl(i).col_type = 2)
            OR (g_descTbl(i).col_type = 12) OR (g_descTbl(i).col_type = 96)
            OR (g_descTbl(i).col_type = 8) OR (g_descTbl(i).col_type = 23) THEN
          NULL;
        ELSE
          RAISE invalid_type;
        END IF;
      end loop;
      --
      -- Create a control file to reload this data
      -- into the desired table.
      --
      dbms_output.put_line('Create the control file');
      --
      IF p_ctl = 'YES' THEN
        dump_ctl( p_dbdir=>p_dbdir,
                  p_filename=>p_filename,
                  p_tname=>p_tname,
                  p_mode=>p_mode,
                  p_separator=>p_separator, 
                  p_enclosure=>p_enclosure,
                  p_terminator=>p_terminator );
      END IF;
      --
      -- Bind every single column to a varchar2(4000). We don't care 
      -- if we are fetching a number or a date or whatever.
      -- Everything can be a string.
      --
      for i in 1 .. l_colCnt loop
        dbms_sql.define_column( g_theCursor, i, l_columnValue, 4000 );
      end loop;
      --
      -- Run the query - ignore the output of execute. It is only 
      -- valid when the DML is an insert/update or delete. 
      --
      l_cnt := dbms_sql.execute(g_theCursor);
      --
      -- Open the file to write output to and then write the
      -- delimited data to it.  
      --
      l_output := utl_file.fopen( p_dbdir, p_filename || '.dat', 'w', 32760 );
      --
      -- Output a column header. This version uses table column comments if they
      -- exist, otherwise it defaults to the actual table column name.
      --
      IF p_header = 'YES' THEN
        l_separator := '';
        l_line := '';
        for i in 1 .. g_descTbl.count
        loop
          l_line := l_line || l_separator || 
                    quote( getColName(g_descTbl(i).col_name, p_town, p_tname), p_enclosure );
          l_separator := p_separator;
        end loop;
        utl_file.put_line( l_output, l_line );
      END IF;
      --
      -- Output data
      --
      loop
        exit when ( dbms_sql.fetch_rows(g_theCursor) <= 0 );
        l_separator := '';
        l_line := null;
        for i in 1 .. l_colCnt loop
          dbms_sql.column_value( g_theCursor, i, 
                                 l_columnValue );
          l_line := l_line || l_separator || 
                    quote( l_columnValue, p_enclosure );
          l_separator := p_separator;
        end loop;
        l_line := l_line || p_terminator;
        utl_file.put_line( l_output, l_line );
        l_cnt := l_cnt+1;
      end loop;
      utl_file.fclose( l_output );
      --
      -- Now reset the date format and return the number of rows
      -- written to the output file.
      --
      execute immediate 
        'alter session set nls_date_format=''' || l_datefmt || '''';
      --
      return l_cnt;
    exception
      --
      -- In the event of ANY error, reset the data format and
      -- re-raise the error.
      --
      when invalid_type then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        dbms_output.put_line('Error - Table: '||p_tname||' contains an unsupported column type');
        dbms_output.put_line('Table is being skipped');
        --
        return 0;
      when utl_file.invalid_path then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        dbms_output.put_line('Invalid path name specified for dat file');
        --
        return 0;
      when others then
        execute immediate 
          'alter session set nls_date_format=''' || l_datefmt || '''';
        --
        RAISE;
        --
        return 0;
    end;
  end run;
  --
  --
  function remove( p_dbdir      in varchar2,
                   p_filename   in varchar2) return number
  is
  begin
    begin
      utl_file.fremove( p_dbdir, p_filename );
      return 0;
    exception
      when utl_file.invalid_path then
        dbms_output.put_line('Invalid path name specified for file '||p_filename);
        return 1;
      when utl_file.delete_failed then
        dbms_output.put_line('Delete failed for file: '||p_filename);
        return 1;
      when others then
        dbms_output.put_line('Error during remove of file: '||p_filename);
        return 1;
    end;
  end remove;
  --
  --
  PROCEDURE version
  IS
  -- 
  BEGIN
    IF LENGTH(g_version_txt) > 0 THEN
      dbms_output.put_line(' ');
      dbms_output.put_line(g_version_txt);
    END IF;
  -- 
  END version;
  --
  --
  PROCEDURE help 
  IS
  -- 
  -- Lists help menu
  --
  BEGIN
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE(g_version_txt);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Function run - Unloads data from any query into a file, and creates a');
    DBMS_OUTPUT.PUT_LINE('               control file to reload this data into another table.');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('p_query      = SQL query to ''unload''. May be virtually any query.');
    DBMS_OUTPUT.PUT_LINE(' OR');
    DBMS_OUTPUT.PUT_LINE('p_cols       = Columns to ''unload''. Defaults to ''*'' for all columns.');
    DBMS_OUTPUT.PUT_LINE('p_town       = Owner of table to unload.');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('p_tname      = Table to unload. Will also be put into the control file for load
ing.');
    DBMS_OUTPUT.PUT_LINE('p_mode       = REPLACE|APPEND|TRUNCATE - how to reload the data.');
    DBMS_OUTPUT.PUT_LINE('p_dir        = Directory we will write the .ctl and .dat file to.');
    DBMS_OUTPUT.PUT_LINE(' OR');
    DBMS_OUTPUT.PUT_LINE('p_dbdir      = Database directory name we will write the .ctl and .dat file to.
');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('p_filename   = Name of file to write to. I will add .ctl and .dat to this name.
');
    DBMS_OUTPUT.PUT_LINE('p_separator  = Field delimiter. I default this to a comma.');
    DBMS_OUTPUT.PUT_LINE('p_enclosure  = What each field will be wrapped in.');
    DBMS_OUTPUT.PUT_LINE('p_terminator = End of line character. We use this so we can unload and');
    DBMS_OUTPUT.PUT_LINE('               reload data with newlines in it. I default to ''|\n'' (a');
    DBMS_OUTPUT.PUT_LINE('               pipe and a newline together), ''|\r\n'' on NT. You need');
    DBMS_OUTPUT.PUT_LINE('               only to override this if you believe your data will');
    DBMS_OUTPUT.PUT_LINE('               have this sequence in it. I ALWAYS add the OS ''end of');
    DBMS_OUTPUT.PUT_LINE('               line'' marker to this sequence, you should not.');
    DBMS_OUTPUT.PUT_LINE('p_ctl        = YES - Default, output a control file.');
    DBMS_OUTPUT.PUT_LINE('                NO - No control file.');
    DBMS_OUTPUT.PUT_LINE('p_header     = YES - Output a column header line in the .dat file.');
    DBMS_OUTPUT.PUT_LINE('                NO - Default, no header.');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('NOTE: In SQL*Plus set the following for best results:');
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('      SET SERVEROUTPUT ON SIZE 1000000 FORMAT TRUNCATED');
  END help;
  --
  --
end unloader;
/
--
SET ARRAYSIZE 1;
SHOW ERRORS;
