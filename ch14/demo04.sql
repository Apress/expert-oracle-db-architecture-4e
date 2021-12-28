-- Setting Up for Locally-Managed Tablespaces
-- Run from command line:
-- sqlldr eoda/foo@PDB1 big_table.ctl external_table=generate_only
--

create or replace directory my_dir as '/tmp/';

drop table big_table_et;

CREATE TABLE "BIG_TABLE_ET"
(
  "ID" NUMBER,
  "OWNER" VARCHAR2(128),
  "OBJECT_NAME" VARCHAR2(128),
  "SUBOBJECT_NAME" VARCHAR2(128),
  "OBJECT_ID" NUMBER,
  "DATA_OBJECT_ID" NUMBER,
  "OBJECT_TYPE" VARCHAR2(23),
  "CREATED" VARCHAR2(20),
  "LAST_DDL_TIME" VARCHAR2(20),
  "TIMESTAMP" VARCHAR2(19),
  "STATUS" VARCHAR2(7),
  "TEMPORARY" VARCHAR2(5),
  "GENERATED" VARCHAR2(5),
  "SECONDARY" VARCHAR2(5),
  "NAMESPACE" NUMBER,
  "EDITION_NAME" VARCHAR2(128)
)
ORGANIZATION external
(
TYPE oracle_loader
DEFAULT DIRECTORY my_dir
ACCESS PARAMETERS
(
   records delimited  by newline
   fields  terminated by '|'
   missing field values are null
)
location
(
'big_table.dat'
)
)REJECT LIMIT UNLIMITED
/

alter table big_table_et PARALLEL;

select count(*) from big_table_et;
