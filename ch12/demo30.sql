-- Read Consistency for LOBs

drop table t purge;

set echo on

create table t
  ( id int   primary key,
    txt      clob
  )
  lob( txt) store as ( disable storage in row )
/

insert into t values ( 1, 'hello world' );

commit;

declare
  l_clob  clob;
  cursor c is select id from t;
  l_id    number;
begin
  select txt into l_clob from t;
  open c;
    update t set id = 2, txt = 'Goodbye';
    commit;
    dbms_output.put_line( dbms_lob.substr( l_clob, 100, 1 ) );
    fetch c into l_id;
    dbms_output.put_line( 'id = ' || l_id );
  close c;
end;
/

select * from t;
