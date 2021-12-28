OUNDEX, 3rd example

exec stats.cnt := 0

variable cpu number
exec :cpu := dbms_utility.get_cpu_time

set lines 132
set autotrace on explain

select ename, hiredate
from emp
where substr(my_soundex(ename),1,6) = my_soundex('Kings')
/

set autotrace off
set serverout on

begin
          dbms_output.put_line
          ( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
          dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/
