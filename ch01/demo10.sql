-- Make Sure You Can Adapt, automatic population of column 

drop sequence s;
drop table t purge;

set echo on

create sequence s;

create table t
  ( x          number
               default s.nextval
               constraint t_pk primary key,
    other_data varchar2(20)
  )
/

drop table t purge;
create table t
  ( x          number
               generated as identity 
               constraint t_pk primary key,
    other_data varchar2(20)
  )
/

drop table t purge;

create table t
  ( pk number primary key,
    other_data varchar2(20)
  )
/

create sequence t_seq;

create trigger t before insert on t
  for each row
  begin
          :new.pk := t_seq.nextval;
  end;
/
