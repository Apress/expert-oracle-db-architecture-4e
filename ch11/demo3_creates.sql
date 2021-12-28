drop table t purge;
drop sequence s;

create table t tablespace assm
as
select 0 id, owner, object_name, subobject_name,
  object_id, data_object_id, object_type, created,
  last_ddl_time, timestamp, status, temporary,
  generated, secondary
from all_objects a
where 1=0;

alter table t
add constraint t_pk
primary key (id)
using index (create index t_pk on t(id) &1 tablespace assm);

create sequence s cache 1000;

create or replace procedure do_sql
as
begin
    for x in ( select rownum r, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
               OBJECT_ID, DATA_OBJECT_ID, OBJECT_TYPE, CREATED,
               LAST_DDL_TIME, TIMESTAMP, STATUS, TEMPORARY,
               GENERATED, SECONDARY from all_objects )
    loop
        insert into t
        ( id, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
          OBJECT_ID, DATA_OBJECT_ID, OBJECT_TYPE, CREATED,
          LAST_DDL_TIME, TIMESTAMP, STATUS, TEMPORARY,
          GENERATED, SECONDARY )
        values
        ( s.nextval, x.OWNER, x.OBJECT_NAME, x.SUBOBJECT_NAME,
          x.OBJECT_ID, x.DATA_OBJECT_ID, x.OBJECT_TYPE, x.CREATED,
          x.LAST_DDL_TIME, x.TIMESTAMP, x.STATUS, x.TEMPORARY,
          x.GENERATED, x.SECONDARY );
        if ( mod(x.r,100) = 0 )
        then
            commit;
        end if;
    end loop;
    commit;
end;
/
