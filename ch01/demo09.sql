-- Make Sure You Can Adapt
-- Isolation levels

drop table id_table purge;

set echo on

create table id_table
  ( id_name  varchar2(30) primary key,
    id_value number );

insert into id_table values ( 'MY_KEY', 0 );

commit;

update id_table
     set id_value = id_value+1
   where id_name = 'MY_KEY';

select id_value
    from id_table
   where id_name = 'MY_KEY';

commit;

set transaction isolation level serializable;

update id_table
   set id_value = id_value+1
   where id_name = 'MY_KEY';

-- Leave the session above going, and in another terminal create another session.
-- From a 2nd session

set transaction isolation level serializable;

update id_table
   set id_value = id_value+1
   where id_name = 'MY_KEY';

-- In 1st session
commit;

-- In 2nd session, should throw an error
