-- TM (DML Enqueue) Locks

drop table t1 purge;
drop table t2 purge;

set echo on

create table t1 ( x int );
create table t2 ( x int );

insert into t1 values ( 1 );

insert into t2 values ( 1 );

col username form a15

select (select username
            from v$session
           where sid = v$lock.sid) username,
         sid,
         id1,
         id2,
         lmode,
         request, block, v$lock.type
    from v$lock
where sid = sys_context('userenv','sid');

column object_name form a15

select object_name, object_id from user_objects where object_name in ('T1','T2');
