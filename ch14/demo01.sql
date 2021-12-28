-- Parallel Query

set echo on

select count(status) from big_table;

explain plan for select count(status) from big_table;

select * from table(dbms_xplan.display(null, null,
'TYPICAL -ROWS -BYTES -COST'));

alter table big_table parallel 4;
alter table big_table parallel;

explain plan for select count(status) from big_table;

select * from table(dbms_xplan.display(null, null,
'TYPICAL -ROWS -BYTES -COST'));

select sid from v$mystat where rownum = 1;

select sid, qcsid, server#, degree
from v$px_session
where qcsid = 74
/

select sid, username, program
from v$session
where sid in ( select sid
from v$px_session
where qcsid = 74 )
/
