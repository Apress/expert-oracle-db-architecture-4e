-- Tagging trace files

alter session set tracefile_identifier = 'Look_For_Me';

!ls /opt/oracle/diag/rdbms/cdb/CDB/trace/*Look_For_Me*

exec dbms_monitor.session_trace_enable

!ls /opt/oracle/diag/rdbms/cdb/CDB/trace/*Look_For_Me*
