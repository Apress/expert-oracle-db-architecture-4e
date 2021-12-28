-- Mystat example

define PDB=PDB1

conn eoda/foo@&&PDB

column name form a30

@mystat "redo size"

update big_table set owner = lower(owner)
where rownum <= 1000;

commit;

@mystat2
