-- MY_SOUNDEX, function example, virtual column

set echo on

drop index emp_soundex_idx;

alter table emp
  add
  ename_soundex as
  (substr(my_soundex(ename),1,6));

create index emp_soundex_idx
on emp(ename_soundex);

exec stats.cnt := 0;

exec :cpu := dbms_utility.get_cpu_time

select ename, hiredate
from emp
where ename_soundex = my_soundex('Kings');

set serverout on
begin
          dbms_output.put_line
          ( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
          dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/
