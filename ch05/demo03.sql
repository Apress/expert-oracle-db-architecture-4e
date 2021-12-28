-- Connections vs. Sessions, part 2

set echo on

select * from v$session where username = 'EODA';

select username, program
  from v$process
  where addr = hextoraw( '000000007850D488' );

select username, sid, serial#, server, paddr, status
  from v$session
  where username = USER;
