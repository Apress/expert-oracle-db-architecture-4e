-- Consistent Reads and Current Reads

exec dbms_monitor.session_trace_enable
select * from t;
update t t1 set x = x+1;
update t t2 set x = x+1;

select i.value || '/' || d.instance_name || '_ora_' || a.spid || '.trc' trace
from v$process a, v$session b, v$diag_info i , v$instance d
where a.addr = b.paddr
and b.audsid = userenv('sessionid')
and i.name='Diag Trace';

cd <trace file directory>
tkprof <tracefile name> sys=no output=myfile.txt

-- Open output file with an editor 
vi myfile.txt
