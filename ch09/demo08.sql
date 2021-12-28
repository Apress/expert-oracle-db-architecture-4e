-- Setting NOLOGGING on an Index

set echo on

select log_mode from v$database;
create index t_idx on t(object_name);

variable redo number
exec :redo := get_stat_val( 'redo size' );

alter index t_idx rebuild;

exec dbms_output.put_line( (get_stat_val('redo size')-:redo) || ' bytes of redo generated...');

alter index t_idx nologging;

exec :redo := get_stat_val( 'redo size' );

alter index t_idx rebuild;

exec dbms_output.put_line( (get_stat_val('redo size')-:redo) || ' bytes of redo generated...');
