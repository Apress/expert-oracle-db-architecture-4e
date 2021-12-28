-- Monitoring the Filesystem through SQL 

create or replace directory exec_dir as '/orahome/oracle/bin';

grant execute on directory exec_dir to eoda;

drop table df purge;

create table df
  (
   fsname   varchar2(100),
   blocks   number,
   used     number,
   avail    number,
   capacity varchar2(10),
   mount    varchar2(100)
  )
  organization external
  (
    type oracle_loader
    default directory exec_dir
    access parameters
    (
      records delimited
      by newline
      preprocessor
      exec_dir:'run_df.bsh'
      skip 1
      fields terminated by
      whitespace ldrtrim
    )
    location
    (
      exec_dir:'run_df.bsh'
    )
  )
/

set lines 132
column fsname       format a35
column mount        format a10
column file_name    format a40
column mbytes       format 999,999,999
column tot_mbytes   format 999,999,999
column avail_mbytes format 999,999,999
column status       format A6

select * from df;

with fs_data
  as
  (select /*+ materialize */ *
     from df
  )
  select mount,
         file_name,
         bytes/1024/1024 mbytes,
         tot_bytes/1024/1024 tot_mbytes,
         avail_bytes/1024/1024 avail_mbytes,
         case
         when 0.2 * tot_bytes < avail_bytes
         then 'OK'
         else 'Short on disk space'
          end status
    from (
  select file_name, mount, avail_bytes, bytes,
         sum(bytes) over
           (partition by mount) tot_bytes
    from (
  select a.file_name,
         b.mount,
         b.avail*1024 avail_bytes, a.bytes,
         row_number() over
           (partition by a.file_name
            order by length(b.mount) DESC) rn
    from dba_data_files a,
         fs_data b
   where a.file_name
             like b.mount || '%'
         )
   where rn = 1
         )
   order by mount, file_name
/
