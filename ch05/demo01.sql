-- Dedicated Server Connections

set echo on

select a.spid    dedicated_server, b.process clientpid
from v$process a, v$session b
where a.addr = b.paddr
and   b.sid = sys_context('userenv','sid');

/* -- alternate way of selecting
select
 a.spid    dedicated_server
,b.process clientpid
from v$process a -- shows dedicated server process ID
    ,v$session b -- shows client process ID
where a.addr = b.paddr
and   b.sid = (select sid from v$mystat where rownum=1);
*/

