-- The System Global Area

set echo on

compute sum of bytes on pool
break on pool skip 1

select pool, name, bytes
   from v$sgastat
   order by pool, name;

show parameter sga_target

select component, granule_size from v$sga_dynamic_components;
