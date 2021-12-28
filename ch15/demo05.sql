-- Trimming Characters Out of a File

create or replace directory data_dir as '/tmp';
create or replace directory exec_dir as '/orahome/oracle/bin';

drop table csv2;

create table csv2
      ( col1 varchar2(20)
       ,col2 varchar2(20)
      )
      organization external
      (
       type oracle_loader
       default directory data_dir
       access parameters
       (
         records delimited by newline
         preprocessor exec_dir:'run_sed.bsh'
         fields terminated by '|' ldrtrim
       )
       location
       (
         data_dir:'load.csv'
       )
   )
   /

select * from csv2;
select length(col2) from csv2;
