echo exec statspack.snap | sqlplus / as sysdba
sqlplus eoda/foo@PDB1 @b.sql 1 &
sqlplus eoda/foo@PDB1 @b.sql 2 &
wait
echo exec statspack.snap | sqlplus / as sysdba
