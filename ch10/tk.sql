column trace new_val TRACE format a100

select i.value || '/' || d.instance_name || '_ora_' || a.spid || '.trc' trace
from v$process a, v$session b, v$diag_info i , v$instance d
where a.addr = b.paddr
and b.audsid = userenv('sessionid')
and i.name='Diag Trace';

disconnect
!tkprof &TRACE ./tk.prf &1
-- connect /
connect eoda/foo@PDB1
edit tk.prf
