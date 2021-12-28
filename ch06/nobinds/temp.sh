echo exec statspack.snap | sqlplus / as sysdba                                  
sqlplus eoda/foo@PDB1 @nb.sql 1 &                                               
sqlplus eoda/foo@PDB1 @nb.sql 2 &                                               
wait                                                                            
echo exec statspack.snap | sqlplus / as sysdba                                  
