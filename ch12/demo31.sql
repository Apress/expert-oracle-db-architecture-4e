-- BFILEs

drop table t purge;

set echo on

create table t
  ( id       int primary key,
    os_file  bfile);

create or replace directory my_dir as '/tmp/';

insert into t values ( 1, bfilename( 'MY_DIR', 'test.dmp' ) );

!dd if=/dev/zero of=/tmp/test.dmp bs=1056768 count=1

select dbms_lob.getlength(os_file) from t;
update t set os_file = bfilename( 'my_dir', 'test.dmp' );
select dbms_lob.getlength(os_file) from t;

create or replace directory "my_dir" as '/tmp/';

select dbms_lob.getlength(os_file) from t;
