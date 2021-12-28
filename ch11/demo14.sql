-- MY_SOUNDEX, view example

set echo on

create or replace view emp_v
  as
  select ename, substr(my_soundex(ename),1,6) ename_soundex, hiredate
from emp
/

exec stats.cnt := 0;
exec :cpu := dbms_utility.get_cpu_time

select ename, hiredate
from emp_v
where ename_soundex = my_soundex('Kings');

set serverout on
begin
          dbms_output.put_line
          ( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
          dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/
