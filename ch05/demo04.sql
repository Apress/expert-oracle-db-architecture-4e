-- Shared Server connections

set echo on

column username format a9
column sid      format 99999
column serial#  format 9999999
column program  format a21

select a.username, a.sid, a.serial#, a.server,
         a.paddr, a.status, b.program
    from v$session a left join v$process b
      on (a.paddr = b.addr)
   where a.username = 'EODA';
