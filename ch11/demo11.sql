-- MY_SOUNDEX example

-- May need to "drop view stats" if created previously.

set echo on lines 132

create or replace package stats
  as
         cnt number default 0;
end;
/

create or replace
function my_soundex( p_string in varchar2 ) return varchar2
deterministic
as
    l_return_string varchar2(6) default substr( p_string, 1, 1 );
    l_char          varchar2(1);
    l_last_digit    number default 0;

    type vcArray is table of varchar2(10) index by binary_integer;
    l_code_table    vcArray;
begin
    stats.cnt := stats.cnt+1;
    l_code_table(1) := 'BPFV';
    l_code_table(2) := 'CSKGJQXZ';
    l_code_table(3) := 'DT';
    l_code_table(4) := 'L';
    l_code_table(5) := 'MN';
    l_code_table(6) := 'R';
    for i in 1 .. length(p_string)
    loop
        exit when (length(l_return_string) = 6);
        l_char := upper(substr( p_string, i, 1 ) );

        for j in 1 .. l_code_table.count
        loop
        if (instr(l_code_table(j), l_char ) > 0 AND j <> l_last_digit)
        then
            l_return_string := l_return_string || to_char(j,'fm9');
            l_last_digit := j;
        end if;
        end loop;
    end loop;
    return rpad( l_return_string, 6, '0' );
end;
/

variable cpu number
exec :cpu := dbms_utility.get_cpu_time

set autotrace on explain

select ename, hiredate
from emp
where my_soundex(ename) = my_soundex('Kings');

set autotrace off
set serverout on

begin
          dbms_output.put_line
          ( 'cpu time = ' || round((dbms_utility.get_cpu_time-:cpu)/100,2) );
          dbms_output.put_line( 'function was called: ' || stats.cnt );
end;
/
