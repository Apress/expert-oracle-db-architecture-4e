-- DDL Locks

column owner format a8
column sid   format 99999
column name  format a21
column held  format a10
column request format a8
column type format a20

set linesize 1000
select session_id sid, owner, name, type,
         mode_held held, mode_requested request
    from dba_ddl_locks
   where session_id = (select sid from v$mystat where rownum=1);

create or replace procedure p
  as
  begin
   null;
  end;
/

exec p

select session_id sid, owner, name, type,
         mode_held held, mode_requested request
    from dba_ddl_locks
   where session_id = (select sid from v$mystat where rownum=1);

alter procedure p compile;

select session_id sid, owner, name, type,
         mode_held held, mode_requested request
    from dba_ddl_locks
   where session_id = (select sid from v$mystat where rownum=1);
