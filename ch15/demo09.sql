-- How Do I Load LOBs?

create or replace directory dir1   as '/tmp/';
create or replace directory "dir2" as '/tmp/';

drop table demo purge;

set echo on

create table demo
  ( id        int primary key,
    theClob   clob
  )
/

host echo 'Hello World!' > /tmp/test.txt

declare
      l_clob    clob;
      l_bfile   bfile;
  begin
      insert into demo values ( 1, empty_clob() )
       returning theclob into l_clob;

      l_bfile := bfilename( 'DIR1', 'test.txt' );
      dbms_lob.fileopen( l_bfile );

      dbms_lob.loadfromfile( l_clob, l_bfile, dbms_lob.getlength( l_bfile ) );

      dbms_lob.fileclose( l_bfile );
  end;
/

column theclob format a30
select dbms_lob.getlength(theClob), theClob from demo
/

-- If you get ??? in the output, character set adjustment
drop table demo purge;

create table demo
  ( id        int primary key,
    theClob   clob
  )
/

host echo 'Hello World!' > /tmp/test.txt

declare
   l_clob    clob;
   l_bfile   bfile;
   dest_offset integer := 1;
   src_offset integer := 1;
   src_csid number := NLS_CHARSET_ID('WE8ISO8859P1');
   lang_context integer := dbms_lob.default_lang_ctx;
   warning integer;
  begin
      insert into demo values ( 1, empty_clob() )
       returning theclob into l_clob;
      l_bfile := bfilename( 'dir2', 'test.txt' );
      dbms_lob.fileopen( l_bfile );
      dbms_lob.loadclobfromfile( l_clob, l_bfile, dbms_lob.getlength( l_bfile ), dest_offset, src_offset, src_csid, lang_context,warning );
      dbms_lob.fileclose( l_bfile );
  end;
/

select dbms_lob.getlength(theClob), theClob from demo
/
