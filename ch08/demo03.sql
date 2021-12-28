-- THE "WHEN OTHERS" CLAUSE

set echo on

set linesize 1000
clear screen

alter session set
  PLSQL_Warnings = 'enable:all'
/

create or replace procedure some_proc( p_str in varchar2 )
  as
  begin
          dbms_output.put_line( p_str );
  exception
    when others
    then
      -- call some log_error() routine
      null;
  end;
/

show errors procedure some_proc
