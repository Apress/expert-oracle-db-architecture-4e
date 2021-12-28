-- Index Organized Tables, example 2

set echo on

exec dbms_monitor.session_trace_enable;
begin
      for x in ( select empno from emp )
      loop
          for y in ( select emp.ename, a.street, a.city, a.state, a.zip
                       from emp, heap_addresses a
                       where emp.empno = a.empno
                       and emp.empno = x.empno )
          loop
             null;
          end loop;
      end loop;
end;
/

begin
      for x in ( select empno from emp )
      loop
          for y in ( select emp.ename, a.street, a.city, a.state, a.zip
                       from emp, iot_addresses a
                       where emp.empno = a.empno
                       and emp.empno = x.empno )
          loop
             null;
          end loop;
      end loop;
end;
/
exec dbms_monitor.session_trace_disable;
-- tk.sql is in the ch00 directory 
@tk.sql "sys=no"

set serverout on

exec runStats_pkg.rs_start;
begin
    for x in ( select empno from emp )
    loop
        for y in ( select emp.ename, a.street, a.city, a.state, a.zip
                     from emp, heap_addresses a
                    where emp.empno = a.empno
                      and emp.empno = x.empno )
        loop
            null;
        end loop;
     end loop;
end;
/
exec runStats_pkg.rs_middle;
begin
    for x in ( select empno from emp )
    loop
        for y in ( select emp.ename, a.street, a.city, a.state, a.zip
                     from emp, iot_addresses a
                    where emp.empno = a.empno
                      and emp.empno = x.empno )
        loop
            null;
        end loop;
     end loop;
end;
/

exec runStats_pkg.rs_stop;
