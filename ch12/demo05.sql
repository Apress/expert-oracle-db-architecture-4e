-- Extended Datatypes

drop table t purge;
drop table c purge;

set echo on

create table t(et varchar2(32727)) tablespace users;
--
insert into t values(rpad('abc',10000,'abc'));
select substr(et,9500,10) from t where UPPER(et) like 'ABC%';
--
select table_name, column_name, segment_name, tablespace_name, in_row
from user_lobs where table_name='T';
--
create table c(c clob);
