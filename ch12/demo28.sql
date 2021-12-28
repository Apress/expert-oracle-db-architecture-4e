-- IN ROW Clause

drop table t purge;

set echo on

create table t
  ( id int   primary key,
    in_row   clob,
    out_row  clob
  )
  lob (in_row)  store as ( enable  storage in row )
  lob (out_row) store as ( disable storage in row )
/

insert into t
  select rownum,
         owner || ' ' || object_name || ' ' || object_type || ' ' || status,
         owner || ' ' || object_name || ' ' || object_type || ' ' || status
    from all_objects
/

commit;

alter session set tracefile_identifier='tk';
EXEC DBMS_MONITOR.session_trace_enable;

declare
          l_cnt    number;
          l_data   varchar2(32765);
begin
          select count(*)
            into l_cnt
            from t;

          dbms_monitor.session_trace_enable;
          for i in 1 .. l_cnt
          loop
                  select in_row  into l_data from t where id = i;
                  select out_row into l_data from t where id = i;
          end loop;
end;
/

EXEC DBMS_MONITOR.session_trace_disable;
