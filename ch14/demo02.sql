-- Parallel DML

set echo on

alter session enable parallel dml;

select pdml_enabled from v$session
where sid= sys_context('userenv','sid');

update big_table set status = 'done';

column program format a30
column trans_id form a20

select a.sid, a.program, b.start_time, b.used_ublk,
b.xidusn ||'.'|| b.xidslot || '.' || b.xidsqn trans_id
from v$session a, v$transaction b
where a.taddr = b.addr
and a.sid in ( select sid
from v$px_session
where qcsid = 258)
order by sid
/

explain plan for update big_table set status = 'done';
select * from table(dbms_xplan.display(null,null,'BASIC +PARALLEL'));

select name, value from v$statname a, v$mystat b
where a.statistic# = b.statistic# and name like '%parallel%';
