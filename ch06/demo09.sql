-- INITTRANS

drop table t purge;

create table t ( x int );
insert into t values ( 1 );
select dbms_rowid.ROWID_BLOCK_NUMBER(rowid)  from t;

column b new_val B
column f new_val F

select dbms_rowid.ROWID_BLOCK_NUMBER(rowid) B,
           dbms_rowid.ROWID_TO_ABSOLUTE_FNO( rowid, user, 'T' ) F
           from t;

alter system dump datafile &F block &B;

column trace new_val TRACE
 
select c.value || '/' || d.instance_name || '_ora_' || a.spid || '.trc' trace
       from v$process a, v$session b, v$diag_info c, v$instance d
      where a.addr = b.paddr
        and b.audsid = userenv('sessionid')
       and c.name = 'Diag Trace';

disconnect
edit &TRACE

