-- Data Pump Files

create or replace directory tmp as '/tmp';
 
create table all_objects_unload
    organization external
    ( type oracle_datapump
      default directory TMP
      location( 'allobjects.dat' )
    )
    as
    select * from all_objects
/

create table t
( OWNER            VARCHAR2(30),
  OBJECT_NAME      VARCHAR2(30),
  SUBOBJECT_NAME   VARCHAR2(30),
  OBJECT_ID        NUMBER,
  DATA_OBJECT_ID   NUMBER,
  OBJECT_TYPE      VARCHAR2(19),
  CREATED          DATE,
  LAST_DDL_TIME    DATE,
  TIMESTAMP        VARCHAR2(19),
  STATUS           VARCHAR2(7),
  TEMPORARY        VARCHAR2(1),
  GENERATED        VARCHAR2(1),
  SECONDARY        VARCHAR2(1)
)
organization external
( type oracle_datapump
  default directory TMP
  location( 'allobjects.dat' )
);
