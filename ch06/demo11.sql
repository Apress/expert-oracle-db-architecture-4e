-- DDL locks

set echo on

drop table t purge;
create table t as select * from all_objects;

select object_id from user_objects where object_name = 'T';

create index t_idx on t(owner,object_type,object_name) ONLINE;

-- Run this from another session while the index is being built.
select (select username
from v$session
where sid = v$lock.sid) username,
sid,
id1,
id2,
lmode,
request, block, v$lock.type
from v$lock
where id1 = &&your_object_id;
