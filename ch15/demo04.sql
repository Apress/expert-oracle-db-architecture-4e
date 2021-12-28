-- Reading and Filtering Compressed Files in a Directory Tree, search_dir.bsh

host mkdir -p /tmp/base

host echo 'base row1 col1, base row1 col2' | gzip > /tmp/base/filebase.csv.gz
host echo 'base row2 col1, base row2 col2' | gzip >> /tmp/base/filebase.csv.gz

create or replace directory exec_dir as '/orahome/oracle/bin';
create or replace directory data_dir as '/tmp/base';

drop table csv;

create table csv
  ( col1 varchar2(20)
  )
  organization external
  (
   type oracle_loader
   default directory data_dir
   access parameters
    (
      records delimited by newline
      preprocessor exec_dir:'search_dir.bsh'
      fields terminated by ',' ldrtrim
    )
    location
    (
      data_dir:'filebase.csv.gz'
    )
)
/

select * from csv;
