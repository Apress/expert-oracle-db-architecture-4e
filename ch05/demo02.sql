-- Connections vs. Sessions, part 1

set echo on

column username format a15

select username, sid, serial#, server, paddr, status
   from v$session
   where username = USER;

set autotrace on statistics

select username, sid, serial#, server, paddr, status
   from v$session
   where username = USER;
