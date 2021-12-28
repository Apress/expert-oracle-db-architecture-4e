-- IN ROW Clause, second example

set echo on

create sequence s start with 100000;
 
alter session set tracefile_identifier='tk';

declare
     l_cnt    number;
     l_data   varchar2(32765);
begin
          dbms_monitor.session_trace_enable;
          for i in 1 .. 100
          loop
                  update t set in_row  = 
                  to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') where id = i;
                  update t set out_row = 
                  to_char(sysdate,'dd-mon-yyyy hh24:mi:ss') where id = i;
                  insert into t (id, in_row) values ( s.nextval, 'Hello World' );
                  insert into t (id,out_row) values ( s.nextval, 'Hello World' );
          end loop;
end;
/

EXEC DBMS_MONITOR.session_trace_disable;
