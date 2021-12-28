-- Alert log

select value || instance_name from v$diag_info, v$instance where name = 'Diag Trace';

select value || '/alert_' || instance_name || '.log' from v$diag_info, v$instance
where name = 'Diag Trace';

select record_id,
    to_char(originating_timestamp,'DD.MM.YYYY HH24:MI:SS'),
    message_text
from x$dbgalertext
where message_text like '%ORA-%';
